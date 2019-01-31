//
//  ChatModel.m
//  CocoaAsyncSocket_TCP
//
//  Created by Alan on 2018/10/27.
//  Copyright © 2018年 Alan. All rights reserved.
//
#import "ChatModel.h"
    
@implementation ChatModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
}

- (instancetype)init
{
    if (self = [super init]) {
        self.sendTime = getSendTime();
    }
    return self;
}

NS_INLINE NSString *getSendTime() {
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    return [NSString stringWithFormat:@"%llu",recordTime];
}

@end


@implementation ChatContentModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
}




@end
