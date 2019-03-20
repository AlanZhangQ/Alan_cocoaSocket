//
//  JYChatPrePhotoModel.h
//  JYHomeCloud
//
//  Created by Alan on 2017/4/13.
//  Copyright © 2017年 JYall Network Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYChatPrePhotoModel : NSObject

@property (nonatomic, copy) NSString *fileName;

@property (nonatomic, copy) NSString *urlString;

@property (nonatomic, copy) NSString *fileID;

@property (nonatomic, copy) NSString *chatType;

@property (nonatomic, copy) NSString *fromUser;

@property (nonatomic, copy) NSString *toUser;

@property (nonatomic, copy) NSString *toFamily;

@property (nonatomic, copy) NSString *fileSize;

@property (nonatomic, assign) BOOL isHaveTouch; //已经查看过了

@end
