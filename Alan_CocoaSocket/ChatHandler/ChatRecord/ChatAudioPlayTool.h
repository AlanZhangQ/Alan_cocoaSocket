//
//  ChatAudioPlayTool.h
//  CocoaAsyncSocket_TCP
//
//  Created by Alan on 2018/10/27.
//  Copyright © 2018年 Alan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatAudioPlayTool : NSObject

+ (instancetype)audioPlayTool:(NSString *)path;

- (void)play;

@end
