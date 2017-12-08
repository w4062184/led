//
//  colorsaveViewController.m
//  LEDDemo
//
//  Created by shibaosheng on 15/10/28.
//  Copyright © 2015年 Sheng. All rights reserved.
//

#import "colorsaveViewController.h"

#import "BulbControl-Bridging-Header.h"
#import "JLBLEManager.h"

#import "ViewController.h"

@interface colorsaveViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *TableView;
@property (strong, nonatomic)  UISwitch *colorswitch;
@property (strong, nonatomic)  UILabel *label;
@property (strong, nonatomic)  UIButton *buttonno;

@property (nonatomic, strong) JLBLEManager *blem;
@property (nonatomic, strong) ViewController *viewcontroller;
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) JLPopoverController *pop;

@end

@implementation colorsaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.viewcontroller = [ViewController sharedViewController];
    self.blem = [JLBLEManager sharedBLEManager];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancal:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)save:(id)sender {
    NSLog(@"8872A005%02x%02x%02x%02x",(int)[self.savercolor integerValue],(int)[self.savegcolor integerValue],(int)[self.savebcolor integerValue],(int)[self.saveon integerValue]);
    [self.blem sendInstruction:[NSString stringWithFormat:@"8872A005%02x%02x%02x%02x",(int)[self.savercolor integerValue],(int)[self.savegcolor integerValue],(int)[self.savebcolor integerValue],(int)[self.saveon integerValue]]];
    
    NSString *no = self.buttonno.titleLabel.text;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:[no substringWithRange:NSMakeRange(1, 1)] forKey:@"No"];
    [dict setValue:self.savercolor forKey:@"R"];
    [dict setValue:self.savegcolor forKey:@"G"];
    [dict setValue:self.savebcolor forKey:@"B"];
    [dict setValue:self.saveon forKey:@"C"];
    [self dismissViewControllerAnimated:YES completion:^{
        [self.viewcontroller.savecolors replaceObjectAtIndex:([[no substringFromIndex:1] integerValue]-1) withObject:dict];
    }];
}

- (IBAction)ok:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
    self.tableview = [[UITableView alloc]init];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.backgroundColor = [UIColor yellowColor];
    self.tableview.frame = CGRectMake(0, 0, 80, 300);
    
    _pop = [[JLPopoverController alloc]init];
    _pop.contentView = self.tableview;
    _pop.cornerRadius = 0;
    _pop.popoverBaseColor = [UIColor grayColor];
    _pop.popoverGradient = YES;
    [_pop showPopoverWithRect:CGRectMake(0, 0, 100, 100)];
//    UITableViewCell *cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    NSLog(@"x:%f,y:%f,w:%f,h:%f",cell.frame.origin.x,cell.frame.origin.y,cell.frame.size.width+self.buttonno.frame.size.width,cell.frame.size.height+64);
    
}
#pragma mark - table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableview) {
        return 16;
    }
    return 2;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableview){
        NSString *customcellIdentifier = @"customcellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:customcellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:customcellIdentifier];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"#%ld",indexPath.row+1];
        return cell;
    }
    else{
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"oneCell"];
            UIButton *buttonno = (UIButton *)[cell viewWithTag:51];
            UISwitch *colorswitch = (UISwitch *)[cell viewWithTag:52];
            self.buttonno = buttonno;
            self.colorswitch = colorswitch;
            [self.colorswitch setOn: [self.saveon integerValue]];
            return cell;
        }
        else{
          UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"twoCell"];
          UILabel *label = (UILabel *)[cell viewWithTag:53];
           self.label = label;
        self.label.text = [NSString stringWithFormat:@"R:%@      G:%@      B:%@",self.savercolor,self.savegcolor,self.savebcolor];
            
            return cell;
         }
        
    }
    

}
#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableview) {
        [self.buttonno setTitle:[NSString stringWithFormat:@"#%ld",indexPath.row+1] forState:UIControlStateNormal];
        [_pop dismissPopoverAnimatd:YES];
    }
    
    
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
