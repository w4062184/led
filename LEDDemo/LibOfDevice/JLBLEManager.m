//
//  JLBLEManager.m
//  Jan_Lion
//
//  Created by Jan Lion on 14-8-26.
//  Copyright (c) 2014年 Lion Jan. All rights reserved.
//

#import "JLBLEManager.h"
#import "Tuner168_BLE_IOS_SDK_V1.h"

#define kTimeInterval    1.5f

@interface JLBLEManager()<Tuner168_BLE_IOS_SDK_Delegate>

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIAlertView *connectedAlertView;
@property (nonatomic, strong) UIAlertView *disconnectedAlertView;
@property (nonatomic, strong) NSMutableArray *receiveData;

@end

@implementation JLBLEManager

+ (NSString *)hexRepresentationWithData:(NSData *)theData withSymbol:(NSString *)symbol
{
    const unsigned char* bytes = (const unsigned char*)[theData bytes];
    NSUInteger nbBytes = [theData length];
    NSUInteger strLen = 2*nbBytes;
    
    NSMutableString* hex = [[NSMutableString alloc] initWithCapacity:strLen];
    for(NSUInteger i=0; i<nbBytes; ) {
        [hex appendFormat:@"%02X%@", bytes[i], symbol];
        ++i;
    }
    [hex deleteCharactersInRange:NSMakeRange(hex.length - 1, 1)];
    return hex;
}

+ (NSString *)toBinary:(NSUInteger)input
{
    if (input == 1 || input == 0)
        return [NSString stringWithFormat:@"%lu", input];
    return [NSString stringWithFormat:@"%@%lu", [self toBinary:input / 2], input % 2];
}

+ (int)toDecimalWithHexString:(NSString *)hexString
{
    unsigned int hexToInt;
    [[NSScanner scannerWithString:hexString] scanHexInt:&hexToInt];
    
    return hexToInt;
}

+ (NSString *)toBinaryWithHexString:(NSString *)hexString
{
    unsigned hexAsInt;
    [[NSScanner scannerWithString:hexString] scanHexInt:&hexAsInt];
    NSString *moduleBinary = [NSString stringWithFormat:@"%@", [JLBLEManager toBinary:hexAsInt]];
    // // NSLog(@"hex:%@ - binary:%@", hexString, moduleBinary);
    
    return moduleBinary;
}

+ (JLBLEManager *)sharedBLEManager
{
    static JLBLEManager *instance = nil;
    
    if (instance == nil) {
        instance = [[JLBLEManager alloc] init];
    }
    
    return instance;
}

- (id)init
{
    if (self = [super init]) {
        self.manager = [[Tuner168_BLE_IOS_SDK alloc] init];
        self.manager.delegate = self;
        self.receiveData = [NSMutableArray array];
        
        self.connectedAlertView = [[UIAlertView alloc] initWithTitle:@"蓝牙连接" message:@"连接设备成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        self.disconnectedAlertView = [[UIAlertView alloc] initWithTitle:@"蓝牙连接" message:@"与一个设备已断开连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
    }
    
    return self;
}

- (void)findPeripherals
{
    [self.manager findBLEPeripherals:30];
    [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(checkFoundPeripherals:) userInfo:nil repeats:YES];
}

- (void)checkFoundPeripherals:(NSTimer *)timer
{
    if (self.manager.foundPeripherals.count) {
        [timer invalidate];
        self.foundPeripherals = self.manager.foundPeripherals;
        [self.delegate bleManagerDidFindPeripherals];
    }
}

- (void)connectPeripherals
{
    for (CBPeripheral *peripheral in self.manager.foundPeripherals) {
        [self.manager connectPeripheral:peripheral];
    }
    [NSTimer scheduledTimerWithTimeInterval:kTimeInterval target:self selector:@selector(connectingPeripherals) userInfo:nil repeats:NO];
}

- (void)connectingPeripherals
{
    [self sendInstruction:@"887251055653303031"];
    // bleManager.sendInstruction("887251055653303031");
    [self.delegate bleManagerDidConnectPeripherals];
}

- (void)disconnectPeripherals
{
    for (CBPeripheral *peripheral in _manager.foundPeripherals) {
        [self.manager disconnectPeripheral:peripheral];
    }
    [self.delegate bleManagerDidDisconnectPeripherals];
}

- (void)checkState
{
    if (_manager.activePeripheral == nil || _manager.activePeripheral.state == CBPeripheralStateDisconnected) {
        if (!_disconnectedAlertView.visible) {
            [_disconnectedAlertView show];
            [_timer invalidate];
            _timer = nil;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kBLEManagerDidDisconnectNotification object:nil];
    }
}

- (void)sendInstruction:(NSString *)instruction
{
    [self.manager Send_Data:instruction];
}

- (void)getModules
{
    __block NSString *moduleString = nil;
    
    [self.receiveData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        NSString *string = (NSString *)obj;
        
        NSRange moduleTargetRange = [string rangeOfString:@"88712101"];
        if (moduleTargetRange.length) {
            moduleString = [[string substringWithRange:NSMakeRange(moduleTargetRange.length + moduleTargetRange.location, 1*2)] copy];
            *stop = true;
        }
    }];
    
    // 使用的模块选择
    NSString *moduleBinary = [JLBLEManager toBinaryWithHexString:moduleString];
    
    NSArray *modules = @[@"Clock", @"Color", @"Temp", @"Player", @"Music"];
    NSMutableSet *selectedModules = [NSMutableSet set];
    
    for (int i = 0; i < moduleBinary.length; i++) {
        char c = [moduleBinary characterAtIndex:i];
        if (c == '1') {
            [selectedModules addObject:modules[i]];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(bleManagerWithModules:)]) {
        [self.delegate bleManagerWithModules:selectedModules];
    }

}

