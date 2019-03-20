//
//  Tool.m
//  JYallHaoFangTong
//
//  Created by newuser on 15/12/2.
//  Copyright © 2015年 陈石. All rights reserved.
//

#import "Tool.h"
//#import "JYChatHandler.h"
//#import "JYFamilyGroupModel.h"
//#import "PPGetAddressBook.h"
#import "UIViewExt.h"
#import "Config.h"
@interface Tool ()

@property (strong,nonatomic)UIActivityIndicatorView *indicatorView;

@end
@implementation Tool

+(instancetype)instance{
    static Tool *tl = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tl = [[Tool alloc]init];
        
    });
    return tl;
}
-(UIActivityIndicatorView *)indicatorView{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.frame = [UIApplication sharedApplication].keyWindow.bounds;
        _indicatorView.top += 64;
        
        UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(50, -64, SCREEN_WITDTH, 64)];
        coverView.userInteractionEnabled = NO;
        //        coverView.backgroundColor = UICOLOR_RGB_Alpha(0x234234, 0.5);
        [_indicatorView addSubview:coverView];
        
    }
    return _indicatorView;
}

////从服务器拉取信息
//-(void)saveFamilyFMDB:(callBack)call{
//    [JYHomeCloudApiManager getAllFamilyWithUser:[JYAccountTool account].userName Finished:^(BOOL success, id response, NSString *message) {
//        NSLog(@"---------服务器拉取信息----------%@",response);
//
//        if (success) {
//            if ([[response allKeys] containsObject:@"create"]) {
//                if ([[response objectForKey:@"create"] count]>0) {
//
//                    for (NSDictionary *dic in [response objectForKey:@"create"]) {
//                        JYFamilyGroupDetailsModel *model = [JYFamilyGroupDetailsModel mj_objectWithKeyValues:dic];
//                        [self updataFMDBWithModel:model];
//                    }
//                }
//            }
//            if ([[response allKeys] containsObject:@"join"]) {
//                if ([[response objectForKey:@"join"] count]>0) {
//
//                    for (NSDictionary *dic in [response objectForKey:@"join"]) {
//                        JYFamilyGroupDetailsModel *model = [JYFamilyGroupDetailsModel mj_objectWithKeyValues:dic];
//                        [self updataFMDBWithModel:model];
//                    }
//                }
//            }
//            if (call) {
//                call();
//            }
//        }else{
//        }
//    }];
//}
//
//-(void)updataFMDBWithModel:(JYFamilyGroupDetailsModel *)detailsModel{
//    JYFamilyGroupModel *model = [[JYFamilyGroupModel alloc]init];
//    model.userName = detailsModel.familyId;
//    model.remarkName = detailsModel.familyName;
//    [[JYChatHandler sharedInstance].fmdbHandler isHaveFriendDataWithModel:model];
//}
//
//-(void)saveFriendNameFMDB:(callBack)call{
//    [JYHomeCloudApiManager getFriendsListWithUserName:[JYAccountTool account].userName familyId:@"" Finished:^(BOOL success, id response, NSString *message) {
//        if (success) {
//            [response enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                JYFamilyGroupModel *model = [JYFamilyGroupModel mj_objectWithKeyValues:obj];
//                [[JYChatHandler sharedInstance].fmdbHandler isHaveFriendDataWithModel:model];
//            }];
//            JYFamilyGroupModel *tmpModel = [[JYFamilyGroupModel alloc]init];
//            tmpModel.userName = [JYAccountTool account].userName;
//            tmpModel.remarkName = [JYAccountTool account].nickName;
//            tmpModel.portrait = [JYAccountTool account].portrait;
//            [[JYChatHandler sharedInstance].fmdbHandler isHaveFriendDataWithModel:tmpModel];
//
//        }else{
//        }
//    }];
//
//    //获取没有经过排序的联系人模型
//    [PPGetAddressBook getOriginalAddressBook:^(NSArray<PPPersonModel *> *addressBookArray) {
//        NSMutableArray *personArr = [NSMutableArray array];
//        for (PPPersonModel *model in addressBookArray) {
//            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//            [dic setValue:model.name forKey:@"name"];
//            [dic setValue:model.mobileArray forKey:@"mobile"];
//            [personArr addObject:dic];
//        }
//        [JYHomeCloudApiManager getFriendsListWithUserName:[JYAccountTool account].userName contactArr:personArr familyId:@"" Finished:^(BOOL success, NSDictionary *response, NSString *message) {
//            if (success) {
//                if ([[response objectForKey:response.keyEnumerator.nextObject] isKindOfClass:[NSArray class]]) {
//                    [[response objectForKey:response.keyEnumerator.nextObject] enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                        JYFamilyGroupModel *model = [JYFamilyGroupModel mj_objectWithKeyValues:obj];
//                        [[JYChatHandler sharedInstance].fmdbHandler isHaveFriendDataWithModel:model];
//                    }];
//                }
//                if (call) {
//                    call();
//                }
//            }else{
//            }
//        }];
//    } authorizationFailure:^{
//    }];
//}
#pragma mark - System Utils
+ (void)showAlertMessage:(NSString *)msg
{
    if(![msg isEqualToString:@""] && msg ){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"iknow", nil) otherButtonTitles:nil, nil];
        [alertView show];
    }
}

