//
//  firsttempViewController.h
//  LEDDemo
//
//  Created by shibaosheng on 15/10/29.
//  Copyright © 2015年 Sheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface firsttempViewController : UIViewController

//冷暖
@property (weak, nonatomic) IBOutlet UIImageView *tempcolorimage;
@property (weak, nonatomic) IBOutlet UISlider *templightslider;
@property (weak, nonatomic) IBOutlet UISlider *temptempslider;
@property (weak, nonatomic) IBOutlet UILabel *templightlabel;
@property (weak, nonatomic) IBOutlet UILabel *temptemplabel;
@property (weak, nonatomic) IBOutlet UISwitch *tempswitch1;
@property (weak, nonatomic) IBOutlet UISwitch *tempswitch2;


@end
