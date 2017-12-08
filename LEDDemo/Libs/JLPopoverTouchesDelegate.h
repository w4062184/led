//
//  JLPopoverTouchDelegate.h
//  JanLion
//
//  Created by Jan Lion(Jan.Lion@qq.com) on 14-2-7.
//  Copyright (c) 2014年 Jan Lion. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol JLPopoverTouchesDelegate

@optional
- (void)view:(UIView*)view touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event;

@end