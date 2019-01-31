//
//  AccountTool.h
//  CocoaAsyncSocket_TCP
//
//  Created by Alan on 2018/4/20.
//  Copyright © 2018年 Alan. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Account.h"

@interface AccountTool : NSObject

//保存个人信息
+ (void)save:(Account *)account;

//获取个人信息
+ (Account *)account;

@end
