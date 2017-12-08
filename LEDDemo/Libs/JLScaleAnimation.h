//
//  JLScaleAnimation.h
//  Jan_Lion
//
//  Created by Jan Lion on 14-8-26.
//  Copyright (c) 2014年 Lion Jan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JLScaleAnimation : NSObject

+ (void)scaleAnimationShowForView:(UIView *)view completionHandler:(void (^)(void))completionHandler;
+ (void)scaleAnimationHideForView:(UIView *)view completionHandler:(void (^)(void))completionHandler;

@end
