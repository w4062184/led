//
//  BLE_LXXAVR.h
//  BLE_LXXAVR
//
//  Created by LXXAVR on 14-1-9.
//  Copyright (c) 2014年 LXXAVR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreBluetooth/CBService.h>


@protocol Tuner168_BLE_IOS_SDK_Delegate
@optional
-(void) BLE_DEV_Ready;//连接上设备后，调用此函数
@required
-(void) Receive_Data_Event:(NSData*)TXP p:(UInt8)len;//接收到数据时调用此函数
- (void) DEV_List_fresh;//设备列表有变化时，调用此函数
@end

@interface Tuner168_BLE_IOS_SDK : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate> {
    
}

@property (nonatomic,assign) id <Tuner168_BLE_IOS_SDK_Delegate> delegate;

@property (strong, nonatomic) CBCentralManager *CM;//类对象
@property (strong, nonatomic) CBPeripheral *activePeripheral;//ble 对象

@property (retain, nonatomic) NSMutableArray    *foundPeripherals;//设备列表


-(void) sbb:(Byte*)buzVal p:(CBPeripheral *)p pp:(int)len;//备用
-(void) svv:(Byte*)buzVal p:(CBPeripheral *)p pp:(int)len;//备用


-(NSData*)stringToByte:(NSString*)string;//字符串转十六进制数据
-(BOOL)Send_Data:(NSString*)Str_data;//发送数据格式为十六进制字符串
-(int)Read_RSSI;//读取设备RSSI信号强度

-(int) findBLEPeripherals:(int) timeout;//查找设备，timeout：时间单位s
-(void) connectPeripheral:(CBPeripheral *)peripheral;//连接设备，peripheral为设备对象
- (void) disconnectPeripheral:(CBPeripheral*)peripheral;//断开连接设备，peripheral为设备对象

-(const char *) UUIDToString:(CFUUIDRef) UUID;// UUID转字符串
- (void) clearDevices;//清除设备列表



@end
