//
//  fistsettingViewController.m
//  LEDDemo
//
//  Created by shibaosheng on 15/10/29.
//  Copyright © 2015年 Sheng. All rights reserved.
//

#import "firstsettingViewController.h"

@interface firstsettingViewController ()


@end

@implementation firstsettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"设置";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)off:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
   
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
