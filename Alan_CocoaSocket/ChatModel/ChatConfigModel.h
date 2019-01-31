//
//  ChatConfigModel.h
//  CocoaAsyncSocket_TCP
//
//  Created by Alan on 2018/10/27.
//  Copyright © 2018年 Alan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatConfigModel : NSObject

@property (nonatomic, copy) NSString *toUserID;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *groupID;
@property (nonatomic, copy) NSString *groupName;
@property (nonatomic, copy) NSString *chatType;

@end
