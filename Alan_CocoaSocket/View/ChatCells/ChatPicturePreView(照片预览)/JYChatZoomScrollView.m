//
//  JYChatZoomScrollView.m
//  JYHomeCloud
//
//  Created by Alan on 2017/4/10.
//  Copyright © 2017年 JYall Network Technology Co.,Ltd. All rights reserved.
//

#import "JYChatZoomScrollView.h"
#import "MYAnimationHelper.h"
//#import "MYBottomMenuTool.h"
#import "JYChatRollScrollView.h"
//#import "JYChatUIHandler.h"
#import "AccountTool.h"
#import "CommonDefine.h"

@interface JYChatZoomScrollView ()<UIScrollViewDelegate>

//单击手势
@property (nonatomic, strong) UITapGestureRecognizer *tap;
//双击手势
@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;
//捏合手势
@property (nonatomic, strong) UIPinchGestureRecognizer *pin;
//长按手势
//@property (nonatomic, strong) UILongPressGestureRecognizer *longpress;/

@end

@implementation JYChatZoomScrollView


- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView                        = [[UIImageView alloc]init];
        _imageView.contentMode            = UIViewContentModeScaleAspectFit;
        _imageView.backgroundColor        = [UIColor clearColor];
        _imageView.userInteractionEnabled = YES;
        [_imageView addGestureRecognizer:self.pin];
        [_imageView addGestureRecognizer:self.doubleTap];
//        [_imageView addGestureRecognizer:self.longpress];
    }
    return _imageView;
}

//单击手势
- (UITapGestureRecognizer *)tap
{
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleBarHidden:)];
        [_tap requireGestureRecognizerToFail:self.doubleTap];
    }
    return _tap;
}

//双击手势
- (UITapGestureRecognizer *)doubleTap
{
    if (!_doubleTap) {
        _doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageZoomClick:)];
        _doubleTap.numberOfTapsRequired = 2;
    }
    return _doubleTap;
}

//捏合手势
- (UIPinchGestureRecognizer *)pin
{
    if (!_pin) {
        _pin = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(imageZoomOperation:)];
    }
    return _pin;
}

////长按手势
//- (UILongPressGestureRecognizer *)longpress
//{
//    if (!_longpress) {
//        _longpress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longpressHandle)];
//    }
//    return _longpress;
//}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.minimumZoomScale               = 1.f;
        self.bouncesZoom                    = YES;
        self.delegate                       = self;
        self.backgroundColor                = [UIColor clearColor];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator   = NO;
        [self addGestureRecognizer:self.tap];
        [self addSubview:self.imageView];
    }
    return self;
}


#pragma  mark - 双击放大
- (void)imageZoomClick:(UITapGestureRecognizer *)tap
{
    
    //缩小
    if (self.zoomScale >1.f) {
        
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self setZoomScale:1.f animated:YES];
        
        //放大
    }else{
        
        self.imageView.contentMode = UIViewContentModeScaleToFill;
        CGPoint touchPoint         = [tap locationInView:tap.view];
        CGRect rect                = [self zoomImageWithTouchPoint:touchPoint AndScale:self.maximumZoomScale];
        [self zoomToRect:rect animated:YES];
    }
}


//从点击点放大
- (CGRect)zoomImageWithTouchPoint:(CGPoint)Point AndScale:(CGFloat)scale
{
    CGRect zoomRect = CGRectZero;
    zoomRect.size.width  = CGRectGetWidth(self.frame) / scale;
    zoomRect.size.height = CGRectGetHeight(self.frame) / scale;
    zoomRect.origin.x    = Point.x - zoomRect.size.width / 2.0;
    zoomRect.origin.y    = Point.y - zoomRect.size.height / 2.0;
    
    return zoomRect;
}


#pragma  mark - 代理方法
//需要放大的控件   imageView
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}


- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    
    CGSize boundsSize  = scrollView.bounds.size;
    CGSize contentSize = scrollView.contentSize;
    CGPoint imgCenter  = CGPointMake(contentSize.width / 2.0, contentSize.height / 2.0);
    
    if (contentSize.width < boundsSize.width) {
        imgCenter.x = boundsSize.width / 2.0;
    }
    
    if (contentSize.height < boundsSize.height) {
        imgCenter.y = boundsSize.height / 2.0;
    }
    
    self.imageView.center = imgCenter;
}


#pragma mark - 捏合缩放
- (void)imageZoomOperation:(UIPinchGestureRecognizer *)pin
{
    switch (pin.state) {
            
        case UIGestureRecognizerStateChanged:
            
            self.imageView.transform = CGAffineTransformMakeScale(pin.scale, pin.scale);
            break;
        case UIGestureRecognizerStateEnded:
            
            self.imageView.transform = CGAffineTransformIdentity;
            
            break;
        default:
            break;
    }
}


