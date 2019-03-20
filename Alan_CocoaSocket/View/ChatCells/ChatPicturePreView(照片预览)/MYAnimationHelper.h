//
//  MYAnimationHelper.h
//  MYPhotoBrowser_Example
//
//  Created by Alan on 2017/2/19.
//  Copyright © 2017年 Alan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger)
{
    MYRemoveAnimation   = 0<<0,
    MYShowAnimation     = 1<<0
}MY_animationStyle;

typedef void(^animationStopCallback)();

@interface MYAnimationHelper : NSObject

- (void)coreAnimationWithAnimationView:(UIView *)animationView relativeView:(UIImageView *)imageView style:(MY_animationStyle)style finished:(animationStopCallback)finished;

+ (instancetype)shareInstance;

@end
