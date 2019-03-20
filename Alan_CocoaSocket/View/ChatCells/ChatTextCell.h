//
//  ChatTextCell.h
//  Alan_CocoaSocket
//
//  Created by Alan on 2018/10/27.
//  Copyright © 2018年 Alan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChatModel;
//长按选择
typedef void(^longpressHandle)(LongpressSelectHandleType handleType,ChatModel *messageModel);

@protocol BaseCellDelegate <NSObject>

- (void)longPress:(UILongPressGestureRecognizer *)longRecognizer;

@end

@interface ChatTextCell : UITableViewCell

@property (nonatomic, strong) ChatModel *textModel;

@property (nonatomic, weak) id<BaseCellDelegate> longPressDelegate;

//长按操作类型
@property (nonatomic, copy) longpressHandle longpressBlock;

@end
