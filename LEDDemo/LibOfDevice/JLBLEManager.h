//
//  JLBLEManager.h
//  Jan_Lion
//
//  Created by Jan Lion on 14-8-26.
//  Copyright (c) 2014年 Lion Jan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Tuner168_BLE_IOS_SDK_V1.h"

@class Tuner168_BLE_IOS_SDK;

#define kBLEManagerDidConnectNotification         @"kBLEManagerDidConnectNotification"
#define kBLEManagerDidDisconnectNotification      @"kBLEManagerDidDisconnectNotification"
#define kBLEManagerDidUpdateClockNotification     @"kBLEManagerDidUpdateClockNotification"
#define kBLEManagerDidUpdateColorNotification     @"kBLEManagerDidUpdateColorNotification"
#define kBLEManagerDidUpdateTempClockNotification @"kBLEManagerDidUpdateTempClockNotification"
#define kBLEManagerDidUpdateTempStatusNotification @"kBLEManagerDidUpdateTempStatusNotification"
#define kBLEManagerDidUpdateColorStatusNotification @"kBLEManagerDidUpdateColorStatusNotification"

@class JLBLEManager;

@protocol JLBLEManagerDelegate <NSObject>

@optional
- (void)bleManagerWithModules:(NSSet *)modules;
- (void)bleManagerWithClocks:(NSArray *)clocks;
- (void)bleManagerWithColors:(NSArray *)colors;
- (void)bleManagerWithTempClocks:(NSArray *)tempClocks;
- (void)bleManagerWithTempStatus:(NSDictionary *)tempStatus;
- (void)bleManagerWithColorStatus:(NSDictionary *)colorStatus;

@required
- (void)bleManagerDidFindPeripherals;
- (void)bleManagerDidConnectPeripherals;
- (void)bleManagerDidDisconnectPeripherals;

@end

@interface JLBLEManager : NSObject

@property (nonatomic, strong) Tuner168_BLE_IOS_SDK *manager;
@property (nonatomic, strong) NSString *peripheralName;
@property (nonatomic, assign) id<JLBLEManagerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *foundPeripherals;

+ (JLBLEManager *)sharedBLEManager;
- (void)findPeripherals;
- (void)connectPeripherals;
- (void)disconnectPeripherals;
- (void)sendInstruction:(NSString *)instruction;

@end
