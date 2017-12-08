//
//  firstcolorViewController.m
//  LEDDemo
//
//  Created by shibaosheng on 15/10/29.
//  Copyright © 2015年 Sheng. All rights reserved.
//

#import "firstcolorViewController.h"
#import "colorsaveViewController.h"

#import "ViewController.h"
#import "JLBLEManager.h"

@interface firstcolorViewController ()

@property (nonatomic, strong) NSMutableDictionary *colordict;
@property (nonatomic, strong) JLBLEManager *blem;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) ViewController *viewcontroller;
//颜色传值
@property (nonatomic, strong) NSMutableArray *savecolor;
@property (nonatomic, strong) NSMutableDictionary *firstcolors;
@property (nonatomic, strong) NSMutableArray *colors;

@end

@implementation firstcolorViewController
static int i = 0;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewcontroller = [ViewController sharedViewController];
    self.firstcolors = [self.viewcontroller.savefirstcolors mutableCopy];
    self.colors = [self.viewcontroller.savecolors mutableCopy];
    self.navigationItem.title = @"颜色";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadcolor:) name:@"firstcolor" object:nil];
    [self loadcolorviewwithcolor];
    self.blem = [JLBLEManager sharedBLEManager];

}
- (void)reloadcolor:(NSNotification *)fication
{
    self.firstcolors = fication.object;
    [self loadcolorviewwithcolor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)loadcolorviewwithcolor
{
    //颜色视图进入时的变化
    self.colorRslider.value = [self.firstcolors[@"R"] integerValue];
    self.colorGslider.value = [self.firstcolors[@"G"] integerValue];
    self.colorBslider.value = [self.firstcolors[@"B"] integerValue];
    self.colorRlabel.text = self.firstcolors[@"R"];
    self.colorGlabel.text = self.firstcolors[@"G"];
    self.colorBlabel.text = self.firstcolors[@"B"];
    [self.colorswitch1 setOn:[self.firstcolors[@"C"] integerValue]];
    [self.colorswitch2 setOn: [self.firstcolors[@"Switch2Status"] integerValue]];
    self.colorcolorimageview.backgroundColor = [UIColor colorWithRed:self.colorRslider.value/255.0 green:self.colorGslider.value/255.0 blue:self.colorBslider.value/255.0 alpha:1.0];
    [self.blem sendInstruction:[NSString stringWithFormat:@"8872AD04%02x%02x%02x%02x",(int)self.colorRslider.value,(int)self.colorGslider.value,(int)self.colorGslider.value,self.colorswitch1.isOn]];
}
#pragma mark - color action
- (IBAction)Rslider:(id)sender {
    self.colorcolorimageview.backgroundColor = [UIColor colorWithRed:self.colorRslider.value/255.0 green:self.colorGslider.value/255.0 blue:self.colorBslider.value/255.0 alpha:1.0];
    self.colorRlabel.text = [NSString stringWithFormat:@"%0.0f",self.colorRslider.value];
}
- (IBAction)gslider:(id)sender {
    self.colorcolorimageview.backgroundColor = [UIColor colorWithRed:self.colorRslider.value/255.0 green:self.colorGslider.value/255.0 blue:self.colorBslider.value/255.0 alpha:1.0];
    self.colorGlabel.text = [NSString stringWithFormat:@"%0.0f",self.colorGslider.value];
}
- (IBAction)bslider:(id)sender {
    self.colorcolorimageview.backgroundColor = [UIColor colorWithRed:self.colorRslider.value/255.0 green:self.colorGslider.value/255.0 blue:self.colorBslider.value/255.0 alpha:1.0];
    self.colorBlabel.text = [NSString stringWithFormat:@"%0.0f",self.colorBslider.value];
}
- (IBAction)colorsave:(id)sender {
//    colorsaveViewController *colorsaveview = [self.storyboard instantiateViewControllerWithIdentifier:@"colorsaveViewController"];
//    [self.navigationController pushViewController:colorsaveview animated:YES];
//    colorsaveview.savercolor = [NSString stringWithFormat:@"%0.0f",self.colorRslider.value];
//    colorsaveview.savegcolor = [NSString stringWithFormat:@"%0.0f",self.colorGslider.value];
//    colorsaveview.savebcolor = [NSString stringWithFormat:@"%0.0f",self.colorBslider.value];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"savecolorSegue"]) {
        UINavigationController *navigation = segue.destinationViewController;
        colorsaveViewController *colorsaveview = [navigation.viewControllers firstObject];
        colorsaveview.savercolor = [NSString stringWithFormat:@"%0.0f",self.colorRslider.value];
        colorsaveview.savegcolor = [NSString stringWithFormat:@"%0.0f",self.colorGslider.value];
        colorsaveview.savebcolor = [NSString stringWithFormat:@"%0.0f",self.colorBslider.value];
        colorsaveview.saveon = [NSString stringWithFormat:@"%d",self.colorswitch1.isOn];
    }
}
#pragma mark - saving
- (IBAction)savingred:(id)sender {
    [self.blem sendInstruction:[NSString stringWithFormat:@"8872AD04%02x%02x%02x%02x",(int)self.colorRslider.value,(int)self.colorGslider.value,(int)self.colorGslider.value,self.colorswitch1.isOn]];
    NSLog(@"%@",[NSString stringWithFormat:@"8872AD04%02x%02x%02x%02x",(int)self.colorRslider.value,(int)self.colorGslider.value,(int)self.colorBslider.value,self.colorswitch1.isOn]);
    [self.colorswitch2 setOn:NO];

}
- (IBAction)savinggreen:(id)sender {
     NSLog(@"%@",[NSString stringWithFormat:@"8872AD04%02x%02x%02x%02x",(int)self.colorRslider.value,(int)self.colorGslider.value,(int)self.colorBslider.value,self.colorswitch1.isOn]);
    [self.blem sendInstruction:[NSString stringWithFormat:@"8872AD04%02x%02x%02x%02x",(int)self.colorRslider.value,(int)self.colorGslider.value,(int)self.colorBslider.value,self.colorswitch1.isOn]];
    [self.colorswitch2 setOn:NO];

}
- (IBAction)savingblue:(id)sender {
     NSLog(@"%@",[NSString stringWithFormat:@"8872AD04%02x%02x%02x%02x",(int)self.colorRslider.value,(int)self.colorGslider.value,(int)self.colorBslider.value,self.colorswitch1.isOn]);
    [self.blem sendInstruction:[NSString stringWithFormat:@"8872AD04%02x%02x%02x%02x",(int)self.colorRslider.value,(int)self.colorGslider.value,(int)self.colorBslider.value,self.colorswitch1.isOn]];
    [self.colorswitch2 setOn:NO];

}

