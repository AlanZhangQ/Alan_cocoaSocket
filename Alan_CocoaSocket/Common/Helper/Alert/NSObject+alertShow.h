//
//  NSObject+alertShow.h
//  JYHomeCloud
//
//  Created by mengyaoyao on 16/11/6.
//  Copyright © 2016年 JYall Network Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

//确认
typedef void(^sureCallBack)();

//确认 , 文件名回调
typedef void(^makeSureDelete)(NSString *fileName);

//重命名
typedef void(^renameBlock)();

//移动文件
typedef void(^moveFileBlock)();
//更改封面
typedef void(^changeBackImageBlock)();

@interface NSObject (alertShow)



/**
  正常确认 , 取消

 @param tipTitle <#tipTitle description#>
 @param message  <#message description#>
 @param target   <#target description#>
 @param tipStyle <#tipStyle description#>
 @param callback <#callback description#>
 */
+ (void)alertShowWithSureAndCancelWithTitle:(NSString *)tipTitle message:(NSString *)message target:(UIViewController *)target alertStyle:(UIAlertControllerStyle)tipStyle sureBack:(sureCallBack)callback;


//退出 ,取消
+ (void)alertShowWithQuitAndCancelWithTitle:(NSString *)tipTitle message:(NSString *)message target:(UIViewController *)target alertStyle:(UIAlertControllerStyle)tipStyle sureBack:(sureCallBack)callback;

/**
 正常继续 , 取消
 
 @param tipTitle <#tipTitle description#>
 @param message  <#message description#>
 @param target   <#target description#>
 @param tipStyle <#tipStyle description#>
 @param callback <#callback description#>
 */
+ (void)alertShowWithContinueAndCancelWithTitle:(NSString *)tipTitle message:(NSString *)message target:(UIViewController *)target alertStyle:(UIAlertControllerStyle)tipStyle sureBack:(sureCallBack)callback;
/**
 
  重命名,移动

 @param rename       <#rename description#>
 @param moveCallback <#moveCallback description#>
 @param target       <#target description#>
 */
+ (void)alertShowAboutFileOperationRename:(renameBlock)rename move:(moveFileBlock)moveCallback target:(UIViewController *)target;


/**
  单个提示 ,只有确定

 @param target   <#target description#>
 @param callback <#callback description#>
 */
+ (void)alertShowWithSingleTipWithTarget:(UIViewController *)target title:(NSString *)titleName makeSureClick:(sureCallBack)callback;


/**
   确认删除

 @param callBack <#callBack description#>
 */
+ (void)alertShowWithMakeSureDeleteWithTarget:(UIViewController *)target callBack:(makeSureDelete)callBack;


/**
 引导用户打开相册权限

 @param target   <#target description#>
 @param callback <#callBack description#>
 */
+ (void)alertShowForAuthorizationWithTarget:(UIViewController *)target callBack:(sureCallBack)callback;


/**
  更改朋友圈封面

 */
+ (void)alertShowForBottomTipsWithTarget:(UIViewController *)target callBack:(changeBackImageBlock)callBack;


/**
 清空列表
 
 */
+ (void)alertShowClearListWithTarget:(UIViewController *)target callBack:(changeBackImageBlock)callBack;

/**
 是，否
 */
+ (void)alertShowWithYesOrNoWithTitle:(NSString *)tipTitle message:(NSString *)message target:(UIViewController *)target alertStyle:(UIAlertControllerStyle)tipStyle sureBack:(sureCallBack)callback;

@end
