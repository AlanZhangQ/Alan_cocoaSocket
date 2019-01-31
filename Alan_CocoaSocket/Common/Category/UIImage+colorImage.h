//
//  UIImage+colorImage.h
//  CocoaAsyncSocket_TCP
//
//  Created by Alan on 2018/5/12.
//  Copyright © 2018年 Alan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (colorImage)

+ (UIImage *)imageFromContextWithColor:(UIColor *)color; //一像素图片

+ (UIImage *)imageFromContextWithColor:(UIColor *)color size:(CGSize)size;

@end
