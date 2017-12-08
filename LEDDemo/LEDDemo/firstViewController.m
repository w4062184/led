//
//  firstViewController.m
//  LEDDemo
//
//  Created by shibaosheng on 15/10/27.
//  Copyright © 2015年 Sheng. All rights reserved.
//

#import "firstViewController.h"
#import "ViewController.h"


@interface firstViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UILabel *onetime;
@property (weak, nonatomic) IBOutlet UISwitch *oneswitch;
@property (weak, nonatomic) IBOutlet UILabel *twotime;
@property (weak, nonatomic) IBOutlet UISwitch *twoswitch;
@property (weak, nonatomic) IBOutlet UILabel *threetime;
@property (weak, nonatomic) IBOutlet UISwitch *threeswitch;
//闹钟
@property (nonatomic, strong) NSMutableArray *firstclock;
@property (nonatomic, strong) NSMutableArray *saveclock;
@property (nonatomic, strong) ViewController *viewcontroller;

@end

@implementation firstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewcontroller = [ViewController sharedViewController];
    self.navigationItem.title = @"闹钟";
    //闹钟
    self.firstclock = [[NSMutableArray alloc]init];
    self.saveclock = [self.viewcontroller.saveclocks mutableCopy];
    self.firstclock = self.saveclock;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadclock:) name:@"firstclock" object:nil];
    [self load];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)reloadclock:(NSNotification *)fication
{
//    [self.firstclock addObject:fication.object];
//    [self.tableview reloadData];
    [self.firstclock replaceObjectAtIndex:0 withObject:fication.object];
    [self load];

}
- (void)load
{
    self.onetime.text = self.firstclock[0][@"BeginTime"];
    if ([self.firstclock[0][@"Switch"]  isEqualToString:@"true"]) {
        [self.oneswitch setOn:YES];
    }
    else {
        [self.oneswitch setOn:NO];
    }
    self.twotime.text = self.firstclock[1][@"BeginTime"];
    if ([self.firstclock[1][@"Switch"]  isEqualToString:@"true"]) {
        [self.twoswitch setOn:YES];
    }
    else {
        [self.twoswitch setOn:NO];
    }
    self.threetime.text = self.firstclock[2][@"BeginTime"];
    if ([self.firstclock[2][@"Switch"]  isEqualToString:@"true"]) {
        [self.threeswitch setOn:YES];
    }
    else {
        [self.threeswitch setOn:NO];
    }

}
/*
#pragma mark - clock table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.firstclock.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == 0) {
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"oneCell"];
//        UILabel *label = (UILabel *)[cell viewWithTag:31];
//        UISwitch *onswitch  = (UISwitch *)[cell viewWithTag:32];
//        NSMutableDictionary *dict = self.firstclock[indexPath.row];
//        
//        label.text = dict[@"BeginTime"];
//        if ([dict[@"Switch"]  isEqualToString:@"true"]) {
//            [onswitch setOn:YES];
//        }
//        else {
//            [onswitch setOn:NO];
//        }
//        
//        return cell;
//    }
//    if (indexPath.row == 1) {
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"twoCell"];
//        UILabel *label = (UILabel *)[cell viewWithTag:31];
//        UISwitch *onswitch  = (UISwitch *)[cell viewWithTag:32];
//        NSMutableDictionary *dict = self.firstclock[indexPath.row];
//        
//        label.text = dict[@"BeginTime"];
//        if ([dict[@"Switch"]  isEqualToString:@"true"]) {
//            [onswitch setOn:YES];
//        }
//        else {
//            [onswitch setOn:NO];
//        }
//        
//        return cell;
//    }
//    if (indexPath.row == 2) {
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"threeCell"];
//        UILabel *label = (UILabel *)[cell viewWithTag:31];
//        UISwitch *onswitch  = (UISwitch *)[cell viewWithTag:32];
//        NSMutableDictionary *dict = self.firstclock[indexPath.row];
//        
//        label.text = dict[@"BeginTime"];
//        if ([dict[@"Switch"]  isEqualToString:@"true"]) {
//            [onswitch setOn:YES];
//        }
//        else {
//            [onswitch setOn:NO];
//        }
//        
//        return cell;
//    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    UILabel *label = (UILabel *)[cell viewWithTag:31];
    UISwitch *onswitch  = (UISwitch *)[cell viewWithTag:32];
    NSMutableDictionary *dict = self.firstclock[indexPath.row];
    
    label.text = dict[@"BeginTime"];
    if ([dict[@"Switch"]  isEqualToString:@"true"]) {
        [onswitch setOn:YES];
    }
    else {
        [onswitch setOn:NO];
    }
    
    return cell;
}
 */


@end
