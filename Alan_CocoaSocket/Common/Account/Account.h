//
//  Account.h
//  CocoaAsyncSocket_TCP
//
//  Created by Alan on 2018/4/20.
//  Copyright © 2018年 Alan. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface Account : NSObject<NSCoding>

@property (nonatomic ,copy) NSString *myUserID; //当前用户ID

@property (nonatomic ,strong) NSNumber *sex; //性别

@property (nonatomic ,strong) NSNumber *age; //年龄

@property (nonatomic ,copy) NSString *birthDay; //生日

@property (nonatomic ,strong,getter=isVip) NSNumber *vip; //是否会员

@property (nonatomic ,strong,getter=isOnline) NSNumber *online;//是否在线

@property (nonatomic ,copy) NSString *lastLoginTime; //最后登录时间

@property (nonatomic, copy) NSString *nickName; //我的昵称

@property (nonatomic, copy) NSString *portrait;  //头像url

/*
 这里仅仅是一个模拟 , 真正的关于当前用户的资料可能还会有很多
 */

+ (instancetype)account;

@end
