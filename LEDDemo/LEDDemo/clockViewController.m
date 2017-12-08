//
//  clockViewController.m
//  LEDDemo
//
//  Created by shibaosheng on 15/10/27.
//  Copyright © 2015年 Sheng. All rights reserved.
//

#import "clockViewController.h"
#import "JLScaleAnimation.h"

@interface clockViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *datapicker;
@property (weak, nonatomic) IBOutlet UILabel *timelabel;


@end

@implementation clockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)saveclock:(id)sender {
    NSDate *thedate = self.datapicker.date;
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"HH:mm"];
    NSDictionary *dict = @{@"BeginTime":[dateformatter stringFromDate:thedate],@"Switch":@"true"};
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:
     @"firstclock" object:dict];
}
- (IBAction)canal:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)changeddate:(id)sender {
    NSDate *thedate = self.datapicker.date;
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"HH:mm"];
    self.timelabel.text = [dateformatter stringFromDate:thedate];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
