//
//  ChatTabbar.h
//  CocoaAsyncSocket_TCP
//
//  Created by Alan on 2018/5/15.
//  Copyright © 2018年 Alan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^swtControllerBlock)(NSInteger index);

@interface ChatTabbar : UITabBar

@property (nonatomic, copy) swtControllerBlock swtCallback;

@end
