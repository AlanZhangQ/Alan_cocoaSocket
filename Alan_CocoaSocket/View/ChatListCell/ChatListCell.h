//
//  ChatListCell.h
//  Alan_CocoaSocket
//
//  Created by Alan on 2018/10/21.
//  Copyright © 2018年 Alan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChatModel;

@interface ChatListCell : UITableViewCell

@property (nonatomic, strong) ChatModel *chatModel; //消息模型

@end
