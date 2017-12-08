//
//  tempsaveViewController.m
//  LEDDemo
//
//  Created by shibaosheng on 15/10/28.
//  Copyright © 2015年 Sheng. All rights reserved.
//

#import "tempsaveViewController.h"
#import "firsttempViewController.h"

#import "JLBLEManager.h"
#import "BulbControl-Bridging-Header.h"
#import "ViewController.h"

@interface tempsaveViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *begin;
@property (weak, nonatomic) IBOutlet UILabel *end;
@property (weak, nonatomic) IBOutlet UIButton *saveno;
@property (weak, nonatomic) IBOutlet UISwitch *repeatswitch;

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) JLPopoverController *pop;

@property (nonatomic, strong) JLBLEManager *blem;
@property (nonatomic, strong) ViewController *viewcontroller;


@end

@implementation tempsaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewcontroller = [ViewController sharedViewController];
    self.blem = [JLBLEManager sharedBLEManager];
    // Do any additional setup after loading the view.
    self.label.text = [NSString stringWithFormat:@"亮度:%@    色温:%@",self.savelightkey,self.savetempkey];
    self.begin.text = [NSString stringWithFormat:@"%@:%@",self.begintimehour,self.begintimeminute];
    self.end.text = [NSString stringWithFormat:@"%@:%@",self.endtimehour,self.begintimeminute];
    self.navigationItem.hidesBackButton = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancal:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)save:(id)sender {
    NSString *no = self.saveno.titleLabel.text;
    NSLog(@"88719008%02x%02x%02x%02x%02x%02x%02x%02x",(int)[self.savelightkey integerValue],(int)[self.savetempkey integerValue],(int)[self.begintimehour integerValue],(int)[self.begintimeminute integerValue],(int)[self.endtimehour integerValue],(int)[self.endtimeminute integerValue],self.repeatswitch.isOn,(int)[[no substringWithRange:NSMakeRange(1, 1)] integerValue]);
    [self.blem sendInstruction:[NSString stringWithFormat:@"88719008%02x%02x%02x%02x%02x%02x%02x%02x",(int)[self.savelightkey integerValue],(int)[self.savetempkey integerValue],(int)[self.begintimehour integerValue],(int)[self.begintimeminute integerValue],(int)[self.endtimehour integerValue],(int)[self.endtimeminute integerValue],self.repeatswitch.isOn,(int)[[no substringWithRange:NSMakeRange(1, 1)] integerValue]]];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:[no substringWithRange:NSMakeRange(1, 1)] forKey:@"No"];
    [dict setValue:self.savelightkey forKey:@"Light"];
    [dict setValue:self.savetempkey forKey:@"Temp"];
    [dict setValue:self.begintimehour forKey:@"BeginHour"];
    [dict setValue:self.begintimeminute forKey:@"BeginMinute"];
    [dict setValue:self.endtimehour forKey:@"EndHour"];
    [dict setValue:self.endtimeminute forKey:@"EndMinute"];
    [self dismissViewControllerAnimated:YES completion:^{
        [self.viewcontroller.savetemps replaceObjectAtIndex:([[no substringWithRange:NSMakeRange(1, 1)] integerValue]-1) withObject:dict];
    }];
}

- (IBAction)ok:(id)sender {
    self.tableview = [[UITableView alloc]init];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.backgroundColor = [UIColor yellowColor];
    self.tableview.frame = CGRectMake(0, 0, 80, 300);
    _pop = [[JLPopoverController alloc]initWithView:self.tableview];
    _pop.cornerRadius = 0;
    _pop.popoverBaseColor = [UIColor grayColor];
    _pop.popoverGradient = YES;
    [_pop showPopoverWithRect:CGRectMake(0, 0, 50, 110)];
}
#pragma mark - table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView = self.tableview;
    NSString *customcellIdentifier = @"customcellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:customcellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:customcellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"#%ld",indexPath.row+1];
    return cell;
    
}
#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.saveno setTitle:[NSString stringWithFormat:@"#%ld",indexPath.row+1] forState:UIControlStateNormal];
    [_pop dismissPopoverAnimatd:YES];
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
