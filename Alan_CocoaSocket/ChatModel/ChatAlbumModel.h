//
//  ChatAlbumModel.h
//  CocoaAsyncSocket_TCP
//
//  Created by Alan on 2018/10/27.
//  Copyright © 2018年 mengyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface ChatAlbumModel : NSObject

//是否为原图
@property (nonatomic, assign) BOOL isOrignal;
//名字
@property (nonatomic, copy) NSString *name;
//大小
@property (nonatomic, copy) NSString *size;
//图片压缩过的data
@property (nonatomic, strong) NSData *normalPicData;
//图片无压缩data
@property (nonatomic, strong) NSData *orignalPicData;
//音频data
@property (nonatomic, strong) NSData *audioData;
//图片尺寸
@property (nonatomic, assign) CGSize  picSize;
//视频缓存地址
@property (nonatomic, strong) PHAsset *videoAsset;
//视频缩略图
@property (nonatomic, strong) UIImage *videoCoverImg;
//视频 , 语音时长
@property (nonatomic, copy) NSString *duration;

@end
