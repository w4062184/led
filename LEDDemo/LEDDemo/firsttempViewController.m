//
//  firsttempViewController.m
//  LEDDemo
//
//  Created by shibaosheng on 15/10/29.
//  Copyright © 2015年 Sheng. All rights reserved.
//

#import "firsttempViewController.h"
#import "tempsaveViewController.h"

#import "JLBLEManager.h"
#import "ViewController.h"

@interface firsttempViewController ()

@property (nonatomic, strong) NSMutableDictionary *temps;
@property (nonatomic, strong) NSMutableDictionary *temp;

@property (nonatomic, strong) JLBLEManager *blem;
@property (strong, nonatomic) ViewController *viewcontroller;
//冷暖传值
@property (nonatomic, strong) NSMutableArray *savetemp;
@property (nonatomic, strong) NSMutableDictionary *firstemps;

@end

@implementation firsttempViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"温度";
    
    self.viewcontroller = [ViewController sharedViewController];
    self.blem = [JLBLEManager sharedBLEManager];
    //冷暖的数值
    NSString *paths = [[NSBundle mainBundle]pathForResource:@"Temps" ofType:@"plist"];
    self.temps = [NSMutableDictionary dictionaryWithContentsOfFile:paths];
    self.temp = [[NSMutableDictionary alloc]init];
    
    self.firstemps = [self.viewcontroller.savefirsttemps mutableCopy];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadtemp:) name:@"firsttemp" object:nil];
    
    [self loadtempviewwithtemp];

//    NSLog(@"%@",self.savetemp);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    
}
- (void)reloadtemp:(NSNotification *)fication
{
    self.firstemps = fication.object;
    [self loadtempviewwithtemp];
    
}
- (void)loadtempviewwithtemp
{
    //冷暖视图进入时的变化
    self.temptempslider.value = [self.firstemps[@"Temp"] integerValue];
    self.templightslider.value = [self.firstemps[@"Light"] integerValue];
    self.temptemplabel.text = self.firstemps[@"Temp"];
    self.templightlabel.text = self.firstemps[@"Light"];
    self.temp = self.temps[self.firstemps[@"Temp"]];
    [self.tempswitch1 setOn:[self.firstemps[@"Switch1Status"] integerValue]];
    [self.tempswitch2 setOn:[self.firstemps[@"Switch2Status"] integerValue]];
    NSInteger r = [self.temp[@"R"] integerValue];
    NSInteger g = [self.temp[@"G"] integerValue];
    NSInteger b = [self.temp[@"B"] integerValue];
    self.tempcolorimage.backgroundColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
    [self.blem sendInstruction:[NSString stringWithFormat:@"88729104%02x%02x%02x%02x",(int)self.templightslider.value,(int)self.temptempslider.value,(int)self.tempswitch1.isOn,(int)self.tempswitch2.isOn]];
}
#pragma mark - temp action
- (IBAction)tempslider:(id)sender {
    self.temptemplabel.text = [NSString stringWithFormat:@"%0.0f",self.temptempslider.value];
    self.temp = self.temps[self.temptemplabel.text];
    NSInteger r = [self.temp[@"R"] integerValue];
    NSInteger g = [self.temp[@"G"] integerValue];
    NSInteger b = [self.temp[@"B"] integerValue];
    self.tempcolorimage.backgroundColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
}
- (IBAction)lightslider:(id)sender {
    self.templightlabel.text = [NSString stringWithFormat:@"%0.0f",self.templightslider.value];
}
- (IBAction)savinglight:(id)sender {
    NSLog(@"88729104%02x%02x%02x%02x",(int)self.templightslider.value,(int)self.temptempslider.value,(int)self.tempswitch1.isOn,(int)self.tempswitch2.isOn);
    [self.blem sendInstruction:[NSString stringWithFormat:@"88729104%02x%02x%02x%02x",(int)self.templightslider.value,(int)self.temptempslider.value,(int)self.tempswitch1.isOn,(int)self.tempswitch2.isOn]];
}
- (IBAction)savingtemp:(id)sender {
   NSLog(@"88729104%02x%02x%02x%02x",(int)self.templightslider.value,(int)self.temptempslider.value,(int)self.tempswitch1.isOn,(int)self.tempswitch2.isOn);
    [self.blem sendInstruction:[NSString stringWithFormat:@"88729104%02x%02x%02x%02x",(int)self.templightslider.value,(int)self.temptempslider.value,(int)self.tempswitch1.isOn,(int)self.tempswitch2.isOn]];
}
- (IBAction)tempsave:(id)sender {
   
//    tempsaveViewController *tempsaveview = [self.storyboard instantiateViewControllerWithIdentifier:@"tempsaveViewController"];
//    [self.navigationController pushViewController:tempsaveview animated:YES];
//    tempsaveview.savetempkey = self.temptemplabel.text;
//    tempsaveview.savelightkey = self.templightlabel.text;
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"savetempSegue"]) {
        UINavigationController *navigation = segue.destinationViewController;
        tempsaveViewController *tempsaveview = [navigation.viewControllers firstObject];
        tempsaveview.savetempkey = self.temptemplabel.text;
        tempsaveview.savelightkey = self.templightlabel.text;
        tempsaveview.begintimehour = self.firstemps[@"BeginHour"];
        tempsaveview.begintimeminute = self.firstemps[@"BeginMinute"];
        tempsaveview.endtimehour = self.firstemps[@"EndHour"];
        tempsaveview.endtimeminute = self.firstemps[@"EndMinute"];
    }
}
- (IBAction)saveswitch1:(id)sender {
     NSLog(@"88729104%02x%02x%02x%02x",(int)self.templightslider.value,(int)self.temptempslider.value,(int)self.tempswitch1.isOn,(int)self.tempswitch2.isOn);
    [self.blem sendInstruction:[NSString stringWithFormat:@"88729104%02x%02x%02x%02x",(int)self.templightslider.value,(int)self.temptempslider.value,(int)self.tempswitch1.isOn,(int)self.tempswitch2.isOn]];
}
- (IBAction)saveswitch2:(id)sender {
     NSLog(@"88729104%02x%02x%02x%02x",(int)self.templightslider.value,(int)self.temptempslider.value,(int)self.tempswitch1.isOn,(int)self.tempswitch2.isOn);
    [self.blem sendInstruction:[NSString stringWithFormat:@"88729104%02x%02x%02x%02x",(int)self.templightslider.value,(int)self.temptempslider.value,(int)self.tempswitch1.isOn,(int)self.tempswitch2.isOn]];
}

@end
