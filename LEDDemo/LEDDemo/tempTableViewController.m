//
//  tempTableViewController.m
//  LEDDemo
//
//  Created by shibaosheng on 15/10/27.
//  Copyright © 2015年 Sheng. All rights reserved.
//

#import "tempTableViewController.h"
#import "firsttempViewController.h"
#import "ViewController.h"

@interface tempTableViewController ()

@property (nonatomic, strong) NSMutableDictionary *tempdict;;
@property (nonatomic, strong) NSMutableArray *temps;
@property (nonatomic, strong) NSMutableDictionary *alltemp;

@property (nonatomic, strong) ViewController *viewcontroller;

@end

@implementation tempTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewcontroller = [ViewController sharedViewController];
    NSString *paths = [[NSBundle mainBundle]pathForResource:@"Temps" ofType:@"plist"];
    self.tempdict = [NSMutableDictionary dictionaryWithContentsOfFile:paths];
    
    self.temps = [[NSMutableArray alloc]init];
    self.alltemp = [[NSMutableDictionary alloc]init];
//    firsttempViewController *ft = [self.navigationController.viewControllers firstObject];
    self.temps = self.viewcontroller.savetemps;
    
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
    return self.temps.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    // Configure the cell...
    self.alltemp = self.temps[indexPath.row];
    UILabel *light = (UILabel *)[cell viewWithTag:10];
    light.text = [NSString stringWithFormat:@"亮度:%ld",[self.alltemp[@"Light"] integerValue]];
    
    UILabel *temp = (UILabel *)[cell viewWithTag:11];
    temp.text = [NSString stringWithFormat:@"色温:%ld",[self.alltemp[@"Temp"] integerValue]];
    NSDictionary *color = self.tempdict[self.alltemp[@"Temp"]];
    NSInteger r = [color[@"R"] integerValue];
    NSInteger g = [color[@"G"] integerValue];
    NSInteger b = [color[@"B"] integerValue];
    UIImageView *imageview = (UIImageView *)[cell viewWithTag:12];
    imageview.backgroundColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
    
    return cell;
}
#pragma  mark - table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    firsttempViewController *firsttemptview = [self.storyboard instantiateViewControllerWithIdentifier:@"firsttempview"];
    firsttempViewController *firsttemptview = [self.navigationController.viewControllers firstObject];
    self.alltemp = self.temps[indexPath.row];
//    firsttemptview.temptemptext = self.alltemp[@"Temp"];
//    firsttemptview.templighttext = self.alltemp[@"Light"];
    [self.navigationController popToViewController:firsttemptview animated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:
     @"firsttemp" object:self.alltemp];

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
