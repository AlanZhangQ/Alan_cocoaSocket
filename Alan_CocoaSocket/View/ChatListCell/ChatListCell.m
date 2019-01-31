//
//  ChatListCell.m
//  Alan_CocoaSocket
//
//  Created by Alan on 2018/10/21.
//  Copyright © 2018年 Alan. All rights reserved.
//

#import "ChatListCell.h"
#import "ChatModel.h"

@interface ChatListCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bellImageView;
@property (weak, nonatomic) IBOutlet UILabel *unreadLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

@end

@implementation ChatListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    ViewRadius(_iconView, 25);
    ViewRadius(_tipLabel,4 );
    ViewRadius(_unreadLabel, 8);
    _lineLabel.backgroundColor = UILineColor;
    _timeLabel.textColor = UICOLOR_RGB_Alpha(0x999999, 1);
    _lastMessageLabel.textColor = UICOLOR_RGB_Alpha(0x999999, 1);
}

- (void)setChatModel:(ChatModel *)chatModel
{
    _chatModel = chatModel;
    
    //内容
    [self configContent];
    //frame修正
    [self configFrame];
}

- (void)configContent
{
    [_iconView downloadImage:nil placeholder:defaulUserIcon];
    _nameLabel.text              = _chatModel.nickName;
    _timeLabel.text               = _chatModel.lastTimeString;
    _lastMessageLabel.text   = _chatModel.lastMessage;
    _lastMessageLabel.attributedText = [[NSAttributedString alloc]initWithString:_chatModel.lastMessage attributes:@{NSFontAttributeName:FontSet(13),NSForegroundColorAttributeName:[UIColor redColor]}];
    _unreadLabel.text           = [_chatModel.unreadCount stringValue];
    _bellImageView.hidden    = _chatModel.noDisturb.integerValue == 1;
    _tipLabel.hidden             = _chatModel.noDisturb.integerValue == 1;
    _unreadLabel.hidden       = _chatModel.noDisturb.integerValue !=1;
}

- (void)configFrame
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
