//
//  kpRootViewController.m
//  NETNews
//
//  Created by MJ on 16/7/22.
//  Copyright © 2016年 kopuCoder. All rights reserved.
//

#import "kpRootViewController.h"
#import "kpGlobleConst.h"

@interface kpRootViewController ()
@property (nonatomic,weak)UILabel *  lable;

@end

@implementation kpRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RandomColor;
    
    UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    lable.backgroundColor = RandomColor;
    lable.textAlignment = NSTextAlignmentCenter;
    self.lable = lable;
    lable.textColor = RandomColor;
    [self.view addSubview:lable];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.lable.text = self.title;
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

@end