#pragma  mark - --- 调整imageView
- (void)setPhotoModel:(JYChatPrePhotoModel *)photoModel
{
    _photoModel = photoModel;
    
    if (self.imageView.image) return;
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@",JYStreamServer,photoModel.urlString];
//    NSURL *url = [NSURL URLWithString:urlStr];
    NSString *lastDirName = nil;
    //单聊
    if ([self.photoModel.chatType isEqualToString:@"userChat"]) {
        
        if ([self.photoModel.fromUser isEqualToString:[AccountTool account].myUserID]) {  //我方
            lastDirName = self.photoModel.toUser;
        }else{
            lastDirName = self.photoModel.fromUser;  // 别人发的
        }
    }else if ([self.photoModel.chatType isEqualToString:@"familyChat"]){  //家庭
        lastDirName = self.photoModel.toFamily;
    };
    
    NSString *path = [ChatCache_Path stringByAppendingPathComponent:lastDirName];
    NSString *imagePath = [path stringByAppendingPathComponent:self.photoModel.fileName];
    //本地是否存在
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //URL加载图片
    if ([fileManager fileExistsAtPath:imagePath]) {
        NSData *data = [NSData dataWithContentsOfFile:imagePath];
        UIImage *picImage = [UIImage imageWithData:data];
        self.imageView.image = picImage;
        [self updateImageViewFrame:picImage];  //调整imageView
        return;
    }else{ //手动下载
        
        if (photoModel.urlString.length) {
//            [self.imageView sd_setImageWithURL:url placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
//            } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//                [self updateImageViewFrame:image]; //调整imageView
//            }];
            return;
        }else{ //不存在
            
//            JYDownLoadNewManager *downloadManager = [[JYDownLoadNewManager alloc]init];
//            JYDownLoadTaskModel *taskModel = [[JYDownLoadTaskModel alloc]init];
//            taskModel.fileID = self.photoModel.fileID;
//            taskModel.downLoadPath = path;
//            taskModel.totalLength = self.photoModel.fileSize.longLongValue;
//            taskModel.fileName = self.photoModel.fileName;
//            //下载图片
//            [downloadManager startDownLoadIMWithDownLoadTaskModelArr:[NSMutableArray arrayWithObject:taskModel] progressCallBack:^(JYDownLoadTaskModel *taskModel, NSInteger index) {
//
//            } completeCallBack:^(BOOL isSuccess, JYDownLoadTaskModel *model) {
//
//                if (isSuccess) {
//                    NSData *imageData = [NSData dataWithContentsOfFile:[path stringByAppendingPathComponent:taskModel.fileName]];
//                    UIImage *picImage = [UIImage imageWithData:imageData];
//                    self.imageView.image = picImage;
//                    [self updateImageViewFrame:picImage]; //调整imageViewFrame
//                }
//            }];
        }
    }
}


//调整imageView大小
- (void)updateImageViewFrame:(UIImage *)image
{
    //屏幕宽高比
    CGFloat screenScale = SCREEN_WITDTH / SCREEN_HEIGHT;
    //图片宽高比
    CGFloat picScale    = image.size.width / image.size.height;
    //图片宽高
    CGFloat width       = 0;
    CGFloat height      = 0;
    //高大于等于宽
    if (image.size.height >= image.size.width) {
        
        if (picScale <= screenScale) { //小于屏幕宽高比 , 以屏高为基准
            
            height = SCREEN_HEIGHT;
            width  = 1.0 *image.size.width *(SCREEN_HEIGHT / image.size.height);
            self.imageView.frame = JYFrame((SCREEN_WITDTH - width)*0.5, 0, width, height);
            self.maximumZoomScale = 2.0;
            return;
        }else{  //以屏宽为基准
            
            width  = JYScreen_Width;
            height = 1.0 *image.size.height *(JYScreen_Width / image.size.width);
            self.imageView.frame  = JYFrame(0, (JYScreen_Height - height)*0.5, width, height);
            self.maximumZoomScale = 2.0;
            return;
        }
        //imageViewFrame
    }else{ //宽大于高
        
        //imageViewFrame
        CGFloat width  = JYScreen_Width;
        CGFloat height = 1.0 *image.size.height *(JYScreen_Width / image.size.width);
        self.imageView.frame = JYFrame(0, (JYScreen_Height - height)*0.5, width, height);
        self.maximumZoomScale = 2.0;
        return;
    }
}

#pragma mark - 操作条消失
- (void)handleBarHidden:(UITapGestureRecognizer *)tap
{
    if (self.handleBarHiddenBlock) {
        self.handleBarHiddenBlock();
    }
}


@end
