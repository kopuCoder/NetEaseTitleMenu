//
//  kpMenuScrollView.m
//  NETNews
//
//  Created by MJ on 16/7/22.
//  Copyright © 2016年 kopuCoder. All rights reserved.
//  可以滚动的菜单选项，类似网易信息顶部菜单筛选

#import "kpMenuScrollView.h"
#import "kpGlobleConst.h"

#define titleScaleRation 0.3 //可设置缩放比例
#define defalutMenuWidth 90 //默认标签宽度
@interface kpMenuScrollView()

@property (nonatomic,weak)UIScrollView *  scrollView;
@property (nonatomic,strong)NSMutableArray * titlesArray;
@property (nonatomic,strong)NSMutableArray * titleLables;
@property (nonatomic,weak)UILabel *  selLable;//当前选中的label
@property (nonatomic,assign)CGFloat menuWidth;

/** *  标记是否为点击标签--->解决点击标签时，标签跳动的问题 */
@property (nonatomic,assign)BOOL isFromTap;
@end

@implementation kpMenuScrollView

+ (__kindof UIView *)menuScrollViewWithFrame:(CGRect)frame withMenuWidth:(CGFloat)menuWidth withTitleArray:(NSArray *(^)())titlesBlock{
    kpMenuScrollView * menuView = [[kpMenuScrollView alloc] initWithFrame:frame];
    menuView.menuWidth = menuWidth;
    [menuView.titlesArray addObjectsFromArray:titlesBlock()];
    [menuView setupLables];
    return menuView;
}

//创建菜单lables
- (void)setupLables{
    
    __weak typeof(self)weakSelf = self;
    [self.titlesArray enumerateObjectsUsingBlock:^(NSString * title, NSUInteger index, BOOL * _Nonnull stop) {
        
        if(![title isKindOfClass:[NSString class]]){
            NSLog(@"标题存在nil或者为空");
            [weakSelf.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            *stop =YES;
        }
        UILabel * lable = [[UILabel alloc] init];
        lable.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lableClick:)];
        [lable addGestureRecognizer:tap];
        lable.highlighted =NO;
        lable.font = [UIFont systemFontOfSize:16];
        lable.text = title;
        lable.textColor = [UIColor blackColor];
        lable.highlightedTextColor = [UIColor colorWithRed:1.0f green:0 blue:0 alpha:1];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.tag = weakSelf.titleLables.count;
        [weakSelf.scrollView addSubview:lable];
        [weakSelf.titleLables addObject:lable];
        if(weakSelf.titleLables.count == 1){
            [weakSelf setSeletLable:lable];
        }
        
    }];
    
    self.menuWidth = self.menuWidth>0?self.menuWidth:defalutMenuWidth;
    self.scrollView.contentSize = CGSizeMake(self.menuWidth*self.titleLables.count, 0);
    
}

- (void)setupScrollView{
    UIScrollView * scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces =NO;
    scrollView.delegate = self;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
}


#pragma mark ---初始化---      
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setupScrollView];
    }
    return self;
}

#pragma mark ---setter/getter---      

- (NSMutableArray *)titleLables{
    if (!_titleLables) {
        _titleLables = [[NSMutableArray alloc] init];
    }
    return _titleLables;
}

- (NSMutableArray *)titlesArray{
    if (!_titlesArray) {
        _titlesArray = [[NSMutableArray alloc] init];
    }
    return _titlesArray;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGSize selfSize = self.frame.size;
    self.scrollView.frame = self.bounds;
    for (NSUInteger i=0; i<self.titleLables.count; i++) {
        CGFloat menuX =self.menuWidth*i;
        UILabel * lable  =self.titleLables[i];
        lable.frame = CGRectMake(menuX, 0, self.menuWidth, selfSize.height);

    }
    
}

#pragma mark ---delegate---      
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(self.scrollView == scrollView) return;
    //需要判断当前左右滑动，用来改变字体大小和颜色
    CGFloat offsetX = scrollView.contentOffset.x/scrollView.frame.size.width;
    NSInteger currentIndex = (NSInteger)offsetX;
    NSInteger nextIndex = currentIndex+1;
    UILabel * rightLable = nil;
    if(nextIndex<self.titleLables.count-1){
       rightLable = self.titleLables[nextIndex];
    }
    
    CGFloat rightScale = offsetX - currentIndex;
    CGFloat leftScale = 1 - rightScale;
        NSLog(@"leftindex:%ld---rightIndex:%ld",currentIndex,nextIndex);
    UILabel * currentLable = self.titleLables[currentIndex];
    
    // 缩放比例：2-1
    currentLable.transform = CGAffineTransformMakeScale(leftScale*titleScaleRation+1, leftScale*titleScaleRation+1);
    currentLable.textColor = [UIColor colorWithRed:leftScale green:0 blue:0 alpha:1];
    
    // 缩放比例： 1-2
    rightLable.transform = CGAffineTransformMakeScale(rightScale*titleScaleRation+1, rightScale*titleScaleRation+1);
    rightLable.textColor = [UIColor colorWithRed:rightScale green:0 blue:0 alpha:1];
    
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(self.scrollView == scrollView) return;
    self.isFromTap =NO;
    [self setSeletLableCenter:self.selLable.tag];
}


- (void)lableClick:(UITapGestureRecognizer *)tap{
    self.isFromTap =YES;
    UILabel * lable = (UILabel *)tap.view;
    [self setMenuSelectIndex:lable.tag];
    //设置滚动到中心
    [self setSeletLableCenter:lable.tag];
}

/** *  外部设置当前被选中的lable */
- (void)setMenuSelectIndex:(NSUInteger)selectedIndex{
    if(selectedIndex == self.selLable.tag) return;
    if(selectedIndex >=self.titleLables.count) return;
    //设置当前选中lable
    [self setSeletLable:self.titleLables[selectedIndex]];
}

/** *  设置选中lable颜色 */
- (void)setSeletLable:(UILabel *)currentLable{
    
    if(self.selLable == currentLable) return;
    self.selLable.highlighted =NO;
    self.selLable.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    [UIView animateWithDuration:0.25 animations:^{

        self.selLable.transform = CGAffineTransformIdentity;
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
            //设置高亮
            self.selLable.transform = CGAffineTransformMakeScale(titleScaleRation+1, titleScaleRation+1);
        }];
    }];
    currentLable.highlighted =YES;
    self.selLable = currentLable;
    
    NSLog(@"点击了第：%ld",self.selLable.tag);
    if(self.ClickIndexBlock){
        self.ClickIndexBlock(self.selLable.tag);
    }
}


/** *  设置中心*/
- (void)setSeletLableCenter:(NSUInteger)index{
    CGSize selfSize  = self.frame.size;
    if(self.titleLables.count*defalutMenuWidth<=selfSize.width) return;
    
    CGFloat totalDistance = index*self.menuWidth;
    //偏移量
    CGFloat offsetX = totalDistance - selfSize.width*0.5 +self.menuWidth*0.5;
    //最大偏移量
    CGFloat maxOffset = self.scrollView.contentSize.width - selfSize.width;
    
    if(offsetX<0) offsetX = 0;
    if(offsetX>maxOffset) offsetX = maxOffset;
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
}

/**设置外部scrollView和内部滚动器连接*/
- (void)setOutScrollViewDidScroll:(UIScrollView *)outScrollView{
    if(self.selLable&&self.isFromTap) return;
    [self scrollViewDidScroll:outScrollView];
}

- (void)setOutScrollViewDidEndDecelerating:(UIScrollView *)outScrollView{
    [self scrollViewDidEndDecelerating:outScrollView];
}


@end
