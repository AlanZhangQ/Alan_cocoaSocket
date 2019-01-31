//
//  AccountTool.m
//  CocoaAsyncSocket_TCP
//
//  Created by Alan on 2018/4/20.
//  Copyright © 2018年 Alan. All rights reserved.
//

#import "AccountTool.h"

@implementation AccountTool

+ (void)save:(Account *)account
{
    NSString *cachePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.arch"];
    [NSKeyedArchiver archiveRootObject:account toFile:cachePath];
}

+ (Account *)account
{
    NSString *cachePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.arch"];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:cachePath];
}

@end