- (void)getClocks
{
    __block NSMutableArray *clocks = [NSMutableArray array];
    __block NSString *clockString = nil;
    
    [self.receiveData enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        NSString *string = (NSString *)obj;
        
        NSRange clockTargetRange = [string rangeOfString:@"88715001"];
        NSRange clock1TargetRange = [string rangeOfString:@"88715103"];
        NSRange clock2TargetRange = [string rangeOfString:@"88715203"];
        NSRange clock3TargetRange = [string rangeOfString:@"88715303"];
        
        if (clockTargetRange.length) {
            clockString = [[string substringWithRange:NSMakeRange(clockTargetRange.length + clockTargetRange.location, 1*2)] copy];
            *stop = YES;
        }
        if (clock1TargetRange.length) {
            NSString *clock = [string substringWithRange:NSMakeRange(clock1TargetRange.length + clock1TargetRange.location, 3*2)];
            [clocks addObject:clock];
        }
        if (clock2TargetRange.length) {
            NSString *clock = [string substringWithRange:NSMakeRange(clock2TargetRange.length + clock2TargetRange.location, 3*2)];
            [clocks addObject:clock];
        }
        if (clock3TargetRange.length) {
            NSString *clock = [string substringWithRange:NSMakeRange(clock3TargetRange.length + clock3TargetRange.location, 3*2)];
            [clocks addObject:clock];
        }
    }];

    // 预设的闹钟
    int clockCount = [JLBLEManager toDecimalWithHexString:clockString];
    
    int clock1Hour = [JLBLEManager toDecimalWithHexString:[clocks[0] substringToIndex:2]];
    int clock1Minute = [JLBLEManager toDecimalWithHexString:[clocks[0] substringWithRange:NSMakeRange(2, 2)]];
    int clock1Switch = [JLBLEManager toDecimalWithHexString:[clocks[0] substringFromIndex:4]];
    NSString *hourFormat1 = (clock1Hour >= 10 ? @"%d" : @"0%d");
    NSString *minuteFormat1 = (clock1Hour >= 10 ? @"%d" : @"0%d");
    NSString *format1 = [NSString stringWithFormat:@"%@:%@", hourFormat1, minuteFormat1];
    NSString *time1 = [NSString stringWithFormat:format1, clock1Hour, clock1Minute];
    NSString *switch1 = clock1Switch > 0 ? @"true" : @"false";
    
    int clock2Hour = [JLBLEManager toDecimalWithHexString:[clocks[1] substringToIndex:2]];
    int clock2Minute = [JLBLEManager toDecimalWithHexString:[clocks[1] substringWithRange:NSMakeRange(2, 2)]];
    int clock2Switch = [JLBLEManager toDecimalWithHexString:[clocks[1] substringFromIndex:4]];
    NSString *hourFormat2 = (clock2Hour >= 10 ? @"%d" : @"0%d");
    NSString *minuteFormat2 = (clock2Hour >= 10 ? @"%d" : @"0%d");
    NSString *format2 = [NSString stringWithFormat:@"%@:%@", hourFormat2, minuteFormat2];
    NSString *time2 = [NSString stringWithFormat:format2, clock2Hour, clock2Minute];
    NSString *switch2 = clock2Switch > 0 ? @"true" : @"false";
    
    int clock3Hour = [JLBLEManager toDecimalWithHexString:[clocks[2] substringToIndex:2]];
    int clock3Minute = [JLBLEManager toDecimalWithHexString:[clocks[2] substringWithRange:NSMakeRange(2, 2)]];
    int clock3Switch = [JLBLEManager toDecimalWithHexString:[clocks[2] substringFromIndex:4]];
    NSString *hourFormat3 = (clock3Hour >= 10 ? @"%d" : @"0%d");
    NSString *minuteFormat3 = (clock3Hour >= 10 ? @"%d" : @"0%d");
    NSString *format3 = [NSString stringWithFormat:@"%@:%@", hourFormat3, minuteFormat3];
    NSString *time3 = [NSString stringWithFormat:format3, clock3Hour, clock3Minute];
    NSString *switch3 = clock3Switch > 0 ? @"true" : @"false";
    
    NSMutableArray *showClocks = [NSMutableArray array];
    NSArray *times = @[@{@"BeginTime":time1, @"Switch":switch1},
                       @{@"BeginTime":time2, @"Switch":switch2},
                       @{@"BeginTime":time3, @"Switch":switch3}];
    for (int i = 0; i < clockCount; i++) {
        [showClocks addObject:times[i]];
    }
    // NSLog(@"showClocks:%@", showClocks);
    
    if ([self.delegate respondsToSelector:@selector(bleManagerWithClocks:)]) {
        [self.delegate bleManagerWithClocks:showClocks];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBLEManagerDidUpdateClockNotification object:nil userInfo:@{@"UpdatedClocks" : showClocks}];
}

