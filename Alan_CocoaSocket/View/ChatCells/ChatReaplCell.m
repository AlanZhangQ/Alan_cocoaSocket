//
//  JYChatReaplCell.m
//  JYHomeCloud
//
//  Created by Alan on 2017/2/15.
//  Copyright © 2017年 JYall Network Technology Co.,Ltd. All rights reserved.
//

#import "ChatReaplCell.h"
#import "ChatModel.h"
#import "NSDate+extension.h"

@interface ChatReaplCell ()

//时间
@property (nonatomic, strong) UILabel *timeLabel;
//时间容器
@property (nonatomic, strong) UIView *timeContainer;
//提示
@property (nonatomic, strong) UILabel *reaplTipLabel;
//提示容器
@property (nonatomic, strong) UIView *tipContainer;

@end

@implementation ChatReaplCell

- (UIView *)timeContainer
{
    if (!_timeContainer) {
        _timeContainer = [[UIView alloc]init];
        _timeContainer.backgroundColor = JYUICOLOR_RGB_Alpha(0xcecece, 1);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            ViewRadius(_timeContainer, 5.f);
        });
        [_timeContainer addSubview:self.timeLabel];
    }
    return _timeContainer;
}

//时间
- (UILabel *)reaplTipLabel
{
    if (!_reaplTipLabel) {
        _reaplTipLabel = [[UILabel alloc]init];
        _reaplTipLabel.textColor = JYMainWhiteColor;
        _reaplTipLabel.textAlignment = NSTextAlignmentCenter;
        _reaplTipLabel.font = JYFontSet(12.f);
    }
    return _reaplTipLabel;
}

- (UIView *)tipContainer
{
    if (!_tipContainer) {
        _tipContainer = [[UIView alloc]init];
        _tipContainer.backgroundColor = JYUICOLOR_RGB_Alpha(0xcecece, 1);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            ViewRadius(_tipContainer, 5.f);
        });
        [_tipContainer addSubview:self.reaplTipLabel];
    }
    return _tipContainer;
}

//时间
- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor = JYMainWhiteColor;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = JYFontSet(12.f);
    }
    return _timeLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = JYBaseBackColor;
        [self.contentView addSubview:self.timeContainer];
        [self.contentView addSubview:self.tipContainer];
    }
    return self;
}


- (void)setReaplModel:(ChatModel *)reaplModel
{
    _reaplModel = reaplModel;
    
    self.timeContainer.frame = CGRectZero; //处理复用
    //处理时间
    if (reaplModel.shouldShowTime) {
        self.timeContainer.hidden = NO;
        self.timeLabel.text = [NSDate timeStringWithTimeInterval:reaplModel.sendTime];
        CGSize timeTextSize  = [self.timeLabel sizeThatFits:CGSizeMake(JYScreen_Width, 20)];
        self.timeLabel.frame = JYFrame(5,5, timeTextSize.width, timeTextSize.height);
        self.timeContainer.frame = JYFrame((JYScreen_Width - timeTextSize.width - 10)*0.5, 10, timeTextSize.width + 10, timeTextSize.height + 10);
    }else{
        self.timeContainer.hidden = YES;
    }

    //处理提示
    self.reaplTipLabel.text  = reaplModel.content.text;
    CGSize tipSize = [self.reaplTipLabel sizeThatFits:CGSizeMake(JYScreen_Width, MAXFLOAT)];
    self.reaplTipLabel.frame = JYFrame(5, 5, tipSize.width, tipSize.height);
    self.tipContainer.frame  = JYFrame((JYScreen_Width - tipSize.width - 10)*0.5, JYMaxY(self.timeContainer.frame) + 10, tipSize.width + 10, tipSize.height + 10);
}
    



@end
