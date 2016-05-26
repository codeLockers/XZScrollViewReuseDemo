//
//  ViewController.m
//  XZScrollViewReuseDemo
//
//  Created by 徐章 on 16/5/25.
//  Copyright © 2016年 徐章. All rights reserved.
//

#import "ViewController.h"
#import "XZViewController.h"

@interface ViewController ()<UIScrollViewDelegate>{

    CGFloat _width;
    CGFloat _height;
}
@property (nonatomic, strong) UIScrollView *scrollView;
/** 重用缓存池*/
@property (nonatomic, strong) NSMutableArray *reusableArray;
/** 可视区域数组*/
@property (nonatomic, strong) NSMutableArray *visbleArray;

@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentPage = -1;
    
    _width = [UIScreen mainScreen].bounds.size.width;
    _height = [UIScreen mainScreen].bounds.size.height;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.scrollView.contentSize = CGSizeMake(_width*7, _height);
    self.scrollView.layer.borderColor = [UIColor redColor].CGColor;
    self.scrollView.layer.borderWidth = 1.0f;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    [self loadPage:0];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setter && Getter
- (NSMutableArray *)reusableArray{

    if (!_reusableArray) {
        _reusableArray = [NSMutableArray array];
    }
    return _reusableArray;
}

- (NSMutableArray *)visbleArray{

    if (!_visbleArray) {
        _visbleArray = [NSMutableArray array];
    }
    return _visbleArray;
}

#pragma mark - Private_Methods
- (void)loadPage:(NSInteger)page{

    if (self.currentPage == page) return;
    
    self.currentPage = page;
    
    NSMutableArray *pageToLoad = [@[@(page-1),@(page),@(page+1)] mutableCopy];
    
    NSMutableArray *vcsToEnqueue = [NSMutableArray array];
    
    for (XZViewController *vc in self.visbleArray) {
        
        if (!vc.page || ![pageToLoad containsObject:vc.page]) {
            [vcsToEnqueue addObject:vc];
        }else if (vc.page) {
            [pageToLoad removeObject:vc.page];
        }
        
    }
    
    for (XZViewController *vc in vcsToEnqueue) {
        
        [vc.view removeFromSuperview];
        [self.visbleArray removeObject:vc];
        [self.reusableArray addObject:vc];
    }
    
    for (NSNumber *number in pageToLoad) {
        
        [self addViewControllerForPage:number.integerValue];
    }
}

- (void)addViewControllerForPage:(NSInteger)page{
    
    if (page < 0 || page > 6) {
        return;
    }
    
    XZViewController *vc = [self dequeueReusableViewController];
    vc.page = @(page);
    vc.view.frame = CGRectMake(_width*page, 0, _width, _height);
    [self.scrollView addSubview:vc.view];
    [self.visbleArray addObject:vc];
}

- (XZViewController *)dequeueReusableViewController
{
    static NSInteger numberOfInstance = 0;
    XZViewController *vc = [self.reusableArray firstObject];
    if (vc) {
        [self.reusableArray removeObject:vc];
    } else {
        numberOfInstance++;
        NSLog(@"%ld",numberOfInstance);
        vc = [[XZViewController alloc] init];
        vc.number = numberOfInstance;
    }
    return vc;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView) {
        NSInteger page = roundf(scrollView.contentOffset.x / scrollView.frame.size.width);
        page = MAX(page, 0);
        page = MIN(page, 7 - 1);
        [self loadPage:page];
    }
}
@end
