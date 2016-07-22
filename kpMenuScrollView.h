//
//  kpMenuScrollView.h
//  NETNews
//
//  Created by MJ on 16/7/22.
//  Copyright © 2016年 kopuCoder. All rights reserved.


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@interface kpMenuScrollView : UIView<UIScrollViewDelegate>

/**
 *  创建滚动菜单
 *
 *  @param frame       菜单视图位置，如果发现滚动区域不对，需要设置视图所在控制器的：self.automaticallyAdjustsScrollViewInsets =NO;
 *  @param titlesBlock 标签数组
 *
 */
+ (__kindof UIView *)menuScrollViewWithFrame:(CGRect)frame withMenuWidth:(CGFloat)menuWidth withTitleArray:(NSArray *(^)())titlesBlock;

/**外部设置当前算中第几个标签*/
- (void)setMenuSelectIndex:(NSUInteger)selectedIndex;

#pragma mark ---需要在外部ScrollView代理对应的方法中调用以下方法---
 /**需要在外部ScrollView 的代理scrollViewDidScroll中调用*/
- (void)setOutScrollViewDidScroll:(UIScrollView *)outScrollView;

 /**需要在外部ScrollView 的代理scrollViewDidEndDecelerating中调用*/
- (void)setOutScrollViewDidEndDecelerating:(UIScrollView *)outScrollView;



/**点击了第几个标签**/
@property (nonatomic,strong)void(^ClickIndexBlock)(NSUInteger index);
@end
