//
//  JYChatRollScrollView.m
//  JYHomeCloud
//
//  Created by Alan on 2017/4/10.
//  Copyright © 2017年 JYall Network Technology Co.,Ltd. All rights reserved.
//

#import "JYChatRollScrollView.h"
#import "JYChatZoomScrollView.h"

@interface JYChatRollScrollView ()<UIScrollViewDelegate>

@property (nonatomic, copy) scrollInfoCallBack callback;

@end

@implementation JYChatRollScrollView


- (NSMutableArray *)zoomViews
{
    if (!_zoomViews) {
        _zoomViews = [NSMutableArray array];
    }
    return _zoomViews;
}

- (instancetype)initWithFrame:(CGRect)frame callBack:(scrollInfoCallBack)callback
{
    if (self =[super initWithFrame:frame]) {
        
        self.pagingEnabled                  = YES;
        self.delegate                       = self;
        self.showsVerticalScrollIndicator   = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.callback                       = callback;
        self.backgroundColor                = [UIColor clearColor];
    }
    return self;
}


//回调页码
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger currentPage = (scrollView.contentOffset.x + 0.5 *SCREEN_WITDTH) / SCREEN_WITDTH;
    if (self.callback) {
        self.callback(currentPage);
    }
}


@end
