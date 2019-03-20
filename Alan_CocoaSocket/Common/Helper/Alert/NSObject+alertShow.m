//
//  NSObject+alertShow.m
//  JYHomeCloud
//
//  Created by mengyaoyao on 16/11/6.
//  Copyright © 2016年 JYall Network Technology Co.,Ltd. All rights reserved.
//

#import "NSObject+alertShow.h"
#import "Tool.h"

@implementation NSObject (alertShow)




//确认, 取消
+ (void)alertShowWithSureAndCancelWithTitle:(NSString *)tipTitle message:(NSString *)message target:(UIViewController *)target alertStyle:(UIAlertControllerStyle)tipStyle sureBack:(sureCallBack)callback
{
    
    if ((target ==nil) || (![target isKindOfClass:[UIViewController class]])) {
        
        target = [UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:tipTitle message:message preferredStyle:tipStyle];
    
    UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (callback) {
            callback();
        }
        
    }];
    
    [alert addAction:actionOne];
    [alert addAction:actionTwo];
    
    [target presentViewController:alert animated:YES completion:nil];
    
}

//退出, 取消
+ (void)alertShowWithQuitAndCancelWithTitle:(NSString *)tipTitle message:(NSString *)message target:(UIViewController *)target alertStyle:(UIAlertControllerStyle)tipStyle sureBack:(sureCallBack)callback
{
    
    if ((target ==nil) || (![target isKindOfClass:[UIViewController class]])) {
        
        target = [UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:tipTitle message:message preferredStyle:tipStyle];
    
    UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (callback) {
            callback();
        }
        
    }];
    
    [alert addAction:actionOne];
    [alert addAction:actionTwo];
    
    [target presentViewController:alert animated:YES completion:nil];
    
}

//继续, 取消
+ (void)alertShowWithContinueAndCancelWithTitle:(NSString *)tipTitle message:(NSString *)message target:(UIViewController *)target alertStyle:(UIAlertControllerStyle)tipStyle sureBack:(sureCallBack)callback
{
    
    if ((target ==nil) || (![target isKindOfClass:[UIViewController class]])) {
        
        target = [UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:tipTitle message:message preferredStyle:tipStyle];
    
//    UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [Tool hideLodingOnWindow];
    }];
    
    UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (callback) {
            callback();
        }
        
    }];
    
    [alert addAction:actionOne];
    [alert addAction:actionTwo];
    
    [target presentViewController:alert animated:YES completion:nil];
    
}


//重命名,移动
+ (void)alertShowAboutFileOperationRename:(renameBlock)rename move:(moveFileBlock)moveCallback target:(UIViewController *)target
{
    
    if ((target ==nil) || (![target isKindOfClass:[UIViewController class]])) {
        
        target = [UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController;
    }
    
    UIAlertController *alert   = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *actionOne   = [UIAlertAction actionWithTitle:@"重命名" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (rename) {
            rename();
        }
    }];
    
    UIAlertAction *actionTwo   = [UIAlertAction actionWithTitle:@"移动" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        moveCallback();
    }];
    
    UIAlertAction *actionThree = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:actionOne];
    [alert addAction:actionTwo];
    [alert addAction:actionThree];
    
    [target presentViewController:alert animated:YES completion:nil];

}


//单个提示 , 只有确定
+ (void)alertShowWithSingleTipWithTarget:(UIViewController *)target title:(NSString *)titleName makeSureClick:(sureCallBack)callback
{
    
    if ((target ==nil) || (![target isKindOfClass:[UIViewController class]])) {
    
    target = [UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController;
        
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:titleName message:nil preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *action    = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (callback) {
           callback(); 
        }
        
    }];

    [alert addAction:action];
    
    [target presentViewController:alert animated:YES completion:nil];
}


// 确认删除
+ (void)alertShowWithMakeSureDeleteWithTarget:(UIViewController *)target callBack:(makeSureDelete)callBack
{
    
    if ((target ==nil) || (![target isKindOfClass:[UIViewController class]])) {
        
        target = [UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController;
        
    }

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"可在更多>回收站内找回删除的文件" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
    
    UIAlertAction *actionOne    = [UIAlertAction actionWithTitle:@"确认删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *rename        = alert.textFields[0].text;
        
        if (callBack) {
           callBack(rename);
        }
        
    }];

    UIAlertAction *actionTwo    = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:actionOne];
    [alert addAction:actionTwo];
    [target presentViewController:alert animated:YES completion:nil];
}

//引导用户前往授权
+ (void)alertShowForAuthorizationWithTarget:(UIViewController *)target callBack:(sureCallBack)callback
{
    
    if ((target ==nil) || (![target isKindOfClass:[UIViewController class]])) {
        
        target = [UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"去设置中授予权限" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (callback) {
            callback();
        }
    }];
    
    [alert addAction:actionOne];
    [alert addAction:actionTwo];
    
    [target presentViewController:alert animated:YES completion:nil];

}



//朋友圈
+ (void)alertShowForBottomTipsWithTarget:(UIViewController *)target callBack:(changeBackImageBlock)callBack
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *actionOne    = [UIAlertAction actionWithTitle:@"更改封面" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (callBack) {
            callBack();
        }
    }];
    
    UIAlertAction *actionTwo    = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
     }];
    
    [alert addAction:actionOne];
    [alert addAction:actionTwo];
    
    [target presentViewController:alert animated:YES completion:nil];
}

//上传下载清空记录
+ (void)alertShowClearListWithTarget:(UIViewController *)target callBack:(changeBackImageBlock)callBack
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"清空数据将不可恢复" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *actionOne    = [UIAlertAction actionWithTitle:@"清空记录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (callBack) {
            callBack();
        }
    }];
    
    UIAlertAction *actionTwo    = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alert addAction:actionOne];
    [alert addAction:actionTwo];
    
    [target presentViewController:alert animated:YES completion:nil];
}


//是 , 否
+ (void)alertShowWithYesOrNoWithTitle:(NSString *)tipTitle message:(NSString *)message target:(UIViewController *)target alertStyle:(UIAlertControllerStyle)tipStyle sureBack:(sureCallBack)callback
{
    
    if ((target ==nil) || (![target isKindOfClass:[UIViewController class]])) {
        
        target = [UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:tipTitle message:message preferredStyle:tipStyle];
    
    UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (callback) {
            callback();
        }
        
    }];
    
    [alert addAction:actionOne];
    [alert addAction:actionTwo];
    
    [target presentViewController:alert animated:YES completion:nil];
    
}

@end
