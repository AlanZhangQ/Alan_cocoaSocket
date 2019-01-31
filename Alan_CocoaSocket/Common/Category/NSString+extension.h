//
//  NSString+extension.h
//  CocoaAsyncSocket_TCP
//
//  Created by ALan on 2018/5/14.
//  Copyright © 2018年 Alan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (extension)

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;


+ (CGSize)stringSizeWithContainer:(UIView *)container maxSize:(CGSize)maxSize;

@end
