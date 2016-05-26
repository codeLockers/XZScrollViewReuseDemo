//
//  XZViewController.m
//  XZScrollViewReuseDemo
//
//  Created by 徐章 on 16/5/25.
//  Copyright © 2016年 徐章. All rights reserved.
//

#import "XZViewController.h"

@interface XZViewController ()
@property (nonatomic, strong) UILabel *label;
@end

@implementation XZViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UILabel *)label{

    if (!_label) {
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
        
        _label.backgroundColor = [UIColor redColor];

        [self.view addSubview:_label];
        
    }
    return _label;
}

- (void)setPage:(NSNumber *)page{

    self.label.text = [NSString stringWithFormat:@"%@ %ld",page,self.number];
}
@end
