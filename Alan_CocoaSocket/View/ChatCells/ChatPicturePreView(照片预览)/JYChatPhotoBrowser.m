//
//  JYChatPhotoBrowser.m
//  JYHomeCloud
//
//  Created by Alan on 2017/4/10.
//  Copyright © 2017年 JYall Network Technology Co.,Ltd. All rights reserved.
//

#import "JYChatPhotoBrowser.h"
#import "JYChatRollScrollView.h"
#import "JYChatZoomScrollView.h"
#import "MYAnimationHelper.h"
#import "UIButton+topImageButton.h" //按钮
#import "NSString+Extension.h"
#import "CommonDefine.h"
#import "ChatModel.h"
#import "AccountTool.h"

@interface JYChatPhotoBrowser ()

@property (nonatomic, strong) NSArray<JYChatPrePhotoModel *> *photos;
//占位图
@property (nonatomic, copy) NSString *placeholderName;
//用于滚动
@property (nonatomic, strong) JYChatRollScrollView *rollScrollView;
//是否需要动画
@property (nonatomic, assign,getter=isNeedAnimation) BOOL animation;
//当前是第几张
@property (nonatomic, assign) NSInteger currentIndex;
//点击的imageView
@property (nonatomic, strong) UIImageView *touchImageView;
//顶部导航
@property (nonatomic, strong) UIView *topView;
//底部操作条
@property (nonatomic, strong) UIView *bottomView;
//下载按钮
@property (nonatomic, strong) UIButton *downloadButton;
//保存到云盘按钮
@property (nonatomic, strong) UIButton *saveButton;
//标题
@property (nonatomic, strong) UILabel *titleLabel;
//返回按钮
@property (nonatomic, strong) UIButton *backButton;
//操作条是否隐藏
@property (nonatomic, assign,getter=handleBarIsHidden) BOOL handleBarHidden;
//查看大图
@property (nonatomic, strong) UIButton *orginalButton;
//取消查看原图按钮
@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation JYChatPhotoBrowser

- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setImage:JYLoadImage(@"close") forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelDownload) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.hidden = YES;
    }
    return _cancelButton;
}

- (UIButton *)orginalButton
{
    if (!_orginalButton) {
        _orginalButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _orginalButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _orginalButton.titleLabel.font = JYFontSet(14.f);
        [_orginalButton setTitleColor:JYUICOLOR_RGB_Alpha(0xffffff, 1) forState:UIControlStateNormal];
        [_orginalButton setBackgroundColor:JYUICOLOR_RGB_Alpha(0x000000, 0.3)];
        [_orginalButton addTarget:self action:@selector(orignalPicture) forControlEvents:UIControlEventTouchUpInside];
        ViewRadius(_orginalButton, 3.f);
        [_orginalButton addSubview:self.cancelButton];
    }
    return _orginalButton;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"查看大图";
        _titleLabel.font = JYFontSet(18.f);
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    return _titleLabel;
}

- (UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.imageView.contentMode = UIViewContentModeLeft;
        [_backButton setImage:JYLoadImage(@"JY_Top_back") forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(browserDismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}


- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc]init];
        _topView.backgroundColor = JYUICOLOR_RGB_Alpha(0x333333, 1);
        [_topView addSubview:self.titleLabel];
        [_topView addSubview:self.backButton];
    }
    return _topView;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = JYUICOLOR_RGB_Alpha(0x333333, 1);
        [_bottomView addSubview:self.downloadButton];
        [_bottomView addSubview:self.saveButton];
    }
    return _bottomView;
}


- (UIButton *)downloadButton
{
    if (!_downloadButton) {
        _downloadButton = [UIButton topImageButtonFactoryTarget:self action:@selector(downLoadBigImage) normalImage:@"white_download" selectedImage:nil title:@"下载" titleColor:JYUICOLOR_RGB_Alpha(0xffffff, 1) fontSize:14.f];
    }
    return _downloadButton;
}

- (UIButton *)saveButton
{
    if (!_saveButton) {
        _saveButton = [UIButton topImageButtonFactoryTarget:self action:@selector(saveToPersonalCache) normalImage:@"white_mycloud" selectedImage:nil title:@"存入个人云盘" titleColor:JYUICOLOR_RGB_Alpha(0xffffff, 1) fontSize:14.f];
    }
    return _saveButton;
}


