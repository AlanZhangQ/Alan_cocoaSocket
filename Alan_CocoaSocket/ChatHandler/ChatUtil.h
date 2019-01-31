//
//  ChatUtil.h
//  CocoaAsyncSocket_TCP
//
//  Created by Alan on 2018/10/27.
//  Copyright © 2018年 Alan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ChatModel,ChatAlbumModel;

typedef void(^videoModelCallback)(ChatModel *videoModel);
@interface ChatUtil : NSObject

//消息高度计算
+ (CGFloat)heightForMessage:(ChatModel *)currentChatmodel premodel:(ChatModel *)premodel;
//初始化文本消息模型
+ (ChatModel *)initTextMessage:(NSString *)text config:(ChatModel *)config;
//初始化语音消息模型
+ (ChatModel *)initAudioMessage:(ChatAlbumModel *)audio config:(ChatModel *)config;
//初始化图片消息模型
+ (NSArray<ChatModel *> *)initPicMessage:(NSArray<ChatAlbumModel *> *)pics config:(ChatModel *)config;
//初始化视频消息模型
+ (void)initVideoMessage:(ChatAlbumModel *)video config:(ChatModel *)config videoCallback:(videoModelCallback)callback;
//b - kb -M 大小转换
+ (NSString *)dataSize:(ChatModel *)chatModel;
//时间戳转换时间格式
+ (NSString *)videoDurationWithSeconds:(long long int)duration;

@end
