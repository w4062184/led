//
//  firstcolorViewController.h
//  LEDDemo
//
//  Created by shibaosheng on 15/10/29.
//  Copyright © 2015年 Sheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface firstcolorViewController : UIViewController

//颜色
@property (weak, nonatomic) IBOutlet UIImageView *colorcolorimageview;
@property (weak, nonatomic) IBOutlet UILabel *colorRlabel;
@property (weak, nonatomic) IBOutlet UILabel *colorGlabel;
@property (weak, nonatomic) IBOutlet UILabel *colorBlabel;
@property (weak, nonatomic) IBOutlet UISlider *colorGslider;
@property (weak, nonatomic) IBOutlet UISlider *colorRslider;
@property (weak, nonatomic) IBOutlet UISlider *colorBslider;
@property (weak, nonatomic) IBOutlet UISwitch *colorswitch1;
@property (weak, nonatomic) IBOutlet UISwitch *colorswitch2;


@end
