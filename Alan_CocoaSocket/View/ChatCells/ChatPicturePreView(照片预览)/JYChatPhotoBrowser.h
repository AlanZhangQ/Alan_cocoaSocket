//
//  JYChatPhotoBrowser.h
//  JYHomeCloud
//
//  Created by Alan on 2017/4/10.
//  Copyright © 2017年 JYall Network Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYChatZoomScrollView.h"

@class  JYChatMessageModel;

@interface JYChatPhotoBrowser : UIView

/*
 初始化
 
 @param urlString  url字符串
 @param imageName  占位图名
 @return <#return value description#>
 */
- (instancetype)initWithUrls:(NSArray<JYChatMessageModel *> *)messageModels imgView:(UIImageView *)touchImageView currentIndex:(NSInteger)index;


/**
 是否需要动画
 
 @param animation <#animation description#>
 */
- (void)showWithAnimation:(BOOL)animation;

@end
