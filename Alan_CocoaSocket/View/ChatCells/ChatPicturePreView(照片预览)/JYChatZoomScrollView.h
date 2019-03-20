//
//  JYChatZoomScrollView.h
//  JYHomeCloud
//
//  Created by Alan on 2017/4/10.
//  Copyright © 2017年 JYall Network Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
//#import "JYChatMessageModel.h"
#import "JYChatPrePhotoModel.h"

typedef void(^handleBarHiddenCallback)(); //操作条隐藏

@interface JYChatZoomScrollView : UIScrollView

@property (nonatomic, strong) JYChatPrePhotoModel *photoModel; //消息模型
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign,getter=isNeedAnimation) BOOL animation;
@property (nonatomic, strong) UIImageView *touchImageView; //点击的imageView
@property (nonatomic, copy) handleBarHiddenCallback handleBarHiddenBlock;

@end
