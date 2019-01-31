//
//  ChatHandler.h
//  Alan_CocoaSocket
//
//  Created by Alan on 2018/10/21.
//  Copyright © 2018年 Alan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatModel.h"

@protocol ChatHandlerDelegate <NSObject>

@required

//接收消息代理
- (void)didReceiveMessage:(ChatModel *)chatModel type:(ChatMessageType)messageType;

@optional
//发送消息超时代理
- (void)sendMessageTimeOutWithTag:(long)tag;

@end


@interface ChatHandler : NSObject

//socket连接状态
@property (nonatomic, assign) SocketConnectStatus connectStatus;

//聊天单例
+ (instancetype)shareInstance;
//连接服务器端口
- (void)connectServerHost;
//主动断开连接
- (void)executeDisconnectServer;
//添加代理
- (void)addDelegate:(id<ChatHandlerDelegate>)delegate delegateQueue:(dispatch_queue_t)queue;
//移除代理
- (void)removeDelegate:(id<ChatHandlerDelegate>)delegate;
//发送消息
- (void)sendMessage:(ChatModel *)chatModel timeOut:(NSUInteger)timeOut tag:(long)tag;



//发送文本消息
- (void)sendTextMessage:(ChatModel *)textModel;

//发送语音消息
- (void)sendAudioMessage:(ChatModel *)audioModel;

//发送图片消息
- (void)sendPicMessage:(NSArray<ChatModel *>*)picModels;

//发送视频消息
- (void)sendVideoMessage:(ChatModel *)videoModel;

@end
