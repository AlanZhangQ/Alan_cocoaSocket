//
//  UIButton+topImageButton.m
//  JYHomeCloud
//
//  Created by Alan on 16/12/6.
//  Copyright © 2016年 JYall Network Technology Co.,Ltd. All rights reserved.
//

#import "UIButton+topImageButton.h"

@interface JYCloudButton : UIButton

@end

@implementation JYCloudButton

- (void)layoutSubviews
{
    [super layoutSubviews];
//    CGFloat midX = self.frame.size.width / 2;
//    CGFloat midY = self.frame.size.height/ 2 ;
//    self.titleLabel.center = CGPointMake(midX, midY + 15);
//    self.imageView.center = CGPointMake(midX, midY - 10);
    self.imageView.frame = CGRectMake(0,11,self.bounds.size.width, 24);
    
    self.titleLabel.frame = CGRectMake(0,CGRectGetMaxY(self.imageView.frame)+5.f, self.bounds.size.width,10.f);
}

@end

@implementation UIButton (topImageButton)


+ (UIButton *)topImageButtonFactoryTarget:(id)target action:(SEL)action normalImage:(NSString *)n_ImageName selectedImage:(NSString *)s_ImageName title:(NSString *)title titleColor:(UIColor *)color fontSize:(CGFloat)fontSize
{
    JYCloudButton *button = [JYCloudButton buttonWithType:UIButtonTypeCustom];
    
    [button setImage:[UIImage imageNamed:n_ImageName] forState:UIControlStateNormal];
    
    if (s_ImageName.length) {
        [button setImage:[UIImage imageNamed:s_ImageName] forState:UIControlStateSelected];
    }
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    button.imageView.contentMode = UIViewContentModeCenter;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    return button;
}

@end