- (void)getColors
{
    __block NSString *colorString = nil;
    __block NSMutableArray *colorStrings = [@[] mutableCopy];
    
    [self.receiveData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        NSString *string = (NSString *)obj;
        
        NSRange colorTargetRange = [string rangeOfString:@"88714005"];
        if (colorTargetRange.length) {
            colorString = [string substringWithRange:NSMakeRange(colorTargetRange.length + colorTargetRange.location + 2, 4*2)];
            [colorStrings addObject:colorString];
        }
    }];
    
    // NSLog(@"colors:%@", colorStrings);
    NSMutableArray *colors = [NSMutableArray array];
    
    for (NSString *colorString in colorStrings) {
        NSMutableDictionary *colorInfo = [@{} mutableCopy];
        NSArray *infos = @[@"R", @"G", @"B", @"C"];
        for (int i = 0; i < 4; i++) {
            NSString *subColor = [colorString substringWithRange:NSMakeRange(i * 2, 2)];
            int num = [JLBLEManager toDecimalWithHexString:subColor];
            [colorInfo setValue:[NSString stringWithFormat:@"%d", num] forKey:infos[i]];
        }
        [colors addObject:colorInfo];
    }
    
    // NSLog(@"colorInfos:%@", colors);
    
    if ([self.delegate respondsToSelector:@selector(bleManagerWithColors:)]) {
        [self.delegate bleManagerWithColors:colors];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBLEManagerDidUpdateClockNotification
                                                        object:nil
                                                      userInfo:@{@"UpdatedColors" : colors}];
}

- (void)getTempClocks
{
    __block NSString *clockString = nil;
    __block NSMutableArray *clocks = [NSMutableArray array];
    
    [self.receiveData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        NSString *string = (NSString *)obj;
        
        NSRange tempClockRange = [string rangeOfString:@"88713008"];
        if (tempClockRange.length) {
            clockString = [string substringWithRange:NSMakeRange(tempClockRange.length + tempClockRange.location, 8*2)];
            [clocks addObject:clockString];
        }
    }];
    
    NSMutableArray *tempClocks = [NSMutableArray array];
    
    for (NSString *clock in clocks) {
        NSMutableDictionary *clockInfo = [@{} mutableCopy];
        NSArray *infos = @[@"Light", @"Temp", @"BeginHour",
                           @"BeginMinute", @"EndHour", @"EndMinute", @"Timer", @"No"];
        
        for (int i = 0; i < 8; i++) {
            NSString *subClock = [clock substringWithRange:NSMakeRange(i * 2, 2)];
            int num = [JLBLEManager toDecimalWithHexString:subClock];
            [clockInfo setValue:[NSString stringWithFormat:@"%d", num] forKey:infos[i]];
        }
        [tempClocks addObject:clockInfo];
    }
