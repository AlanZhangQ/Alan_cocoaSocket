//
//  JYUpLoadTaskModel.m
//  JYHomeCloud
//
//  Created by mengyaoyao on 16/11/8.
//  Copyright © 2016年 JYall Network Technology Co.,Ltd. All rights reserved.
//

#import "JYUpLoadTaskModel.h"

@implementation JYUpLoadTaskModel

//分析
+ (NSInteger)sectionNumberForOperationData:(NSData *)data
{
    
    //多少M
    intType length = data.length/20000;
    
    
    if (length <1) {
        
        return 1;
    }
    
    //  约1M一份
    NSInteger section = (NSInteger)length +1;
    
    return section;
}


//根据文件大小分析切割成多少份
+ (NSInteger)sectionNumberForFileSize:(int64_t)fileLength
{
    
    //多少M
    intType length = fileLength/(1024 *64);
    
    
    if (length <1) {
        
        return 1;
    }
    
    //  约1M一份
    NSInteger section = (NSInteger)length + 1;
    
    return section;
    
}

//根据文件路径分析需要切割成多少份
+ (NSInteger)sectionNumberForFilePath:(NSString *)fileFath
{
    NSFileHandle *fileReadTxt = [NSFileHandle fileHandleForReadingAtPath:fileFath];
    NSData *data_txt = [NSData dataWithBytes:@"1010" length:4];
    //根据路径信息第一次读取文件,读出一共有几片
    int j = 1;
    while (data_txt.length>0) {
        data_txt = [fileReadTxt readDataOfLength:1024 * 16];
        [fileReadTxt seekToFileOffset:1024 * 16 * j];
        j++;
    }
    [fileReadTxt closeFile];
    return j - 2;
}

@end
