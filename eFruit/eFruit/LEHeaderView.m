//
//  LEHeaderView.m
//  Tuan
//
//  Created by Eda on 15/10/26.
//  Copyright © 2015年 Eda. All rights reserved.
//

#import "LEHeaderView.h"
@interface LEHeaderView ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
// 创建一个用来引用计时器对象的属性
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation LEHeaderView
+ (instancetype)headerView
{
    LEHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"LEHeaderView" owner:nil options:nil] firstObject];
    return headerView;
}


- (void)awakeFromNib
{
    CGFloat imgW = 320;
    CGFloat imgH = 115;
    CGFloat imgY = 0;
    // 1. 循环创建5个UIImageView添加到ScrollView中
    for (int i = 0; i < 5; i++) {
        // 创建一个UIImageView
        UIImageView *imgView = [[UIImageView alloc] init];
        
        // 设置UIImageView中的图片
        NSString *imgName = [NSString stringWithFormat:@"ad_%02d", i];
        imgView.image = [UIImage imageNamed:imgName];
        
        // 计算每个UIImageView在UIScrollView中的x坐标值
        CGFloat imgX = i * imgW;
        // 设置imgView的frame
        imgView.frame = CGRectMake(imgX, imgY, imgW, imgH);
        
        // 把imgView添加到UIScrollView中
        [self.scrollView addSubview:imgView];
    }
    
    
    // 设置UIScrollView的contentSize(内容的实际大小)
    CGFloat maxW = self.scrollView.frame.size.width * 5;
    self.scrollView.contentSize = CGSizeMake(maxW, 0);
    
    
    // 实现UIScrollView的分页效果
    // 当设置允许分页以后, UIScrollView会按照自身的宽度作为一页来进行分页。
    self.scrollView.pagingEnabled = YES;
    
    // 隐藏水平滚动指示器
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    // 指定UIPageControl的总页数
    self.pageControl.numberOfPages = 5;
    
    // 指定默认是第0页
    self.pageControl.currentPage = 0;
    
    
    // 创建一个"计时器"控件NSTimer控件
    // 通过scheduledTimerWithInterval这个方法创建的计时器控件, 创建好以后自动启动
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(scrollImage) userInfo:nil repeats:YES];
    
    // 修改self.timer的优先级与控件一样
    // 获取当前的消息循环对象
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    // 改变self.timer对象的优先级
    [runLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    //    [self.scrollView bringSubviewToFront:self.pageControl];

}


- (void)scrollImage
{
    // 每次执行这个方法的时候, 都要让图片滚动到下一页
    // 如何让UIScrollView滚动到下一页?
    // 1. 获取当前的UIPageControl的页码
    NSInteger page = self.pageControl.currentPage;
    
    // 2. 判断页码是否到了最后一页, 如果到了最后一页, 那么设置页码为0（回到第一页）。如果没有到达最后一页, 则让页码+1
    if (page == self.pageControl.numberOfPages - 1) {
        // 表示已经到达最后一页了
        page = 0; // 回到第一页
    } else {
        page++;
    }
    // 3. 用每页的宽度 * (页码 + 1) == 计算除了下一页的contentOffset.x
    CGFloat offsetX = page * self.scrollView.frame.size.width;
    
    // 4. 设置UIScrollView的contentOffset等于新的偏移的值
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
    
    // 如果图片现在已经滚动到最后一页了, 那么就滚动到第一页
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    // 如何计算当前滚动到了第几页？
    // 1. 获取滚动的x方向的偏移值
    CGFloat offsetX = scrollView.contentOffset.x;
    // 用已经偏移了得值, 加上半页的宽度
    offsetX = offsetX + (scrollView.frame.size.width * 0.5);
    
    // 2. 用x方向的偏移的值除以一张图片的宽度(每一页的宽度)，取商就是当前滚动到了第几页（索引）
    int page = offsetX / scrollView.frame.size.width;
    
    // 3. 将页码设置给UIPageControl
    self.pageControl.currentPage = page;
    
}

// 实现即将开始拖拽的方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 停止计时器
    // 调用invalidate一旦停止计时器, 那么这个计时器就不可再重用了。下次必须重新创建一个新的计时器对象。
    [self.timer invalidate];
    
    // 因为当调用完毕invalidate方法以后, 这个计时器对象就已经废了，无法重用了。所以可以直接将self.timer设置为nil
    self.timer = nil;
}

// 实现拖拽完毕的方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    // 重新启动一个计时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(scrollImage) userInfo:nil repeats:YES];
    
    // 再次修改一下新创建的timer的优先级
    // 修改self.timer的优先级与控件一样
    // 获取当前的消息循环对象
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    // 改变self.timer对象的优先级
    [runLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
}

@end