//用于滚动容器
- (JYChatRollScrollView *)rollScrollView
{
    if (!_rollScrollView) {
        
        __weak typeof(self) weakself    = self;
        _rollScrollView                 = [[JYChatRollScrollView alloc]initWithFrame:self.bounds callBack:^(NSInteger currentPage) {
            
            _currentIndex               = currentPage;
            [weakself loadImage:currentPage]; //加载图片
            
            [weakself configButtonTitles]; //更新查看大图标题
            
        }];
        _rollScrollView.contentSize     = CGSizeMake(JYScreen_Width *_photos.count, JYScreen_Height);
    }
    return _rollScrollView;
}



#pragma  mark - 照片浏览初始化
- (instancetype)initWithUrls:(NSArray<ChatModel *> *)messageModels imgView:(UIImageView *)touchImageView currentIndex:(NSInteger)index
{
    if (!messageModels.count) return nil;
    
    NSMutableArray *tmpArray = [NSMutableArray array];
    [messageModels enumerateObjectsUsingBlock:^(ChatModel * _Nonnull messageModel, NSUInteger idx, BOOL * _Nonnull stop) {
       
        JYChatPrePhotoModel *photoModel = [[JYChatPrePhotoModel alloc]init];
//        photoModel.urlString = messageModel.content.thumbnailLocIms;
        photoModel.fileName  = messageModel.content.fileName;
//        photoModel.fileID    = messageModel.content.fileId;
        photoModel.chatType  = messageModel.chatType;
        photoModel.fileSize  = messageModel.content.fileSize;
        photoModel.fromUser  = messageModel.fromUserID;
        photoModel.toUser    = messageModel.toUserID;
//        photoModel.toFamily  = messageModel.toFamily;
        [tmpArray addObject:photoModel];
    }];
    _photos          = tmpArray;
    _currentIndex    = index;
    _touchImageView  = touchImageView;
    CGRect frame     = CGRectMake(0, 0, JYScreen_Width, JYScreen_Height);
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor        = [UIColor colorWithWhite:0 alpha:1];
        [self addSubview:self.rollScrollView];
        [self addphotosScrollView];
        
        //原图按钮
        [self initOrgnalButton];
        //初始化顶部导航,底部操作条
        [self initTopBottomItems];
    }
    return self;
}


- (void)initOrgnalButton
{
    [self addSubview:self.orginalButton]; 
}

//初始化顶部导航,底部操作条,原图按钮
- (void)initTopBottomItems
{
    //初始化导航和底部条
    [self addSubview:self.topView];
    [self addSubview:self.bottomView];
    
    [self configButtonTitles]; //初始化标题
    _bottomView.frame = JYFrame(0,JYScreen_Height - 60, JYScreen_Width, 60);
    _downloadButton.frame = JYFrame(JYScreen_Width *0.5, 0, JYScreen_Width *0.5, 60);
    _saveButton.frame = JYFrame(0, 0, JYScreen_Width *0.5, 60);
    _topView.frame = JYFrame(0, 0, JYScreen_Width, 64);
    _backButton.frame = JYFrame(10, 20, 44, 44);
    _titleLabel.frame = JYFrame((JYScreen_Width - 200)*0.5, 15, 200, 44);
}



//初始化子控件
- (void)addphotosScrollView
{
    
    for (NSInteger index = 0; index < self.photos.count; index ++) {
        
        JYChatZoomScrollView *zooScrollView = [[JYChatZoomScrollView alloc]initWithFrame:CGRectMake(index *JYScreen_Width, 0, JYScreen_Width, JYScreen_Height)];
        JYweakify(self);
        zooScrollView.handleBarHiddenBlock = ^{
            [UIView animateWithDuration:0.15 animations:^{
                JYstrongify(self);
                if (_handleBarHidden) {
                    self.orginalButton.transform = CGAffineTransformIdentity;
                    self.topView.transform       = CGAffineTransformIdentity;
                    self.bottomView.transform    = CGAffineTransformIdentity;
                }else{
                    self.orginalButton.transform = CGAffineTransformMakeTranslation(0,30);
                    self.topView.transform       = CGAffineTransformMakeTranslation(0,-64);
                    self.bottomView.transform    = CGAffineTransformMakeTranslation(0,60);
                }
            } completion:^(BOOL finished) {
                _handleBarHidden           = !_handleBarHidden;
            }];
        };
        [self.rollScrollView addSubview:zooScrollView];
        [self.rollScrollView.zoomViews addObject:zooScrollView];
    }
    [self.rollScrollView setContentOffset:CGPointMake(JYScreen_Width * self.currentIndex, 0) animated:NO]; //设置偏移
}