+ (void)showMBProgressWithTextOnly:(NSString *)text
{
    [Tool showWarning:[UIApplication sharedApplication].keyWindow mText:text seconds:2.0];
}

+ (void)showMBProgressWithTextOnly:(NSString *)text afterSecond:(NSTimeInterval)second
{
    [Tool showWarning:[UIApplication sharedApplication].keyWindow mText:text seconds:second];
}

+(void)showLoadingOnWindow{
    
    [[UIApplication sharedApplication].keyWindow addSubview:[Tool instance].indicatorView];
    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    UINavigationController *naVC = nil;
    UITabBarController *tabVC = nil;
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        naVC = (UINavigationController *)rootViewController;
    }else{
        tabVC = (UITabBarController *)rootViewController;
        naVC = tabVC.selectedViewController;
    }
    if (naVC.viewControllers.count == 1) {
        [Tool instance].indicatorView.height = SCREEN_HEIGHT -64 - 49;
    }
    
    [[Tool instance].indicatorView startAnimating];
}


+(void)showEmptyLoadingOnWindow{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.color = [UIColor clearColor];
}  

+(void)hideLodingOnWindow{
    [[Tool instance].indicatorView stopAnimating];
    [[Tool instance].indicatorView removeFromSuperview];
}

+(void)showWarning:(UIView *)view mText:(NSString *)text seconds:(CGFloat)seconds{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc]init];
    [pStyle setLineSpacing:0.5];
    [pStyle setLineBreakMode:NSLineBreakByWordWrapping];
    CGRect matchRect = [text boundingRectWithSize:CGSizeMake(190, 150) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName,pStyle,NSParagraphStyleAttributeName, nil] context:nil];
    
    hud.mode = MBProgressHUDModeCustomView;
    UILabel *mLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, matchRect.size.width, matchRect.size.height)];
    mLabel.backgroundColor = [UIColor clearColor];
    mLabel.textColor = [UIColor whiteColor];
    mLabel.font = [UIFont systemFontOfSize:16];
    mLabel.textAlignment = NSTextAlignmentCenter;
    mLabel.lineBreakMode = NSLineBreakByWordWrapping;
    mLabel.numberOfLines = 0;
    mLabel.text = text;
    hud.customView = mLabel;
    
    if ([text containsString:@"密码显示"]) {
//        hud.yOffset -= ScreenHeight/5;
    }
    
    [hud hide:YES afterDelay:seconds];
    
}


+(void)showWarning:(UIView *)view text:(NSString *)text callback:(void(^)(void))hudCallBack{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.completionBlock = [hudCallBack copy];
    [hud hide:YES afterDelay:2];
}

+(void)showWarningOnWindowText:(NSString *)text callback:(void(^)(void))hudCallBack{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.completionBlock = [hudCallBack copy];
    [hud hide:YES afterDelay:2];
}

@end

@implementation NSString(stringValue)

-(NSString *)stringValue{
    return self;
}

@end
