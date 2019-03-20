//
//  ChatVideoCell.h
//  Alan_CocoaSocket
//
//  Created by Alan on 2018/10/27.
//  Copyright © 2018年 Alan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChatModel;

//长按选择
typedef void(^longpressHandle)(LongpressSelectHandleType handleType,ChatModel *messageModel);

//回调进入视频播放页面
typedef void(^toVideoPlayController)(NSString *playPath);

@interface ChatVideoCell : UITableViewCell

//进入视频播放页面
@property (nonatomic, copy) toVideoPlayController playBlock;

@property (nonatomic, strong) ChatModel *videoModel;

//长按操作类型
@property (nonatomic, copy) longpressHandle longpressBlock;

@end
