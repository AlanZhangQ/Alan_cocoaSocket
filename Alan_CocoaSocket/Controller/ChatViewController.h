//
//  ChatViewController.h
//  Alan_CocoaSocket
//
//  Created by Alan on 2018/10/21.
//  Copyright © 2018年 Alan. All rights reserved.
//

#import "BaseViewController.h"
@class  ChatModel;

@interface ChatViewController : BaseViewController
//必传
@property (nonatomic, strong) ChatModel *config;

@end
