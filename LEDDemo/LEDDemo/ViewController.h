//
//  ViewController.h
//  LEDDemo
//
//  Created by shibaosheng on 15/10/26.
//  Copyright © 2015年 Sheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "colorsmodel.h"
#import "clocksmodel.h"
#import "tempsmodel.h"

@interface ViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *savecolors;
@property (nonatomic, strong) NSArray *saveclocks;
@property (nonatomic, strong) NSMutableArray *savetemps;
@property (nonatomic, strong) NSDictionary *savefirstcolors;
@property (nonatomic, strong) NSDictionary *savefirsttemps;

+ (instancetype)sharedViewController;

@end

