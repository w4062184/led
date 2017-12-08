//
//  tempsaveViewController.h
//  LEDDemo
//
//  Created by shibaosheng on 15/10/28.
//  Copyright © 2015年 Sheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tempsaveViewController : UIViewController

@property (nonatomic, assign) NSString *savetempkey;
@property (nonatomic, assign) NSString *savelightkey;
@property (nonatomic, assign) NSString *begintimehour;
@property (nonatomic, assign) NSString *begintimeminute;
@property (nonatomic, assign) NSString *endtimehour;
@property (nonatomic, assign) NSString *endtimeminute;
@property (nonatomic, assign) NSString *repeat;

@end
