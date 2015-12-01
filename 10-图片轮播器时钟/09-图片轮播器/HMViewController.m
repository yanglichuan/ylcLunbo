//
//  HMViewController.m
//  09-图片轮播器
//
//  Created by apple on 14-8-18.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "HMViewController.h"

#define kImageCount     5

@interface HMViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSTimer *timer;
@end

@implementation HMViewController

- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 20, 300, 130)];
        _scrollView.backgroundColor = [UIColor redColor];
        
        [self.view addSubview:_scrollView];
        
        // 取消弹簧效果
        _scrollView.bounces = NO;
        
        // 取消水平滚动条
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        
        // 要分页
        _scrollView.pagingEnabled = YES;
        
        // contentSize
        _scrollView.contentSize = CGSizeMake(kImageCount * _scrollView.bounds.size.width, 0);
        
        // 设置代理
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl
{
    if (_pageControl == nil) {
        // 分页控件，本质上和scrollView没有任何关系，是两个独立的控件
        _pageControl = [[UIPageControl alloc] init];
        // 总页数
        _pageControl.numberOfPages = kImageCount;
        // 控件尺寸
        CGSize size = [_pageControl sizeForNumberOfPages:kImageCount];
        
        _pageControl.bounds = CGRectMake(0, 0, size.width, size.height);
        _pageControl.center = CGPointMake(self.view.center.x, 130);
        
        // 设置颜色
        _pageControl.pageIndicatorTintColor = [UIColor redColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
        
        [self.view addSubview:_pageControl];
        
        // 添加监听方法
        /** 在OC中，绝大多数"控件"，都可以监听UIControlEventValueChanged事件，button除外" */
        [_pageControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl;
}

// 分页控件的监听方法
- (void)pageChanged:(UIPageControl *)page
{
    NSLog(@"%d", page.currentPage);
    
    // 根据页数，调整滚动视图中的图片位置 contentOffset
    CGFloat x = page.currentPage * self.scrollView.bounds.size.width;
    [self.scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
}

// 视图加载完成调用，通常用来设置数据
- (void)viewDidLoad
{
    [super viewDidLoad];

    // 设置图片
    for (int i = 0; i < kImageCount; i++) {
        NSString *imageName = [NSString stringWithFormat:@"img_%02d", i + 1];
        UIImage *image = [UIImage imageNamed:imageName];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.scrollView.bounds];
        imageView.image = image;
        
        [self.scrollView addSubview:imageView];
    }
    
    // 计算imageView的位置
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(UIImageView *imageView, NSUInteger idx, BOOL *stop) {
        
        // 调整x => origin => frame
        CGRect frame = imageView.frame;
        frame.origin.x = idx * frame.size.width;
        
        imageView.frame = frame;
    }];
//    NSLog(@"%@", self.scrollView.subviews);
    
    // 分页初始页数为0
    self.pageControl.currentPage = 0;
    
    // 启动时钟
    [self startTimer];
}

- (void)startTimer
{
    self.timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    // 添加到运行循环
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)updateTimer
{
    // 页号发生变化
    // (当前的页数 + 1) % 总页数
    int page = (self.pageControl.currentPage + 1) % kImageCount;
    self.pageControl.currentPage = page;
    
    NSLog(@"%d", self.pageControl.currentPage);
    // 调用监听方法，让滚动视图滚动
    [self pageChanged:self.pageControl];
}

#pragma mark - ScrollView的代理方法
// 滚动视图停下来，修改页面控件的小点（页数）
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 停下来的当前页数
    NSLog(@"%@", NSStringFromCGPoint(scrollView.contentOffset));
    
    // 计算页数
    int page = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    self.pageControl.currentPage = page;
}

/**
 修改时钟所在的运行循环的模式后，抓不住图片
 
 解决方法：抓住图片时，停止时钟，送售后，开启时钟
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"%s", __func__);
    // 停止时钟，停止之后就不能再使用，如果要启用时钟，需要重新实例化
    [self.timer invalidate];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"%s", __func__);
    [self startTimer];
}


@end