/*
    NSMutableArray *finalClocks = [NSMutableArray array];
    
    for (NSDictionary *clock in tempClocks) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:clock];
        
        NSString *bHour = clock[@"BeginHour"];
        NSString *bMinute = clock[@"BeginMinute"];
        NSString *format1 = [bHour intValue] > 0 ? @"%@" : @"0%@";
        NSString *format2 = [bMinute intValue] > 0 ? @"%@" : @"0%@";
        NSString *format = [NSString stringWithFormat:@"%@:%@", format1, format2];
        NSString *time = [NSString stringWithFormat:format, bHour, bMinute];
        
        [dict removeObjectForKey:@"BeginHour"];
        [dict removeObjectForKey:@"BeginMinute"];
        [dict setValue:time forKey:@"BeginTime"];
        
        NSString *eHour = clock[@"EndHour"];
        NSString *eMinute = clock[@"EndMinute"];
        format1 = [eHour intValue] > 0 ? @"%@" : @"0%@";
        format2 = [eMinute intValue] > 0 ? @"%@" : @"0%@";
        format = [NSString stringWithFormat:@"%@:%@", format1, format2];
        time = [NSString stringWithFormat:format, eHour, eMinute];
        [dict removeObjectForKey:@"EndHour"];
        [dict removeObjectForKey:@"EndMinute"];
        [dict setValue:time forKey:@"EndTime"];
        [finalClocks addObject:dict];
    }
*/
    // NSLog(@"clockInfos:%@", tempClocks);
    
    
    if ([self.delegate respondsToSelector:@selector(bleManagerWithTempClocks:)]) {
        [self.delegate bleManagerWithTempClocks:tempClocks];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBLEManagerDidUpdateTempClockNotification object:nil userInfo:@{@"UpdatedTempClocks" : tempClocks}];
}

- (void)getTempStatus
{
    NSMutableArray *status = [@[] mutableCopy];
    
    [self.receiveData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        NSString *string = (NSString *)obj;
        
        NSRange range = [string rangeOfString:@"88713202"];
        if (range.length) {
            NSString *subString = [string substringWithRange:NSMakeRange(range.length + range.location, 2*2)];
            [status addObject:subString];
        }
        
        range = [string rangeOfString:@"88713303"];
        if (range.length) {
            NSString *subString = [string substringWithRange:NSMakeRange(range.length + range.location, 3 * 2)];
            [status addObject:subString];
            *stop = YES;
        }
    }];
    
    // NSLog(@"tempStatus:%@", status);
    
    if ([status count] >= 2) {
        NSString *switchStatus = [status firstObject];
        int switchCount = [JLBLEManager toDecimalWithHexString:[switchStatus substringToIndex:2]];
        int switch1On = 0;
        int switch2On = 0;
        NSString *turn = [switchStatus substringFromIndex:2];

        if ([turn isEqualToString:@"01"]) {
            switch1On = 1;
        }
        else if ([turn isEqualToString:@"02"]) {
            switch2On = 1;
        }
        else if ([turn isEqualToString:@"03"]) {
            switch1On = 1;
            switch2On = 1;
        }
        
        NSString *value = [status lastObject];
        NSString *hasTempSlider = [value substringToIndex:2];
        int hasTemp = [JLBLEManager toDecimalWithHexString:hasTempSlider];
        int light = [JLBLEManager toDecimalWithHexString:[value substringWithRange:NSMakeRange(2, 2)]];
        int temp = [JLBLEManager toDecimalWithHexString:[value substringFromIndex:4]];
        
        NSDictionary *tempStatus = @{
                                     @"SwitchCount": [NSString stringWithFormat:@"%d", switchCount],
                                     @"Switch1Status": [NSString stringWithFormat:@"%d", switch1On],
                                     @"Switch2Status": [NSString stringWithFormat:@"%d", switch2On],
                                     @"HasTempSlider": [NSString stringWithFormat:@"%d", hasTemp],
                                     @"Light": [NSString stringWithFormat:@"%d", light],
                                     @"Temp": [NSString stringWithFormat:@"%d", temp]
                                     };
        
        // NSLog(@"TempStatus:%@", tempStatus);
        if ([self.delegate respondsToSelector:@selector(bleManagerWithTempStatus:)]) {
            [self.delegate bleManagerWithTempStatus:tempStatus];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kBLEManagerDidUpdateTempStatusNotification object:nil userInfo:@{@"UpdatedTempStatus" : tempStatus}];
        
    }
}

