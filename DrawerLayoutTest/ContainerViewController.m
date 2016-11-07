//
//  ContainerViewController.m
//  DrawerLayoutTest
//
//  Created by Ben on 2016/11/6.
//  Copyright © 2016年 Ben. All rights reserved.
//

#import "ContainerViewController.h"

@interface ContainerViewController ()

@property (weak, nonatomic) IBOutlet UIView *mainContainerView;

@property (weak, nonatomic) IBOutlet UIView *backgroundView;

//侧边栏弹出/收回动画持续时间，单位：秒
@property (nonatomic, assign) CGFloat menuAnimationDuration;
//黑色背景渐隐渐显动画持续时间，单位：秒
@property (nonatomic, assign) CGFloat bgViewAnimationDuration;
//backgroundView 显示时的 alpha 值
@property (nonatomic, assign) CGFloat bgViewFinalAlpha;

//屏幕边缘滑动手势
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *screenEdgePanGestureRecognizerRight;
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *screenEdgePanGestureRecognizerLeft;
//用于保存滑动手势起始坐标
@property (nonatomic, assign) CGFloat panGestureStartPointX;
//侧栏弹出/收回判断的最小位移
@property (nonatomic, assign) CGFloat minOffset;

@end

@implementation ContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"ContainerViewController viewDidLoad");
    
    [self viewDataInitial];
    [self gestureRecognizerInitial];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self viewItemInitial];
}


#pragma public function
- (void)showBackgroundView {
    [self.backgroundView setHidden:NO];
    
    [UIView animateWithDuration:self.bgViewAnimationDuration animations:^{
        [self.backgroundView setAlpha:self.bgViewFinalAlpha];
    }];
}

- (void)dismissBackgroundView {
    [UIView animateWithDuration:self.bgViewAnimationDuration animations:^{
        [self.backgroundView setAlpha:0.0];
    } completion:^(BOOL finished) {
        [self.backgroundView setHidden:YES];
    }];
}

- (void)modifyBackgroundViewAlpha:(CGFloat) newAlpha {
    if (newAlpha >= 0.0 && newAlpha <= 1.0) {
        [self.backgroundView setAlpha:newAlpha];
    }
}

- (CGFloat)getBgViewFinalAlphaValue {
    return self.bgViewFinalAlpha;
}

- (CGFloat)getMinOffset {
    return self.minOffset;
}

- (void)showLeftMenu {
    [self showMenu:self.leftMenuContainerView menuType:MENU_TYPE_LEFT_MENU];
    [self disableEdgePanGestureRecognizer];
}

- (void)dismissLeftMenu {
    [self dismissMenu:self.leftMenuContainerView menuType:MENU_TYPE_LEFT_MENU];
    [self enableEdgePanGestureRecognizer];
}

- (void)showRightMenu {
    [self showMenu:self.rightMenuContainerView menuType:MENU_TYPE_RIGHT_MENU];
    [self disableEdgePanGestureRecognizer];
}

- (void)dismissRightMenu {
    [self dismissMenu:self.rightMenuContainerView menuType:MENU_TYPE_RIGHT_MENU];
    [self enableEdgePanGestureRecognizer];
}

- (void)modifyMenuViewFrame:(CGRect) newFrame menuType:(MENU_TYPE)menuType {
    if (menuType == MENU_TYPE_LEFT_MENU) {
        [self.leftMenuContainerView setFrame:newFrame];
    }
    else if (menuType == MENU_TYPE_RIGHT_MENU) {
        [self.rightMenuContainerView setFrame:newFrame];
    }
}


#pragma private function
- (void)viewDataInitial {
    self.bgViewAnimationDuration = 0.3;
    self.bgViewFinalAlpha = 0.7;
    self.menuAnimationDuration = 0.3;
    self.minOffset = self.view.frame.size.width / 4.0;
}

- (void)viewItemInitial {
    //设置 backgroundView 初始隐藏状态及透明度
    [self.backgroundView setAlpha:0.0];
    [self.backgroundView setHidden:YES];
    
    CGRect windowFrame = self.view.frame;
    CGFloat startX = 0.0;
    //设置 leftMenuContainerView 初始位置
    startX = -windowFrame.size.width;
    [self.leftMenuContainerView setFrame:CGRectMake(startX,
                                                   self.leftMenuContainerView.frame.origin.y,
                                                   self.leftMenuContainerView.frame.size.width,
                                                   self.leftMenuContainerView.frame.size.height)];
    
    //设置 rightMenuContainerView 初始位置
    startX = windowFrame.size.width;
    [self.rightMenuContainerView setFrame:CGRectMake(startX,
                                                     self.rightMenuContainerView.frame.origin.y,
                                                     self.rightMenuContainerView.frame.size.width,
                                                     self.rightMenuContainerView.frame.size.height)];
}

