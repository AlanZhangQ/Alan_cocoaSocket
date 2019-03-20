//
//  JYUpLoadTaskModel.h
//  JYHomeCloud
//
//  Created by mengyaoyao on 16/11/8.
//  Copyright © 2016年 JYall Network Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "JYDownLoadTaskModel.h"
#import <Photos/Photos.h>

#define intType  long long int

typedef NS_ENUM(NSInteger)
{
    //暂停
    JYUpLoadTaskStatusPause       = -3,
    //等待
    JYUpLoadTaskStatusWait        = -2,
    //失败
    JYUpLoadTaskStatusFault       = -1,
    //完成
    JYUpLoadTaskStatusSuccess     = 0,
    //开始
    JYUpLoadTaskStatusStart       = 1,
    //继续
    JYUpLoadTaskStatusContinue    = 2
    
}JYUpLoadTaskStatus;


#define upIntType  long long int

@class JYUpLoadTaskModel;

typedef void(^uploadProgressBack)(JYUpLoadTaskModel *taskModel,NSInteger index);

@interface JYUpLoadTaskModel : NSObject

//当前任务上传状态
//@property (nonatomic, assign) JYDownLoadTaskStatus taskStatus;
//当前任务每个数据块大小 (因为切割是不均匀的,最后一块大部分时间都是不一样大)
@property (nonatomic, assign) upIntType currentDataSize;
//当前一共上传了多少
@property (nonatomic, assign) upIntType currentLength;
//当前第几块计数
@property (nonatomic, assign) NSInteger index;
//总长度
@property (nonatomic, assign) upIntType totalLength;
//当前块上传量
@property (nonatomic, assign) upIntType singleDataComplete;
//当前块上传百分比
@property (nonatomic, assign) CGFloat singleDataCompletePercent;
//当前上传百分比
@property (nonatomic, assign) CGFloat currentCompletedPercent;
//速度
@property (nonatomic, assign) CGFloat speed;
//开始位置
@property (nonatomic, assign) upIntType startLocation;
//一共切割多少块
@property (nonatomic, assign) NSInteger sectionNumber;
//当前上传任务
@property (nonatomic, strong) NSURLSessionDataTask *currentTask;
//当前资源
@property (nonatomic, strong) NSData *sourceData;
//资源路径
@property (nonatomic, copy) NSString *sourcePath;
//fileID
@property (nonatomic, copy) NSString *fileID;
//userID
@property (nonatomic, copy) NSString *userID;
//fileName
@property (nonatomic, copy) NSString *fileName;
//type (个人云盘下载:0 ,共享云盘下载:1)
@property (nonatomic, assign) NSInteger type;
//fileType 文件类型
@property (nonatomic, copy) NSString *fileType;
//successTime 完成日期
@property (nonatomic, copy) NSString *successTime;
//当前不算正在下载块,其他块的上传/下载量和
@property (nonatomic, assign) upIntType generalLength;

//是否进入上传列表 (YES 进入传输列表, NO 不进传输列表)
@property (nonatomic,assign) BOOL isInList;
//上传验证的parentId
@property (nonatomic, copy) NSString *parentID;
//familyID
@property (nonatomic, copy) NSString *familyID;
//MD5
@property (nonatomic, copy) NSString *md5Str;
//fileSource(文件来源 im，share,normal)
@property (nonatomic, copy) NSString *fileSource;
//开始时间
@property (nonatomic, strong) NSDate *taskDate;
//一秒前的数据
@property (nonatomic , assign)intType lastData;
//缩略图
@property (nonatomic, copy) NSString *thumbnail;

//备用字段
@property (nonatomic, assign)id TagBackUp;

//时长
@property (nonatomic, strong) NSString *duration;


/**********************************************/
@property (nonatomic, strong) UIImage *image;
//asset
@property (nonatomic, strong) PHAsset *imageAsset;
/********************************************/
//视频临时存储位置
@property (nonatomic, strong) NSString *tmpPath;



/***************IM增加 -- Alan*******************/
@property (nonatomic, assign) BOOL notFirstCallback;
/***********************************/

@property (nonatomic, copy) NSString *videoPath;


//根据数据分析需要切割成多少份
+ (NSInteger)sectionNumberForOperationData:(NSData *)data;

//根据文件大小分析需要切割成多少份
+ (NSInteger)sectionNumberForFileSize:(intType)fileLength;

//根据文件路径分析需要切割成多少份
+ (NSInteger)sectionNumberForFilePath:(NSString *)fileFath;


@end
