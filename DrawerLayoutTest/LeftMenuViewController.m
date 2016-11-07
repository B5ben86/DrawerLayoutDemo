//
//  LeftMenuViewController.m
//  DrawerLayoutTest
//
//  Created by Ben on 2016/11/7.
//  Copyright © 2016年 Ben. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "ContainerViewController.h"

@interface LeftMenuViewController ()
@property (weak, nonatomic) IBOutlet UIView *transparentView;

@property (weak, nonatomic) IBOutlet UIView *booksView;
@property (weak, nonatomic) IBOutlet UIView *tagView;

@property (nonatomic, weak) ContainerViewController *containerViewController;

@property (nonatomic, assign) CGFloat panGestureStartPointX;

@end

@implementation LeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.containerViewController = (ContainerViewController *)self.parentViewController;
    
    [self gestureRecognizerInitial];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)gestureRecognizerInitial {
    UITapGestureRecognizer *transparentViewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(transparentViewTapHandler:)];
    
    [self.transparentView addGestureRecognizer:transparentViewTapGestureRecognizer];
    
    UITapGestureRecognizer *bookViewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(transparentViewTapHandler:)];
    [self.booksView addGestureRecognizer:bookViewTapGestureRecognizer];
    
    UITapGestureRecognizer *tagViewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(transparentViewTapHandler:)];
    [self.tagView addGestureRecognizer:tagViewTapGestureRecognizer];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerHandler:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
}

- (void)transparentViewTapHandler:(UITapGestureRecognizer *)gestureRecognizer {
    [self.containerViewController dismissLeftMenu];
    [self.containerViewController dismissBackgroundView];
}

- (void)panGestureRecognizerHandler:(UIPanGestureRecognizer *)gestureRecognizer {
    //获取手指相对于屏幕的坐标
    CGPoint gesturePoint = [gestureRecognizer locationInView:self.containerViewController.view];
    CGFloat windowWidth = self.containerViewController.view.frame.size.width;
    
    //滑动开始，保存初始坐标
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.panGestureStartPointX = gesturePoint.x;
    }
    //滑动过程中，动态改变 menuView 位置及 backgroundView 透明度
    else if (gestureRecognizer.state != UIGestureRecognizerStateEnded) {
        CGFloat deltaX = 0;
        
        //计算手指相对起始位置的滑动距离
        deltaX = self.panGestureStartPointX - gesturePoint.x;
        
        //如果滑动距离是负数，则说明手指滑动方向与侧栏回收方向相反，无需处理
        if (deltaX > 0.0) {
            CGFloat newPointX = 0.0;
            CGFloat newBgAlpha = 0.0;
            CGFloat bgViewFinalAlpha = [self.containerViewController getBgViewFinalAlphaValue];
            
            newPointX = -deltaX;
            newBgAlpha = (newPointX + windowWidth) / windowWidth * bgViewFinalAlpha;
            
            //更新 menuView 显示位置
            CGRect newFrame = CGRectMake(newPointX, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
            [self.containerViewController modifyMenuViewFrame:newFrame menuType:MENU_TYPE_LEFT_MENU];
            //更新 backgroundView 透明度
            [self.containerViewController modifyBackgroundViewAlpha:newBgAlpha];
        }
    }
    //滑动结束后，判断该弹出还是收回 menuView
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGFloat minOffset = [self.containerViewController getMinOffset];
        //计算 menuView 的最终位移
        CGFloat viewOffset = -self.containerViewController.leftMenuContainerView.frame.origin.x;
        //弹出/收回侧栏
        if (viewOffset > minOffset) {
            [self.containerViewController dismissLeftMenu];
            [self.containerViewController dismissBackgroundView];
        }
        else {
            [self.containerViewController showLeftMenu];
            [self.containerViewController showBackgroundView];
        }
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
