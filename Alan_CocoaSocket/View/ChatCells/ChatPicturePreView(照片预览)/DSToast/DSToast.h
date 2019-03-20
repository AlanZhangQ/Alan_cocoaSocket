//
//  DSToast.h
//  DSToast
//
//  Created by LS on 8/18/15.
//  Copyright (c) 2015 LS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DSToastShowType)
{
    DSToastShowTypeTop,
    DSToastShowTypeCenter,
    DSToastShowTypeBottom
};

@interface DSToast : UILabel

@property (nonatomic, assign) CFTimeInterval forwardAnimationDuration;
@property (nonatomic, assign) CFTimeInterval backwardAnimationDuration;
@property (nonatomic, assign) UIEdgeInsets   textInsets;
@property (nonatomic, assign) CGFloat        maxWidth;

+ (id)toastWithText:(NSString *)text;

- (id)initWithText:(NSString *)text;
- (void)showInView:(UIView *)view;    //Default is DSToastShowTypeBottom
- (void)showInView:(UIView *)view showType:(DSToastShowType)type;

@end
