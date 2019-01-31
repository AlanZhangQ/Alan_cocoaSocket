//
//  NSDate+extension.h
//  CocoaAsyncSocket_TCP
//
//  Created by ALan on 2018/5/12.
//  Copyright © 2018年 Alan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (extension)

//判断时间戳是否为当天,昨天,一周内,年月日
+ (NSString *)timeStringWithTimeInterval:(NSString *)timeInterval;

@end
