//
//  CommonDefine.h
//  JinSeJiaYuanWang
//
//  Created by newuser on 16/3/10.
//  Copyright © 2016年 JYall Network Technology Co.,Ltd. All rights reserved.
//

#ifndef CommonDefine_h
#define CommonDefine_h

//#define NSLog(format, ...) do {                                             \
//fprintf(stderr, "<%s : %d> %s\n",                                           \
//[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
//__LINE__, __func__);                                                        \
//(NSLog)((format), ##__VA_ARGS__);                                           \
//fprintf(stderr, "-------\n");                                               \
//} while (0)

//NSLog
#define NSLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

#define JYweakify(object) @weakify(object)
#define JYstrongify(object) @strongify(object)

//屏幕宽高
#define JYScreen_Height [UIScreen mainScreen].bounds.size.height
#define JYScreen_Width [UIScreen mainScreen].bounds.size.width
#define JYScreen_bounds [UIScreen mainScreen].bounds

//字符串是否为空
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )

//keyWindow
#define JYKeyWindow [UIApplication sharedApplication].keyWindow

//弹出的提示
#define ShowToast(titlemessage)\
if(titlemessage.length>0){\
DSToast *toast = [[DSToast alloc] initWithText:(titlemessage)];\
toast.maxWidth = 284.0;\
toast.textInsets = UIEdgeInsetsMake(16, 15, 16, 15);\
[toast showInView:[UIApplication sharedApplication].keyWindow showType:DSToastShowTypeCenter];}


#define ShowMB(tipText)\
if(tipText.length){\
    MBProgressHUD *mb = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];\
    mb.label.text = (tipText);\
    mb.contentColor = [UIColor whiteColor];\
    mb.mode = MBProgressHUDModeText;\
    mb.minSize = CGSizeMake(150,90);\
    [mb hideAnimated:YES afterDelay:3];}\


//tabbar的高度
#define JYTabBarHeigth 49
// 导航栏高度
#define JYNavigationHeight 64


//16进制颜色
#define JYUICOLOR_RGB_Alpha(_color,_alpha) [UIColor colorWithRed:((_color>>16)&0xff)/255.0f green:((_color>>8)&0xff)/255.0f blue:(_color&0xff)/255.0f alpha:_alpha]
// 颜色
#define RGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

//主要金色
#define  JYMainGoldenColor  JYUICOLOR_RGB_Alpha(0xff9e2b,1)
//主要白色
#define  JYMainWhiteColor   JYUICOLOR_RGB_Alpha(0xFFFFFF, 1)
//基本背景色
#define  JYBaseBackColor    JYUICOLOR_RGB_Alpha(0xf0f0f0,1)
//分割线
#define  JYLineColor        JYUICOLOR_RGB_Alpha(0xe6e6e6,1)
//提示文字
#define  JYTipsColor        JYUICOLOR_RGB_Alpha(0x999999,1)
//主要文字颜色
#define  JYMainTextColor    JYUICOLOR_RGB_Alpha(0x333333,1)

#define  JYHideTextColor    JYUICOLOR_RGB_Alpha(0x666666,1)
//iphone6屏幕比例
#define JYWidth_Scale    [UIScreen mainScreen].bounds.size.width/375.0f
#define JYHeight_Scale  [UIScreen mainScreen].bounds.size.height/667.0f
//屏幕适配
#define JYHeight_Scale4 [UIScreen mainScreen].bounds.size.height/480.0f
#define JYHeight_Scale5 [UIScreen mainScreen].bounds.size.height/568.0f
#define JYHeight_Scale6plus [UIScreen mainScreen].bounds.size.height/736.0f

//加载本地图片
#define JYLoadImage(imageName) [UIImage imageNamed:imageName]
//加载不缓存图片
#define JYLoadImage_NotCache(imageName,imageType) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:imageName ofType:imageType]]

//设置字体
#define JYFontSet(fontSize)  [UIFont systemFontOfSize:fontSize]

//frame
#define JYFrame(x,y,width,height)  CGRectMake(x, y, width, height)

//最大最小值
#define JYMaxX(frame) CGRectGetMaxX(frame)
#define JYMaxY(frame) CGRectGetMaxY(frame)
#define JYMinX(frame) CGRectGetMinX(frame)
#define JYMinY(frame) CGRectGetMinY(frame)
//宽度高度
#define JYWidth(frame)    CGRectGetWidth(frame)
#define JYHeight(frame)   CGRectGetHeight(frame)

//偏好设置
#define USERDEFAULT [NSUserDefaults standardUserDefaults]
////获取版本号
#define JYAppVersion [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]

//获取是否需要播放声音
#define JYIsSound @"JYIsSound"
////设置所有密码输入长度不超过26位
#define JYPasswordLengthMaxLimit  26
////设置所有密码输入长度最少6位
#define JYPasswordLengthMinLimit  6
/**************************************Socket*********************************************/

/// View 圆角
#define ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

///  View加边框
#define ViewBorder(View, BorderColor, BorderWidth )\
\
View.layer.borderColor = BorderColor.CGColor;\
View.layer.borderWidth = BorderWidth;

//AppStore 地址
#define AppStorePath @"https://itunes.apple.com/us/app/yun-yu/id1194957059?l=zh&ls=1&mt=8"

//获取系统版本
#define JYSystemVersion ([UIDevice currentDevice].systemVersion.floatValue)
#define iOS10           (JYSystemVersion >= 10.0)
#define iOS9            (JYSystemVersion >= 9.0)
#define iOS8            (JYSystemVersion >= 8.0)
#define iOS7            (JYSystemVersion >= 7.0)
#define iOS6            (JYSystemVersion <  7.0)

//存储路径
#define JYChatMessageSourceCacheBasePath  [NSString stringWithFormat:@"%@/%@/%@",NSHomeDirectory(),@"Library/Caches/Chat",[JYAccountTool account].userName]
#endif /* CommonDefine_h */
