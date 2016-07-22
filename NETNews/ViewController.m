//
//  ViewController.m
//  NETNews
//
//  Created by MJ on 16/7/22.
//  Copyright © 2016年 kopuCoder. All rights reserved.
//

#import "ViewController.h"
#import "kpMenuScrollView.h"
#import "ViewController7.h"
#import "ViewController6.h"
#import "ViewController5.h"
#import "ViewController4.h"
#import "ViewController3.h"
#import "ViewController2.h"
#import "ViewController1.h"
#define kWidth   [UIScreen mainScreen].bounds.size.width
#define kHeight  [UIScreen mainScreen].bounds.size.height
@interface ViewController ()<UIScrollViewDelegate>
@property (nonatomic,weak)    UIScrollView * scrollView;
@property (nonatomic,weak)    kpMenuScrollView * menuView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加子控制器
    [self setupChildsVC];
    //创建UI
    [self setupUI];
}

- (void)setupChildsVC{
    self.navigationController.navigationBar.translucent =NO;
    ViewController1 * vc1 = [[ViewController1 alloc] init];
    vc1.title = @"头条";
    [self addChildViewController:vc1];
    
    ViewController2 * vc2 = [[ViewController2 alloc] init];
    vc2.title = @"精选";
    [self addChildViewController:vc2];
    
    ViewController3 * vc3 = [[ViewController3 alloc] init];
    vc3.title = @"娱乐";
    [self addChildViewController:vc3];
    
    ViewController4 * vc4 = [[ViewController4 alloc] init];
    vc4.title = @"体育";
    [self addChildViewController:vc4];
    
    ViewController5 * vc5 = [[ViewController5 alloc] init];
    vc5.title = @"网易号";
    [self addChildViewController:vc5];

    ViewController6 * vc6 = [[ViewController6 alloc] init];
    vc6.title = @"视频";
    [self addChildViewController:vc6];
    
    ViewController7 * vc7 = [[ViewController7 alloc] init];
    vc7.title = @"财经";
    [self addChildViewController:vc7];
    
}
- (void)setupUI{
    self.automaticallyAdjustsScrollViewInsets =NO;
    NSArray * titles = [self.childViewControllers valueForKeyPath:@"title"];
        __weak typeof(self)weakSelf = self;
    
    kpMenuScrollView * menuView = [kpMenuScrollView menuScrollViewWithFrame:CGRectMake(0, 0, kWidth, 44) withMenuWidth:0 withTitleArray:^NSArray *{
        return titles;
    }];
    //点击标签回调block
    menuView.ClickIndexBlock = ^(NSUInteger index){
        
        [weakSelf addViewToScrollView:index];
        [weakSelf.scrollView setContentOffset:CGPointMake(weakSelf.scrollView.frame.size.width*index, 0) animated:YES];
    };
    [self.view addSubview:menuView];
    self.menuView = menuView;
    
    //创建子控制器view的内容控件
    CGFloat scrollY = CGRectGetMaxY(menuView.frame);
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, scrollY, kWidth, kHeight - scrollY  -64)];
    scrollView.bounces =NO;
    scrollView.pagingEnabled =YES;
    scrollView.delegate =self;
    self.scrollView = scrollView;
    scrollView.contentSize = CGSizeMake(kWidth*titles.count, 0);
    [self.view addSubview:scrollView];
    
    //默认添加第一页进入内容控件中
    [self addViewToScrollView:0];
}

- (void)addViewToScrollView:(NSInteger)index{
    if(index>=self.childViewControllers.count) return;
    CGFloat offsetX = index*kWidth;
    UIViewController * VC = self.childViewControllers[index];
    if([VC viewIfLoaded]) return; //如果已经加载过了则直接返回
    VC.view.frame = CGRectMake(offsetX, 0, kWidth, self.scrollView.frame.size.height);
    [self.scrollView addSubview:VC.view];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int index = (int)(scrollView.contentOffset.x/scrollView.frame.size.width +0.5);
    [self.menuView setMenuSelectIndex:index];
    [self addViewToScrollView:index];//切换控制器
    
    #warning TODO:需要在这里调用这个方法
    [self.menuView setOutScrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
        #warning TODO:需要在这里调用这个方法
    [self.menuView setOutScrollViewDidScroll:scrollView];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
