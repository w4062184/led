//
//  ViewController.m
//  LEDDemo
//
//  Created by shibaosheng on 15/10/26.
//  Copyright © 2015年 Sheng. All rights reserved.
//

#import "ViewController.h"
#import "setting.h"
#import "tabViewController.h"
#import "firstcolorViewController.h"
#import "firsttempViewController.h"
#import "firstViewController.h"
#import "firstsettingViewController.h"

#import "JLScaleAnimation.h"
#import "JLProgressHUD.h"
#import "JLBLEManager.h"


@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,JLBLEManagerDelegate>

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) JLBLEManager *jlble;
@property (nonatomic, strong) UIActivityIndicatorView *aiv;

@property (nonatomic, strong) tabViewController *tabbar;
@property (nonatomic, strong) setting *set;

@property (nonatomic, strong) UINavigationController *firstcolorviewcontroller;
@property (nonatomic, strong) UINavigationController *firsttempviewcontroller;
@property (nonatomic, strong) UINavigationController *firstsettingviewcontroller;
@property (nonatomic, strong) UINavigationController *firstclockviewcontroller;

@property (nonatomic, strong) tempsmodel *Tmodel;


@end

@implementation ViewController
static ViewController *instance = nil;
+ (instancetype)sharedViewController
{
    return instance;
}

- (void)viewDidLoad {
    
    instance = self;
    [super viewDidLoad];
    
    self.jlble = [JLBLEManager sharedBLEManager];
    self.jlble.delegate = self;
    
    self.firstcolorviewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"colornavigationcontroller"];
    self.firsttempviewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"tempnavigationcontroller"];
    self.firstsettingviewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"settingnavigationcontroller"];
    self.firstclockviewcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"clocknavigationcontroller"];
    
    self.aiv = [[UIActivityIndicatorView alloc]init];
    self.aiv.frame = CGRectMake(self.view.center.x-25, 100, 50, 50);
    self.aiv.color = [UIColor colorWithRed:4/255.0 green:165/255.0 blue:218/255.0 alpha:1.0];
    self.aiv.hidden = YES;
    [self.view addSubview:self.aiv];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)begin:(id)sender {
    UIButton *b = (UIButton *)sender;
    
    if (self.aiv.hidden) {
        [b setTitle:@"关闭扫描" forState:UIControlStateNormal];
        self.aiv.hidden = NO;
        [self.aiv startAnimating];
        [self.jlble findPeripherals];
    }
    else{
        [b setTitle:@"查找设备" forState:UIControlStateNormal];
        self.aiv.hidden = YES;
        [self.aiv stopAnimating];
//        [self.jlble findPeripherals];
    }

}
- (void)load
{
    [self.jlble connectPeripherals];
    [JLProgressHUD showHUDAddedTo:self.view animated:YES];
}
- (void)cancal
{
    [self.set removeFromSuperview];
}
#pragma mark - tableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *customcellIdentifier = @"customcellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:customcellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:customcellIdentifier];
    }
    CBPeripheral *p = [self.jlble.foundPeripherals firstObject];
    cell.textLabel.text = p.name;
    NSLog(@"name:%@",p.name);
    //cell.textLabel.text = self.jlble.foundPeripherals[indexPath.row][@"name"];
    return cell;
}
#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.set.select addTarget:self action:@selector(load) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - JLBLEManager
- (void)bleManagerDidFindPeripherals
{
    [self.aiv stopAnimating];
    self.set = [[[NSBundle mainBundle]loadNibNamed:@"setting" owner:self options:nil] firstObject];
    self.tableview = [[UITableView alloc]init];
    self.tableview.frame = CGRectMake(0, 30, 160, 170);
    
//    self.tableview.backgroundColor = [UIColor redColor];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    [self.set.views addSubview:self.tableview];
    [JLScaleAnimation scaleAnimationShowForView:self.set completionHandler:^{
        self.set.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        [self.view addSubview:self.set];
    }];
    
    [self.set.cancal addTarget:self action:@selector(cancal) forControlEvents:UIControlEventTouchUpInside];
   
}
- (void)bleManagerDidConnectPeripherals
{
    
}
- (void)bleManagerDidDisconnectPeripherals
{
    
}
- (void)bleManagerWithModules:(NSSet *)modules
{
    self.tabbar = [self.storyboard instantiateViewControllerWithIdentifier:@"tabbarcontroller"];
    
        
    NSMutableArray *switcharray = [@[] mutableCopy];
    NSLog(@"%@",modules);
    [JLProgressHUD hideHUDForView:self.view animated:YES];
    if ([modules containsObject:@"Clock"]) {
            [switcharray addObject:self.firstclockviewcontroller];
        }
    if ([modules containsObject:@"Temp"]) {
            [switcharray  addObject:self.firsttempviewcontroller];
        }
    if ([modules containsObject:@"Color"]) {
            [switcharray addObject:self.firstcolorviewcontroller];
        }
        [switcharray addObject:self.firstsettingviewcontroller];
    self.tabbar.viewControllers = switcharray;
    
    if (modules.count == 3) {
         self.tabbar.selectedIndex = 2;
    }
    else {
        self.tabbar.selectedIndex = 1;
    }
    
    [self presentViewController:self.tabbar animated:YES completion:nil];
    [self.set removeFromSuperview];
    
}
- (void)bleManagerWithClocks:(NSArray *)clocks
{
//    firstViewController *firstview = [self.firstclockviewcontroller.viewControllers firstObject];
//    if ([self.tabbar.viewControllers containsObject:self.firstclockviewcontroller]) {
//         firstview.saveclock = [clocks mutableCopy];
//    }
    
    self.saveclocks = clocks;
}
- (void)bleManagerWithColors:(NSArray *)colors
{
//    firstcolorViewController *firstcolorview = [self.firstcolorviewcontroller.viewControllers firstObject];
//    if ([self.tabbar.viewControllers containsObject:self.firstcolorviewcontroller]) {
//        firstcolorview.savecolor = [colors mutableCopy];
//    }
    self.savecolors = [colors mutableCopy];
}
- (void)bleManagerWithTempClocks:(NSArray *)tempClocks
{
//    firsttempViewController *firsttempview = [self.firsttempviewcontroller.viewControllers firstObject];
//    if ([self.tabbar.viewControllers containsObject:self.firsttempviewcontroller]) {
//        firsttempview.savetemp = [tempClocks mutableCopy];
//    }
    self.savetemps = [tempClocks mutableCopy];
}
- (void)bleManagerWithTempStatus:(NSDictionary *)tempStatus
{
//    firsttempViewController *firsttempview = [self.firsttempviewcontroller.viewControllers firstObject];
//    if ([self.tabbar.viewControllers containsObject:self.firsttempviewcontroller]) {
//        firsttempview.firstemps = [tempStatus mutableCopy];
//    }
    self.savefirsttemps = tempStatus;
    
}
- (void)bleManagerWithColorStatus:(NSDictionary *)colorStatus
{
//    firstcolorViewController *firstcolorview = [self.firstcolorviewcontroller.viewControllers firstObject];
//    if ([self.tabbar.viewControllers containsObject:self.firstcolorviewcontroller]) {
//        firstcolorview.firstcolors = [colorStatus mutableCopy];
//    }
    self.savefirstcolors = colorStatus;
}

@end
