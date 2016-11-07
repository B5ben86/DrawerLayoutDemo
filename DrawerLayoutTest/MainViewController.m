//
//  MainViewController.m
//  DrawerLayoutTest
//
//  Created by Ben on 2016/11/6.
//  Copyright © 2016年 Ben. All rights reserved.
//

#import "MainViewController.h"
#import "ContainerViewController.h"

@interface MainViewController ()

@property (nonatomic, weak) ContainerViewController *containerViewController;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.containerViewController = (ContainerViewController *) self.parentViewController.parentViewController;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)leftMenuButtonAction:(UIBarButtonItem *)sender {
    [self.containerViewController showLeftMenu];
    [self.containerViewController showBackgroundView];
}

- (IBAction)rightMenuButtonAction:(UIBarButtonItem *)sender {
    [self.containerViewController showRightMenu];
    [self.containerViewController showBackgroundView];
}


@end
