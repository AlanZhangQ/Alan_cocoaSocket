//
//  ChatAudioCell.h
//  Alan_CocoaSocket
//
//  Created by Alan on 2018/10/27.
//  Copyright © 2018年 Alan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChatModel;

//失败重发
typedef void(^sendAgainCallback)(ChatModel *audioModel);
//播放语音回调
typedef void(^playAudioCallback)(NSString *path);
//消息长按操作回调
typedef void(^longpressCallback)(LongpressSelectHandleType type,ChatModel *audioModel);
//进入用户详情
typedef void(^userInfoCallback)(NSString *userID);

@interface ChatAudioCell : UITableViewCell

@property (nonatomic, strong) ChatModel *audioModel;

- (void)sendAgain:(sendAgainCallback)sendAgain playAudio:(playAudioCallback)playAudio longpress:(longpressCallback)longpress toUserInfo:(userInfoCallback)userDetailCallback;


@end