//开启照片浏览器
- (void)showWithAnimation:(BOOL)animation
{
    _animation                   = animation;
    [self.rollScrollView.zoomViews enumerateObjectsUsingBlock:^(JYChatZoomScrollView  *_Nonnull zoomView, NSUInteger idx, BOOL * _Nonnull stop) {
        zoomView.animation       = animation;
    }];
    
    UIWindow *keyWindow          = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    if (!animation) {
        [self loadImage:_currentIndex];
        return;
    }
    __weak typeof(self) weakself = self;
    //动画
    [[MYAnimationHelper shareInstance]coreAnimationWithAnimationView:self.rollScrollView relativeView:self.touchImageView style:MYShowAnimation finished:^{
        
        [weakself loadImage:weakself.currentIndex];
    }];
}

//加载照片
- (void)loadImage:(NSInteger )idx
{
    JYChatPrePhotoModel *photoModel = self.photos[idx];
    JYChatZoomScrollView *zoomScrollView = self.rollScrollView.zoomViews[idx];
    zoomScrollView.photoModel        = photoModel;
    
    [self configOrignalButtonInfo];
}


#pragma mark - 操作
//保存到个人云盘
- (void)saveToPersonalCache
{
//    JYChatPrePhotoModel *photoModel = self.photos[_currentIndex];
//    [JYChatApiManager excuteSavaFilesToPersonalCloudWithFileIDs:@[photoModel.fileID] fileParent:@"root" userID:[JYAccountTool account].userName familyID:nil response:nil];
}

//下载到相册
- (void)downLoadBigImage
{
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"下载成功" message:@"点击确定保存到我的相册中" preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//        //保存
//        UIImageWriteToSavedPhotosAlbum(invoiceImage, nil,nil, NULL);
//        
//    }];
//    UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//    }];
//    
//    [alert addAction:actionTwo];
//    [alert addAction:actionOne];
//    [self presentViewController:alert animated:YES completion:nil];
    //保存
    JYChatZoomScrollView *zoomView = self.rollScrollView.zoomViews[_currentIndex];
    UIImage *saveImage = zoomView.imageView.image;
    UIImageWriteToSavedPhotosAlbum(saveImage, nil,nil, NULL);
    ShowToast(@"成功保存到相册");
}

#pragma mark - 顶部标题
- (void)configButtonTitles
{
    JYChatPrePhotoModel *photoModel = self.photos[_currentIndex];
    self.titleLabel.text = photoModel.fileName;
}

