//
//  ChatListViewController.m
//  Alan_CocoaSocket
//
//  Created by Alan on 2018/10/21.
//  Copyright © 2018年 Alan. All rights reserved.
//

#import "ChatListViewController.h"
#import "ChatViewController.h"
#import "ChatHandler.h"
#import "ChatListCell.h"

@interface ChatListViewController ()<UITableViewDataSource,UITableViewDelegate,ChatHandlerDelegate>

@property (nonatomic, strong) UITableView *chatlistTableView;
//消息数据源
@property (nonatomic, strong) NSMutableArray *messagesArray;

@end

@implementation ChatListViewController

- (NSMutableArray *)messagesArray
{
    if(!_messagesArray) {
        _messagesArray = [NSMutableArray array];
    }
    return _messagesArray;
}

- (UITableView *)chatlistTableView
{
    if(!_chatlistTableView) {
        _chatlistTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _chatlistTableView.dataSource = self;
        _chatlistTableView.delegate = self;
        _chatlistTableView.rowHeight = 60;
        //聊天列表cell
        [_chatlistTableView registerNib:[UINib nibWithNibName:@"ChatListCell" bundle:nil] forCellReuseIdentifier:@"ChatListCell"];
    }
    return _chatlistTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[ChatHandler shareInstance] addDelegate:self delegateQueue:nil];
    [self initUI];
    [self getMessages];
    // Do any additional setup after loading the view.
}

- (void) initUI
{
    [self.view addSubview:self.chatlistTableView];
}

#pragma mark - dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messagesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatListCell *listCell = [tableView dequeueReusableCellWithIdentifier:@"ChatListCell"];
    
    ChatModel *listModel = self.messagesArray[indexPath.row];
    
    listCell.chatModel = listModel;
    return listCell;
}

#pragma delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ChatModel *seletedChatModel = self.messagesArray[indexPath.row];
    ChatViewController *chatVc = [[ChatViewController alloc]init];
    seletedChatModel.toUserID = @"123456";
    seletedChatModel.chatType = @"userChat";
    chatVc.config = seletedChatModel;
    [self.navigationController pushViewController:chatVc animated:YES];
}


#pragma mark - 接收消息代理
- (void)didReceiveMessage:(ChatModel *)chatModel type:(ChatMessageType)messageType
{
    
}

#pragma mark - 超时消息返回
- (void)sendMessageTimeOutWithTag:(long)tag
{
    
}


#pragma mark - 拉取数据库数据
- (void)getMessages
{
    //暂时先模拟假数据 , 后面加上数据库结构,再修改
    NSArray *tips = @[@"项目里IM这块因为一直都是在摸索,所以特别乱..",@"这一份相当于是进行重构,分层,尽量减少耦合性",@"还有就是把注释和大体思路尽量写下来",@"UI部分很耗时,因为所有的东西都是自己写的",@"如果有兴趣可以fork一下,有空闲时间我就会更新一些",@"如果觉得有用,麻烦star一下噢....",@"如果觉得有用,麻烦star一下噢....",@"具体IP端口涉及公司隐私东西已经隐藏....",@"具体IP端口涉及公司隐私东西已经隐藏...."];
    for (NSInteger index  = 0; index < 30; index ++) {
        
        ChatModel *chatModel   = [[ChatModel alloc]init];
        ChatContentModel *chatContent = [[ChatContentModel alloc]init];
        chatModel.content         = chatContent ;
        chatModel.nickName  = @"Alan";
        if (index<tips.count) {
            chatModel.lastMessage = tips[index];
        }else{
            chatModel.lastMessage  = @"模拟数据,UI部分持续更新中...涉及面较多,比较耗时";
        }
        chatModel.noDisturb      = index%3==0 ? @2 : @1;
        chatModel.unreadCount = @(index);
        chatModel.lastTimeString = [NSDate timeStringWithTimeInterval:chatModel.sendTime];
        [self.messagesArray addObject:chatModel];
    }
    
    [self configNav_Badges];
}

#pragma mark - 配置导航,tabbar角标
- (void)configNav_Badges
{
    NSUInteger totalUnread = 0;
    for (ChatModel *chatModel in self.messagesArray) {
        
        //如果不是免打扰(展示红点)的会话 , 计算总的未读数
        if (chatModel.noDisturb.integerValue !=2) {
            totalUnread += chatModel.unreadCount.integerValue ;
        }
    }
    self.title = totalUnread>0 ? [NSString stringWithFormat:@"%@(%li)",ChatlistTitle,totalUnread] : ChatlistTitle;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