- (void)gestureRecognizerInitial {
    self.screenEdgePanGestureRecognizerLeft = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(screenEdgePanGestureRecognizerHandler:)];
    [self.screenEdgePanGestureRecognizerLeft setEdges:UIRectEdgeLeft];
    
    self.screenEdgePanGestureRecognizerRight = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(screenEdgePanGestureRecognizerHandler:)];
    [self.screenEdgePanGestureRecognizerRight setEdges:UIRectEdgeRight];
    
    [self.view addGestureRecognizer:self.screenEdgePanGestureRecognizerLeft];
    [self.view addGestureRecognizer:self.screenEdgePanGestureRecognizerRight];
}

- (void)enableEdgePanGestureRecognizer {
    [self.view addGestureRecognizer:self.screenEdgePanGestureRecognizerLeft];
    [self.view addGestureRecognizer:self.screenEdgePanGestureRecognizerRight];
}

- (void)disableEdgePanGestureRecognizer {
    [self.view removeGestureRecognizer:self.screenEdgePanGestureRecognizerLeft];
    [self.view removeGestureRecognizer:self.screenEdgePanGestureRecognizerRight];
}

- (void)screenEdgePanGestureRecognizerHandler:(UIScreenEdgePanGestureRecognizer *)gestureRecognizer {
    if ((gestureRecognizer.edges == UIRectEdgeLeft) || (gestureRecognizer.edges == UIRectEdgeRight)) {
        //获取手指相对于屏幕的坐标
        CGPoint gesturePoint = [gestureRecognizer locationInView:self.view];
        CGFloat windowWidth = self.view.frame.size.width;
        
        //滑动开始，保存初始坐标
        if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
            self.panGestureStartPointX = gesturePoint.x;
            [self.backgroundView setHidden:NO];
        }
        //滑动过程中，动态改变 menuView 位置及 backgroundView 透明度
        else if (gestureRecognizer.state != UIGestureRecognizerStateEnded) {
            CGFloat deltaX = 0;
            
            //计算手指相对起始位置的滑动距离
            deltaX = (gestureRecognizer.edges == UIRectEdgeLeft) ?
                    (gesturePoint.x - self.panGestureStartPointX) : (self.panGestureStartPointX - gesturePoint.x);
            
            //如果滑动距离是负数，则说明手指滑动方向与侧栏弹出反向相反，无需处理
            if (deltaX > 0.0) {
                CGFloat newPointX = 0.0;
                CGFloat newBgAlpha = 0.0;
                UIView *menuView = nil;
                
                if (gestureRecognizer.edges == UIRectEdgeLeft) {
                    newPointX = -windowWidth + deltaX;
                    newBgAlpha = (newPointX + windowWidth) / windowWidth * self.bgViewFinalAlpha;
                    menuView = self.leftMenuContainerView;
                }
                else {
                    newPointX = windowWidth - deltaX;
                    newBgAlpha = (windowWidth - newPointX) / windowWidth * self.bgViewFinalAlpha;
                    menuView = self.rightMenuContainerView;
                }
                
                //更新 menuView 显示位置
                [menuView setFrame:CGRectMake(newPointX, menuView.frame.origin.y, menuView.frame.size.width, menuView.frame.size.height)];
                //更新 backgroundView 透明度
                [self.backgroundView setAlpha:newBgAlpha];
            }
        }
        //滑动结束后，判断该弹出还是收回 menuView
        else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
            //计算 menuView 的最终位移
            CGFloat viewOffset = (gestureRecognizer.edges == UIRectEdgeLeft) ?
                                (self.leftMenuContainerView.frame.origin.x + windowWidth) : (windowWidth - self.rightMenuContainerView.frame.origin.x);
            //弹出/收回侧栏
            if (viewOffset > self.minOffset) {
                (gestureRecognizer.edges == UIRectEdgeLeft) ? ([self showLeftMenu]) : ([self showRightMenu]);
                [self showBackgroundView];
            }
            else {
                (gestureRecognizer.edges == UIRectEdgeLeft) ? ([self dismissLeftMenu]) : ([self dismissRightMenu]);
                [self dismissBackgroundView];
            }
        }
    }
}

- (void)showMenu:(UIView *) view menuType:(MENU_TYPE) menuType {
    CGFloat finalX = 0.0;
    
    if (menuType == MENU_TYPE_UNKNOWN) {
        return;
    }
    
    [UIView animateWithDuration:self.menuAnimationDuration animations:^{
        [view setFrame:CGRectMake(finalX,
                                  view.frame.origin.y,
                                  view.frame.size.width,
                                  view.frame.size.height)];
    }];
}

- (void)dismissMenu:(UIView *) view menuType:(MENU_TYPE) menuType {
    CGRect windowFrame = self.view.frame;
    
    CGFloat finalX = 0.0;
    
    if (menuType == MENU_TYPE_LEFT_MENU) {
        finalX = 0 - windowFrame.size.width;
    }
    else if (menuType == MENU_TYPE_RIGHT_MENU) {
        finalX = windowFrame.size.width;
    }
    else {
        return;
    }
    
    [UIView animateWithDuration:self.menuAnimationDuration animations:^{
        [view setFrame:CGRectMake(finalX,
                                  view.frame.origin.y,
                                  view.frame.size.width,
                                  view.frame.size.height)];
    }];
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
