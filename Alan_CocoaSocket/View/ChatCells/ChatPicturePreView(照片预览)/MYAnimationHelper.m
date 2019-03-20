//
//  MYAnimationHelper.m
//  MYPhotoBrowser_Example
//
//  Created by Alan on 2017/2/19.
//  Copyright © 2017年 Alan. All rights reserved.
//

#import "MYAnimationHelper.h"
#import <objc/runtime.h>

static char finishedCallback;
static char animationShowView;

@interface MYAnimationHelper ()<CAAnimationDelegate>

@end

@implementation MYAnimationHelper

+ (instancetype)shareInstance
{
    static MYAnimationHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[MYAnimationHelper alloc]init];
    });
    return helper;
}

- (void)coreAnimationWithAnimationView:(UIView *)animationView relativeView:(UIImageView *)imageView style:(MY_animationStyle)style finished:(animationStopCallback)finished
{
    objc_setAssociatedObject(self, &finishedCallback, finished, OBJC_ASSOCIATION_COPY);
    objc_setAssociatedObject(self, &animationShowView, animationView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    CABasicAnimation *baseAnimation = [CABasicAnimation animation];
    baseAnimation.keyPath   = @"transform.scale";
    
    CGFloat sccale = imageView.bounds.size.width/animationView.bounds.size.width;
    if (style == MYShowAnimation) {
        baseAnimation.fromValue = @(sccale);
        baseAnimation.toValue   = @1;
        baseAnimation.duration  = 0.25;
    }else{
        baseAnimation.fromValue = @1;
        baseAnimation.toValue   = @(sccale);
        baseAnimation.duration  = 0.15;
    }

    //关键帧动画
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animation];
    keyAnimation.keyPath              = @"position";
    
    CGRect relativeFrame              = [self relativeFrameForScreenWithView:imageView];
    NSValue *value = [NSValue valueWithCGPoint:CGPointMake(relativeFrame.origin.x + relativeFrame.size.width *0.5, relativeFrame.origin.y + relativeFrame.size.height *0.5)];
    NSValue *value1 = [NSValue valueWithCGPoint:CGPointMake([UIScreen mainScreen].bounds.size.width *0.5, [UIScreen mainScreen].bounds.size.height *0.5)];
    
    if (style ==MYShowAnimation) {
        keyAnimation.duration         = 0.25;
        keyAnimation.values           = @[value,value1];
    }else{
        keyAnimation.duration         = 0.15;
        keyAnimation.values           = @[value1,value];
    }
    
    //组
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.delegate          = self;
    group.animations        = @[keyAnimation,baseAnimation];
    [animationView.layer addAnimation:group forKey:@"MYAnimation"];
}

//计算相对frame
- (CGRect)relativeFrameForScreenWithView:(UIView *)v
{
    if (!v) {
        return CGRectMake(([UIScreen mainScreen].bounds.size.width - 150)*0.5, ([UIScreen mainScreen].bounds.size.height - 150)*0.5, 150, 150);
    }
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    return [v convertRect: v.bounds toView:window];
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{

    animationStopCallback callback = objc_getAssociatedObject(self, &finishedCallback);
    UIView *animationView          = objc_getAssociatedObject(self, &animationShowView);
    [animationView.layer removeAnimationForKey:@"MYAnimation"];
    if (callback) {
        callback();
    }
}

@end
