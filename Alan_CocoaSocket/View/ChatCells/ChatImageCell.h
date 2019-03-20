//
//  ChatImageCell.h
//  Alan_CocoaSocket
//
//  Created by Alan on 2018/10/27.
//  Copyright © 2018年 Alan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChatModel;

//长按选择
typedef void(^longpressHandle)(LongpressSelectHandleType handleType,ChatModel *messageModel);

typedef void(^catBigPicture)(ChatModel *model,UIImageView *touchImageView);

@interface ChatImageCell : UITableViewCell

@property (nonatomic, strong) ChatModel *imageModel;

//大图回调
@property (nonatomic, copy) catBigPicture bigPicBlock;

//长按操作类型
@property (nonatomic, copy) longpressHandle longpressBlock;

@end
