//
//  UIImageView+GIF.h
//  CocoaAsyncSocket_TCP
//
//  Created by Alan on 2018/5/18.
//  Copyright © 2018年 Alan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (GIF)
//播放GIF
- (void)GIF_PrePlayWithImageNamesArray:(NSArray *)array duration:(NSInteger)duration;
//停止播放
- (void)GIF_Stop;

@end
