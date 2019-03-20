//
//  ChatTimeCell.m
//  Alan_CocoaSocket
//
//  Created by Alan on 2019/3/8.
//  Copyright © 2019年 Alan. All rights reserved.
//

#import "ChatTimeCell.h"
#import "ChatModel.h"

@interface ChatTimeCell ()

//时间
@property (nonatomic, strong) UILabel *timeLabel;
//时间容器
@property (nonatomic, strong) UIView *timeContainer;

@end

@implementation ChatTimeCell

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
    }
    return self;
}


- (void)setTimeModel:(ChatModel *)timeModel
{
    _timeModel = timeModel;
    self.timeLabel.text = [NSDate timeStringWithTimeInterval:timeModel.sendTime];
    CGSize timeTextSize  = [self.timeLabel sizeThatFits:CGSizeMake(JYScreen_Width, 20)];
    self.timeLabel.frame = JYFrame(5,5, timeTextSize.width, timeTextSize.height);
    self.timeContainer.frame = JYFrame((JYScreen_Width - timeTextSize.width - 10)*0.5, 10, timeTextSize.width + 10, timeTextSize.height + 10);
}

@end
