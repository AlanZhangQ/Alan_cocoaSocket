//
//  UIButton+topImageButton.h
//  JYHomeCloud
//
//  Created by Alan on 16/12/6.
//  Copyright © 2016年 JYall Network Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (topImageButton)

+ (UIButton *)topImageButtonFactoryTarget:(id)target action:(SEL)action normalImage:(NSString *)n_ImageName selectedImage:(NSString *)s_ImageName title:(NSString *)title titleColor:(UIColor *)color fontSize:(CGFloat)fontSize;

@end
