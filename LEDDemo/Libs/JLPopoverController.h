//
//  JLPopoverViewController.h
//  JanLion
//
//  Created by Jan Lion(Jan.Lion@qq.com) on 14-2-7.
//  Copyright (c) 2014年 Jan Lion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLPopoverTouchesDelegate.h"

enum {
    JLPopoverArrowDirectionTop = 0,
	JLPopoverArrowDirectionRight,
    JLPopoverArrowDirectionBottom,
    JLPopoverArrowDirectionLeft
};
typedef NSUInteger JLPopoverArrowDirection;

enum {
    JLPopoverArrowPositionVertical = 0,
    JLPopoverArrowPositionHorizontal
};
typedef NSUInteger JLPopoverArrowPosition;

@class JLPopoverPopoverView;

@interface JLPopoverController : UIViewController <JLPopoverTouchesDelegate>
{
    JLPopoverPopoverView * popoverView;
    JLPopoverArrowDirection arrowDirection;
    CGRect screenRect;
    int titleLabelheight;
}

@property (strong, nonatomic) UIViewController *contentViewController;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) NSString *titleText;
@property (strong, nonatomic) UIColor *titleColor;
@property (strong, nonatomic) UIFont *titleFont;
@property (strong, nonatomic) UIColor *popoverBaseColor;
@property (nonatomic) int cornerRadius;
@property (nonatomic, readwrite) JLPopoverArrowPosition arrowPosition;
@property (nonatomic) BOOL popoverGradient; 

- (id)initWithContentViewController:(UIViewController*)viewController;
- (id)initWithView:(UIView*)view;
- (void) showPopoverWithTouch:(UIEvent*)senderEvent;
- (void) showPopoverWithCell:(UITableViewCell*)senderCell;
- (void) showPopoverWithRect:(CGRect)senderRect;
- (void) view:(UIView*)view touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event;
- (void) dismissPopoverAnimatd:(BOOL)animated;

@end