- (IBAction)savingswitch1:(id)sender {
    NSLog(@"%@",[NSString stringWithFormat:@"8872AD04%02x%02x%02x%02x",(int)self.colorRslider.value,(int)self.colorGslider.value,(int)self.colorBslider.value,self.colorswitch1.isOn]);
   [self.blem sendInstruction:[NSString stringWithFormat:@"8872AD04%02x%02x%02x%02x",(int)self.colorRslider.value,(int)self.colorGslider.value,(int)self.colorBslider.value,self.colorswitch1.isOn]];
}
- (IBAction)savingswitch2:(id)sender {
    NSLog(@"%@",[NSString stringWithFormat:@"88729401%02x",self.colorswitch2.isOn]);
    [self.blem sendInstruction:[NSString stringWithFormat:@"88729401%02x",self.colorswitch2.isOn]];
//    UISwitch *replace = (UISwitch *)sender;
//    if (replace.isOn) {
//        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(colorchanged) userInfo:nil repeats:YES];
//        NSLog(@"open");
//    }
//    else {
//        [self.timer invalidate];
//        NSLog(@"close");
//    }
//    NSLog(@"s:%d",replace.isOn);
}
- (void)colorchanged
{
    self.colorcolorimageview.backgroundColor = [UIColor colorWithRed:[self.colors[(i+16)%16][@"R"] integerValue]/255.0 green:[self.colors[(i+16)%16][@"G"] integerValue]/255.0 blue:[self.colors[(i+16)%16][@"B"] integerValue]/255.0 alpha:1.0];
    i++;
}

@end
