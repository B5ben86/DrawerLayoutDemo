//
//  ContainerViewController.h
//  DrawerLayoutTest
//
//  Created by Ben on 2016/11/6.
//  Copyright © 2016年 Ben. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MENU_TYPE) {
    MENU_TYPE_UNKNOWN = 0,
    MENU_TYPE_LEFT_MENU = 1,
    MENU_TYPE_RIGHT_MENU = 2
};

@interface ContainerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *leftMenuContainerView;
@property (weak, nonatomic) IBOutlet UIView *rightMenuContainerView;


- (void)showBackgroundView;

- (void)dismissBackgroundView;

- (void)modifyBackgroundViewAlpha:(CGFloat) newAlpha;

- (CGFloat)getBgViewFinalAlphaValue;

- (CGFloat)getMinOffset;

- (void)showLeftMenu;

- (void)dismissLeftMenu;

- (void)showRightMenu;

- (void)dismissRightMenu;

- (void)modifyMenuViewFrame:(CGRect) newFrame menuType:(MENU_TYPE)menuType;

@end
