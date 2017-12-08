//
//  colorTableViewController.m
//  LEDDemo
//
//  Created by shibaosheng on 15/10/27.
//  Copyright © 2015年 Sheng. All rights reserved.
//

#import "colorTableViewController.h"
#import "firstcolorViewController.h"
#import "ViewController.h"


@interface colorTableViewController ()

@property (nonatomic, strong) NSMutableArray *colors;
@property (nonatomic, strong) NSMutableDictionary *colorforrgb;
@property (nonatomic, strong) UISwitch *myswitch;

@property (nonatomic, strong) UILabel *rlabel;

@property (nonatomic, strong) ViewController *viewcontroller;

@end

@implementation colorTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewcontroller = [ViewController sharedViewController];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    NSString *path = [[NSBundle mainBundle]pathForResource:@"color" ofType:@"plist"];
//    self.colors = [NSMutableArray arrayWithContentsOfFile:path];
    self.colors = [[NSMutableArray alloc]init];
//    firstcolorViewController *fc = self.navigationController.viewControllers[0];
//    self.colors = fc.savecolor;
    self.colorforrgb = [[NSMutableDictionary alloc]init];
    self.colors = [self.viewcontroller.savecolors mutableCopy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.colors.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    self.colorforrgb = self.colors[indexPath.row];
    //UILabel *rlabel = (UILabel *)[cell viewWithTag:21];
    self.rlabel = (UILabel *)[cell viewWithTag:21];
    UILabel *glabel = (UILabel *)[cell viewWithTag:22];
    UILabel *blabel = (UILabel *)[cell viewWithTag:23];
    self.rlabel.text = [NSString stringWithFormat:@"R:%@",self.colorforrgb[@"R"]];
    glabel.text = [NSString stringWithFormat:@"G:%@",self.colorforrgb[@"G"]];
    blabel.text = [NSString stringWithFormat:@"B:%@",self.colorforrgb[@"B"]];
    
//    UIImageView *imageview = (UIImageView *)[cell viewWithTag:25];
//    imageview.backgroundColor = [UIColor colorWithRed:[rlabel.text integerValue]/255.0 green:[glabel.text integerValue]/255.0 blue:[blabel.text integerValue]/255.0 alpha:1.0];
    self.myswitch = (UISwitch *)[cell viewWithTag:24];
    if ([self.colorforrgb[@"C"]  isEqual: @"1"]) {
        [self.myswitch setOn:YES];
    }
    else
    {
        [self.myswitch setOn:NO];
    }
    
    UILabel *label = (UILabel *)[cell viewWithTag:25];
    label.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
    label.backgroundColor = [UIColor colorWithRed:[self.colorforrgb[@"R"] integerValue]/255.0 green:[self.colorforrgb[@"G"] integerValue]/255.0 blue:[self.colorforrgb[@"B"] integerValue]/255.0 alpha:1.0];
    
    return cell;
}
#pragma  mark - table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.colorforrgb = self.colors[indexPath.row];
//    firstcolorViewController *firstcolortview = [self.storyboard instantiateViewControllerWithIdentifier:@"firstcolorview"];
    firstcolorViewController *firstcolortview = [self.navigationController.viewControllers firstObject];
//    firstcolortview.colorRtext = self.colorforrgb[@"R"];
//    firstcolortview.colorGtext = self.colorforrgb[@"G"];
//    firstcolortview.colorBtext = self.colorforrgb[@"B"];
//    [self.navigationController pushViewController:firstcolortview animated:YES];
    
    [self.navigationController popToViewController:firstcolortview animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.myswitch = (UISwitch *)[cell viewWithTag:24];
    NSMutableDictionary *savecolors = [self.colorforrgb mutableCopy];
    [savecolors setObject:[NSString stringWithFormat:@"%d",self.myswitch.isOn] forKey:@"C"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"firstcolor" object:savecolors ];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
