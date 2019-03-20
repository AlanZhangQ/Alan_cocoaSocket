//
//  Tool.h
//  JYallHaoFangTong
//
//  Created by newuser on 15/12/2.
//  Copyright © 2015年 陈石. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

typedef void (^callBack)();
@interface Tool : NSObject
+(instancetype)instance;

//好友备注FMDB
-(void)saveFamilyFMDB:(callBack)call;
-(void)saveFriendNameFMDB:(callBack)call;
-(void)getFriendsListWithContactArr:(NSMutableArray *)contactArr;
/***************************** System Utils *****************************/
//弹出UIAlertView
+ (void)showAlertMessage:(NSString *)msg;
//关闭键盘
//+ (void)closeKeyboard;

//2秒后消失自动的黑色提示框
+ (void)showMBProgressWithTextOnly:(NSString *)text;
+ (void)showMBProgressWithTextOnly:(NSString *)text afterSecond:(NSTimeInterval)second;

//显示转圈
+(void)showLoadingOnWindow;
+(void)showEmptyLoadingOnWindow;

//隐藏
+(void)hideLodingOnWindow;

+(void)showWarning:(UIView *)view text:(NSString *)text callback:(void(^)(void))hudCallBack;

+(void)showWarningOnWindowText:(NSString *)text callback:(void(^)(void))hudCallBack;

@end


@interface NSString(stringValue)

-(NSString *)stringValue;

@end