#pragma mark - 退出
- (void)browserDismiss
{
    JYChatZoomScrollView *zoomScrollView = self.rollScrollView.zoomViews[_currentIndex];
    [zoomScrollView setZoomScale:1.f animated:NO];
    if (self.animation) {
        [[MYAnimationHelper shareInstance]coreAnimationWithAnimationView:zoomScrollView.imageView relativeView:self.touchImageView style:MYRemoveAnimation finished:^{
        }];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}


#pragma mark - 取消原图
- (void)cancelDownload
{
//    JYChatPrePhotoModel *photoModel = self.photos[_currentIndex];
//    self.cancelButton.hidden = YES;
//    JYDownLoadNewManager *downloadManager = [[JYDownLoadNewManager alloc]init];
//    [downloadManager cancelDownLoadTaskWithFileID:photoModel.fileID];
}

#pragma mark - 查看原图
//查看原图
- (void)orignalPicture
{
    
    JYChatPrePhotoModel *photoModel = self.photos[_currentIndex];
    JYChatZoomScrollView *zoomView  = self.rollScrollView.zoomViews[_currentIndex];
    UIImageView *imageView = zoomView.imageView;
    NSString *lastDirName = nil;
    //单聊
    if ([photoModel.chatType isEqualToString:@"userChat"]) {
        
        if ([photoModel.fromUser isEqualToString:[AccountTool account].myUserID]) {  //我方
            lastDirName = photoModel.toUser;
        }else{
            lastDirName = photoModel.fromUser;  // 别人发的
        }
    }else if ([photoModel.chatType isEqualToString:@"familyChat"]){  //家庭
        lastDirName = photoModel.toFamily;
    };
    
    NSString *path = [ChatCache_Path stringByAppendingPathComponent:lastDirName];
    NSString *bigImagePath = [path stringByAppendingPathComponent:[@"big_"stringByAppendingString:photoModel.fileName]];
    __block UIImage *picImage = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:bigImagePath]) { //本地已经存在
        NSData *data = [NSData dataWithContentsOfFile:bigImagePath];
        picImage = [UIImage imageWithData:data];
        [self.orginalButton setTitle:@"已完成" forState:UIControlStateNormal];
        self.cancelButton.hidden = YES;
        imageView.image = picImage;
        [UIView animateWithDuration:1 animations:^{
            self.orginalButton.alpha = 0.00001;
        } completion:^(BOOL finished) {
            self.orginalButton.hidden = YES;
            self.cancelButton.hidden = YES;
            photoModel.isHaveTouch = YES;
        }];
    }else{
        
//        JYDownLoadNewManager *downloadManager = [[JYDownLoadNewManager alloc]init];
//        JYDownLoadTaskModel *taskModel = [[JYDownLoadTaskModel alloc]init];
//        taskModel.fileID = photoModel.fileID;
//        taskModel.downLoadPath = path;
//        taskModel.totalLength = photoModel.fileSize.longLongValue;
//        taskModel.fileName = [@"big_"stringByAppendingString:photoModel.fileName];
//        //下载原图
//        [downloadManager startDownLoadIMWithDownLoadTaskModelArr:[NSMutableArray arrayWithObject:taskModel] progressCallBack:^(JYDownLoadTaskModel *taskModel, NSInteger index) {
//            CGFloat progress = (CGFloat)taskModel.currentLength/taskModel.totalLength;
//            [self.orginalButton setTitle:[NSString stringWithFormat:@"%d%@",(int)(progress*100),@"%"] forState:UIControlStateNormal];
//            self.cancelButton.hidden = NO;
//        } completeCallBack:^(BOOL isSuccess, JYDownLoadTaskModel *model) {
//
//            if (isSuccess) {
//                NSData *imageData = [NSData dataWithContentsOfFile:bigImagePath];
//                picImage = [UIImage imageWithData:imageData];
//                imageView.image = picImage;
//                [self.orginalButton setTitle:@"已完成" forState:UIControlStateNormal];
//                self.cancelButton.hidden = YES;
//                [UIView animateWithDuration:1 animations:^{
//                    self.orginalButton.alpha = 0.00001;
//                } completion:^(BOOL finished) {
//                    self.orginalButton.hidden = YES;
//                    photoModel.isHaveTouch = YES;
//                }];
//            }else{ //取消或者失败情况
//
//                NSString *sizeStr = [self photoSize:photoModel.fileSize];
//                NSString *acTitle = [@"查看原图 " stringByAppendingString:[NSString stringWithFormat:@"(%@)",sizeStr]];
//                [self.orginalButton setTitle:acTitle forState:UIControlStateNormal];
//                //移除本地
//                [fileManager removeItemAtPath:bigImagePath error:NULL];
//            }
//        }];
    }
}


- (NSString *)photoSize:(NSString *)photoSize
{
    long long int size = photoSize.longLongValue;
    if (size<1024) {
        return [NSString stringWithFormat:@"%lldb",size];
        
    }else if (size>1024 && size < 1024 *1024) {
        
        return [NSString stringWithFormat:@"%.1fk",(CGFloat)(1.0 *size/1024)];
        
    }else if(size >1024 && size< 1024*1024*1024){
        
        return [NSString stringWithFormat:@"%.1fM",(CGFloat)(1.0 *size/1024/1024)];
    }else{
        
        return [NSString stringWithFormat:@"%.1fG",(CGFloat)(1.0 *size/1024/1024/1024)];
    }
}

#pragma mark - 配置查看原图按钮信息
- (void)configOrignalButtonInfo
{
    JYChatPrePhotoModel *photoModel = self.photos[_currentIndex];
    self.orginalButton.hidden = photoModel.isHaveTouch||[photoModel.fromUser isEqualToString:[AccountTool account].myUserID];
    self.orginalButton.alpha  = 1;
    NSString *sizeStr = [self photoSize:photoModel.fileSize];
    NSString *acTitle = [@"查看原图 " stringByAppendingString:[NSString stringWithFormat:@"(%@)",sizeStr]];
    [_orginalButton setTitle:acTitle forState:UIControlStateNormal];
    CGFloat width = [self.orginalButton.currentTitle sizeWithFont:JYFontSet(14.f) maxSize:CGSizeMake(300, 28)].width;
    _orginalButton.frame = JYFrame((JYScreen_Width - (width + 20))*0.5,JYScreen_Height - 103, width + 20, 28);
    _cancelButton.frame = JYFrame(JYWidth(self.orginalButton.frame)-34,2, 24, 24);
}


@end