- (void)getColorStatus
{
    NSMutableArray *status = [@[] mutableCopy];
    
    [self.receiveData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        NSString *string = (NSString *)obj;
        
        NSRange range = [string rangeOfString:@"88714D03"];
        if (range.length) {
            NSString *subString = [string substringWithRange:NSMakeRange(range.length + range.location, 3*2)];
            [status addObject:subString];
        }
        
        range = [string rangeOfString:@"88714E02"];
        if (range.length) {
            NSString *subString = [string substringWithRange:NSMakeRange(range.length + range.location, 2 * 2)];
            [status addObject:subString];
            *stop = YES;
        }
    }];
    
    // NSLog(@"colorStatus:%@", status);
    
    NSString *colorInfo = [status firstObject];
    int red = [JLBLEManager toDecimalWithHexString:[colorInfo substringToIndex:2]];
    int green = [JLBLEManager toDecimalWithHexString:[colorInfo substringWithRange:NSMakeRange(2, 2)]];
    int blue = [JLBLEManager toDecimalWithHexString:[colorInfo substringFromIndex:4]];
    
    NSString *switchInfo = [status lastObject];
    int switchCount = [JLBLEManager toDecimalWithHexString:[switchInfo substringToIndex:2]];
    NSString *switchStatus = [switchInfo substringFromIndex:2];
    
    int switch1On = 0;
    int switch2On = 0;
    
    if ([switchStatus isEqualToString:@"01"]) {
        switch1On = 1;
    }
    else if ([switchStatus isEqualToString:@"02"]) {
        switch2On = 1;
    }
    else if ([switchStatus isEqualToString:@"03"]) {
        switch1On = 1;
        switch2On = 1;
    }
    
    NSDictionary *colorStatus = @{@"R":[NSString stringWithFormat:@"%d", red],
                                  @"G":[NSString stringWithFormat:@"%d", green],
                                  @"B":[NSString stringWithFormat:@"%d", blue],
                                  @"C":[NSString stringWithFormat:@"%d", switch2On],
                                  @"SwitchCount":[NSString stringWithFormat:@"%d", switchCount],
                                  @"Switch1Status":[NSString stringWithFormat:@"%d", switch1On],
                                  @"Switch2Status":[NSString stringWithFormat:@"%d", switch2On]};
    
    // NSLog(@"ColorStatus:%@", colorStatus);
    if ([self.delegate respondsToSelector:@selector(bleManagerWithColorStatus:)]) {
        [self.delegate bleManagerWithColorStatus:colorStatus];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBLEManagerDidUpdateColorStatusNotification object:nil userInfo:@{@"UpdatedColorStatus" : colorStatus}];
}

- (void)receiveDataDidFinish
{
    [self getModules];
    [self getClocks];
    [self getColors];
    [self getTempClocks];
    [self getTempStatus];
    [self getColorStatus];
}

#pragma mark - Tuner delegate

- (void)BLE_DEV_Ready
{
    CBPeripheral *peripheral = _manager.foundPeripherals[0];
    self.foundPeripherals = _manager.foundPeripherals;
    self.peripheralName = peripheral.name;
    [[NSNotificationCenter defaultCenter] postNotificationName:kBLEManagerDidConnectNotification object:nil];
    
    if (!_connectedAlertView.visible) {
        [_connectedAlertView show];
        if (_timer == nil) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(checkState) userInfo:nil repeats:YES];
        }
    }
}

- (void)DEV_List_fresh
{
    if (_manager.activePeripheral != nil && _manager.activePeripheral.state == CBPeripheralStateDisconnected) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kBLEManagerDidDisconnectNotification object:nil];
        [_disconnectedAlertView show];
    }
    else if (_manager.activePeripheral != nil && _manager.activePeripheral.state == CBPeripheralStateConnected) {
        [_connectedAlertView show];
    }
}

- (void)Receive_Data_Event:(NSData *)TXP p:(UInt8)len
{
    // NSLog(@"%@", TXP);
    NSString *string = [JLBLEManager hexRepresentationWithData:TXP withSymbol:@""];
    
    if ([string rangeOfString:@"887110"].length > 0) {
        self.receiveData = [NSMutableArray array];
    }
    
    [self.receiveData addObject:string];
    
    if ([string rangeOfString:@"887153"].length > 0) {
        [self receiveDataDidFinish];
    }
}

@end
