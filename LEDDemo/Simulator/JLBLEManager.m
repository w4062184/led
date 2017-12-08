//
//  JLBLEManager.m
//  Jan_Lion
//
//  Created by Jan Lion on 14-8-26.
//  Copyright (c) 2014年 Lion Jan. All rights reserved.
//


#import "JLBLEManager.h"
#import <UIKit/UIKit.h>
#define kTimeInterval    3.0f

@interface JLBLEManager()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIAlertView *connectedAlertView;
@property (nonatomic, strong) UIAlertView *disconnectedAlertView;
@property (nonatomic, strong) NSMutableArray *receiveData;

@end

@implementation JLBLEManager

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
        self.receiveData = [NSMutableArray array];
        self.foundPeripherals = [NSMutableArray array];
        self.connectedAlertView = [[UIAlertView alloc] initWithTitle:@"蓝牙连接" message:@"连接设备成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        self.disconnectedAlertView = [[UIAlertView alloc] initWithTitle:@"蓝牙连接" message:@"与一个设备已断开连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
    }
    
    return self;
}

- (void)findPeripherals
{
    [NSTimer scheduledTimerWithTimeInterval:kTimeInterval target:self selector:@selector(findingPeripherals) userInfo:nil repeats:NO];
}

- (void)findingPeripherals
{
    self.foundPeripherals = [@[@{@"Name":@"BLE LED Light 4.0"}] mutableCopy];
    [self.delegate bleManagerDidFindPeripherals];
}

- (void)connectPeripherals
{
    [NSTimer scheduledTimerWithTimeInterval:kTimeInterval target:self selector:@selector(connectingPeripherals) userInfo:nil repeats:NO];
}

- (void)connectingPeripherals
{
    [self BLE_DEV_Ready];
    [self.delegate bleManagerDidConnectPeripherals];
    [NSTimer scheduledTimerWithTimeInterval:4.0f target:self selector:@selector(Receive_Data_Event:p:) userInfo:nil repeats:NO];
}

- (void)disconnectPeripherals
{
    self.foundPeripherals = [NSMutableArray array];
    [self.delegate bleManagerDidDisconnectPeripherals];
}

