//
//  JYChatRollScrollView.h
//  JYHomeCloud
//
//  Created by Alan on 2017/4/10.
//  Copyright © 2017年 JYall Network Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^scrollInfoCallBack)(NSInteger currentPage);

@interface JYChatRollScrollView : UIScrollView
@property (nonatomic, strong) NSMutableArray *zoomViews;

- (instancetype)initWithFrame:(CGRect)frame callBack:(scrollInfoCallBack)callback;
@end
