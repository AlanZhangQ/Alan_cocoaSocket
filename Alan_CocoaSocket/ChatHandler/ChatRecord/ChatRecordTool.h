//
//  ChatRecordTool.h
//  CocoaAsyncSocket_TCP
//
//  Created by Alan on 2018/10/27.
//  Copyright © 2018年 Alan. All rights reserved.
//

#import <Foundation/Foundation.h>

//语音录制信息回调
typedef void(^audioInfoCallback)(NSData *audioData,NSInteger seconds);

@interface ChatRecordTool : NSObject

//初始化录音蒙板
+ (instancetype)chatRecordTool;
//开始录音
- (void)beginRecord;
//取消录音
- (void)cancelRecord;
//录音结束
- (void)stopRecord:(audioInfoCallback)infoCallback;
//手指移开录音按钮
- (void)moveOut;
//继续录制
- (void)continueRecord;

@end