- (void)checkState
{
    if ([self.foundPeripherals count] == 0) {
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
    
}

- (void)getModules
{
    NSArray *modules = @[@"Clock", @"Color",@"Temp"];
    NSMutableSet *selectedModules = [NSMutableSet set];
    
    for (int i = 0; i < modules.count; i++) {
        [selectedModules addObject:modules[i]];
    }
    
    if ([self.delegate respondsToSelector:@selector(bleManagerWithModules:)]) {
        [self.delegate bleManagerWithModules:selectedModules];
    }

}

- (void)getClocks
{
    NSMutableArray *showClocks = [NSMutableArray array];
    NSArray *times = @[@{@"BeginTime":@"10:00", @"Switch":@"true"},
                       @{@"BeginTime":@"14:00", @"Switch":@"false"},
                       @{@"BeginTime":@"19:05", @"Switch":@"true"}];
    for (int i = 0; i < times.count; i++) {
        [showClocks addObject:times[i]];
    }
//    NSLog(@"showClocks:%@", showClocks);
    
    if ([self.delegate respondsToSelector:@selector(bleManagerWithClocks:)]) {
        [self.delegate bleManagerWithClocks:showClocks];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBLEManagerDidUpdateClockNotification object:nil userInfo:@{@"UpdatedClocks" : showClocks}];
}

- (void)getColors
{
    NSArray *colors = @[@{@"R":@"235", @"G":@"124", @"B":@"86", @"C":@"1"},
                       @{@"R":@"102", @"G":@"124", @"B":@"1", @"C":@"0"},
                       @{@"R":@"138", @"G":@"124", @"B":@"89", @"C":@"1"},
                       @{@"R":@"98", @"G":@"124", @"B":@"1", @"C":@"0"},
                       
                       @{@"R":@"237", @"G":@"112", @"B":@"0", @"C":@"0"},
                       @{@"R":@"245", @"G":@"124", @"B":@"78", @"C":@"0"},
                       @{@"R":@"12", @"G":@"129", @"B":@"255", @"C":@"0"},
                       @{@"R":@"14", @"G":@"124", @"B":@"12", @"C":@"1"},
                       
                       @{@"R":@"46", @"G":@"42", @"B":@"89", @"C":@"1"},
                       @{@"R":@"126", @"G":@"89", @"B":@"234", @"C":@"0"},
                       @{@"R":@"39", @"G":@"139", @"B":@"189", @"C":@"0"},
                       @{@"R":@"9", @"G":@"85", @"B":@"101", @"C":@"1"},
                       
                       @{@"R":@"58", @"G":@"129", @"B":@"56", @"C":@"0"},
                       @{@"R":@"129", @"G":@"211", @"B":@"1", @"C":@"1"},
                       @{@"R":@"211", @"G":@"21", @"B":@"82", @"C":@"0"},
                       @{@"R":@"179", @"G":@"78", @"B":@"40", @"C":@"1"},
                       ];
    
    if ([self.delegate respondsToSelector:@selector(bleManagerWithColors:)]) {
        [self.delegate bleManagerWithColors:colors];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBLEManagerDidUpdateColorNotification object:nil userInfo:@{@"UpdatedColors" : colors}];
}

- (void)getTempClocks
{
    NSArray *clocks = @[@{@"No":@"1", @"Light":@"45", @"Temp":@"87",
                         @"BeginHour":@"10", @"BeginMinute":@"00", @"EndHour":@"11", @"EndMinute":@"00"},
                       @{@"No":@"2", @"Light":@"67", @"Temp":@"23",
                         @"BeginHour":@"14", @"BeginMinute":@"00", @"EndHour":@"15", @"EndMinute":@"00"},
                       @{@"No":@"3", @"Light":@"78", @"Temp":@"23",
                         @"BeginHour":@"16", @"BeginMinute":@"00", @"EndHour":@"17", @"EndMinute":@"00"},
                       @{@"No":@"4", @"Light":@"12", @"Temp":@"90",
                         @"BeginHour":@"20", @"BeginMinute":@"00", @"EndHour":@"21", @"EndMinute":@"00"},
                       @{@"No":@"5", @"Light":@"100", @"Temp":@"45",
                         @"BeginHour":@"22", @"BeginMinute":@"00", @"EndHour":@"23", @"EndMinute":@"30"},
                       @{@"No":@"6", @"Light":@"69", @"Temp":@"71",
                         @"BeginHour":@"23", @"BeginMinute":@"50", @"EndHour":@"23", @"EndMinute":@"59"}];
    
    if ([self.delegate respondsToSelector:@selector(bleManagerWithTempClocks:)]) {
        [self.delegate bleManagerWithTempClocks:clocks];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBLEManagerDidUpdateTempClockNotification object:nil userInfo:@{@"UpdatedTempClocks" : clocks}];
}

- (void)getTempStatus
{
    NSDictionary *tempStatus = @{
                                 @"SwitchCount": @"2",
                                 @"Switch1Status": @"1",
                                 @"Switch2Status": @"0",
                                 @"HasTempSlider": @"1",
                                 @"Light": @"89",
                                 @"Temp": @"50"
                                 };
    
    if ([self.delegate respondsToSelector:@selector(bleManagerWithTempStatus:)]) {
        [self.delegate bleManagerWithTempStatus:tempStatus];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBLEManagerDidUpdateTempStatusNotification object:nil userInfo:@{@"UpdatedTempStatus" : tempStatus}];
}

- (void)getColorStatus
{
    NSDictionary *colorStatus = @{@"R":@"123",
                                  @"G":@"234",
                                  @"B":@"12",
                                  @"C":@"1",
                                  @"SwitchCount":@"2",
                                  @"Switch1Status":@"1",
                                  @"Switch2Status":@"0"};
    
//    NSLog(@"ColorStatus:%@", colorStatus);
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

}

- (void)Receive_Data_Event:(NSData *)TXP p:(UInt8)len
{
    [self receiveDataDidFinish];
}

@end
