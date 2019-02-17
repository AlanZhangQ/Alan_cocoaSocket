# Alan_CocoaSocket
高仿微信，基于CocoaAsyncSocket实现微信长链接，实现微信发送文字，语音，图片，视频

Github地址：https://github.com/AlanZhangQ/Alan_cocoaSocket.git，如果有用，请点star.

之前做的项目有IM部分，在考虑了环信和融云等已经比较通用的IMSDK，发现它们自定义程度不是很符合我们，想要自由约束，就需要自己定义一份网络协议，在CSDN，CocoaChina等网站收集整理信息后，决定使用CocoaAsyncSocket搭建IM。

一.CocoaAsyncSocket介绍

CocoaAsyncSocket中主要包含两个类:

1.GCDAsyncSocket.
```
1 用GCD搭建的基于TCP/IP协议的socket网络库
2 GCDAsyncSocket is a TCP/IP socket networking library built atop Grand Central Dispatch. -- 引自CocoaAsyncSocket.
```
2.GCDAsyncUdpSocket.
```
1 用GCD搭建的基于UDP/IP协议的socket网络库.
2 GCDAsyncUdpSocket is a UDP/IP socket networking library built atop Grand Central Dispatch..-- 引自CocoaAsyncSocket.
```
二.下载CocoaAsyncSocket

首先,需要到这里下载CocoaAsyncSocket.

下载后可以看到文件所在位置.



文件路径

这里只要拷贝以下两个文件到项目中.



TCP开发使用的文件

三.CocoaAsyncSocket的具体使用

1.继承GCDAsyncSocketDelegate协议.

@interface ChatHandler ()<GCDAsyncSocketDelegate>
2.初始化聊天Handler单例，并将其设置成接收TCP信息的代理。

#pragma mark - 初始化聊天handler单例
```
+ (instancetype)shareInstance
{
    static ChatHandler *handler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [[ChatHandler alloc]init];
    });
    return handler;
}

- (instancetype)init
{
    if(self = [super init]) {
        //将handler设置成接收TCP信息的代理
        _chatSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        //设置默认关闭读取
        [_chatSocket setAutoDisconnectOnClosedReadStream:NO];
        //默认状态未连接
        _connectStatus = SocketConnectStatus_UnConnected;
    }
    return self;
}
```
3.连接测试或正式服务器端口
```
#pragma mark - 连接服务器端口
- (void)connectServerHost
{
    NSError *error = nil;
    [_chatSocket connectToHost:@"此处填写服务器IP" onPort:8080 error:&error];
    if (error) {
        NSLog(@"----------------连接服务器失败----------------");
    }else{
        NSLog(@"----------------连接服务器成功----------------");
    }
}
```
4.服务器端口连接成功，TCP连接正式建立，配置SSL 相当于https 保证安全性 , 这里是单向验证服务器地址 , 仅仅需要验证服务器的IP即可
```
#pragma mark - TCP连接成功建立 ,配置SSL 相当于https 保证安全性 , 这里是单向验证服务器地址 , 仅仅需要验证服务器的IP即可
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    // 配置 SSL/TLS 设置信息
    NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithCapacity:3];
    //允许自签名证书手动验证
    [settings setObject:@YES forKey:GCDAsyncSocketManuallyEvaluateTrust];
    //GCDAsyncSocketSSLPeerName
    [settings setObject:@"此处填服务器IP地址" forKey:GCDAsyncSocketSSLPeerName];
    [_chatSocket startTLS:settings];
}
```
5.SSL验证成功，发送登录验证，开启读入流
```
#pragma mark - TCP成功获取安全验证
- (void)socketDidSecure:(GCDAsyncSocket *)sock
{
    //登录服务器
    ChatModel *loginModel  = [[ChatModel alloc]init];
    //此版本号需和后台协商 , 便于后台进行版本控制
    loginModel.versionCode = TCP_VersionCode;
    //当前用户ID
    loginModel.fromUserID  = [Account account].myUserID;
    //设备类型
    loginModel.deviceType  = DeviceType;
    //发送登录验证
    [self sendMessage:loginModel timeOut:-1 tag:0];
    //开启读入流
    [self beginReadDataTimeOut:-1 tag:0];
}
```
6.发送消息给服务端
```
#pragma mark - 发送消息
- (void)sendMessage:(ChatModel *)chatModel timeOut:(NSUInteger)timeOut tag:(long)tag
{
    //将模型转换为json字符串
    NSString *messageJson = chatModel.mj_JSONString;
    //以"\n"分割此条消息 , 支持的分割方式有很多种例如\r\n、\r、\n、空字符串,不支持自定义分隔符,具体的需要和服务器协商分包方式 , 这里以\n分包
    /*
     如不进行分包,那么服务器如果在短时间里收到多条消息 , 那么就会出现粘包的现象 , 无法识别哪些数据为单独的一条消息 .
     对于普通文本消息来讲 , 这里的处理已经基本上足够 . 但是如果是图片进行了分割发送,就会形成多个包 , 那么这里的做法就显得并不健全,严谨来讲,应该设置包头,把该条消息的外信息放置于包头中,例如图片信息,该包长度等,服务器收到后,进行相应的分包,拼接处理.
     */
    messageJson           = [messageJson stringByAppendingString:@"\n"];
    //base64编码成data
    NSData  *messageData  = [[NSData alloc]initWithBase64EncodedString:messageJson options:NSDataBase64DecodingIgnoreUnknownCharacters];
    //写入数据
    [_chatSocket writeData:messageData withTimeout:1 tag:1];
}
```
声明：cocoaAsyncSocket主要是通过- (void)writeData:(NSData *)data withTimeout:(NSTimeInterval)timeout tag:(long)tag这个方法由客户端发送数据给服务器。

7.接收服务器端消息
```
#pragma mark - 接收到消息
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    //转为明文消息
    NSString *secretStr  = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    //去除'\n'
    secretStr            = [secretStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    //转为消息模型(具体传输的json包裹内容,加密方式,包头设定什么的需要和后台协商,操作方式根据项目而定)
    ChatModel *messageModel = [ChatModel mj_objectWithKeyValues:secretStr];
    
    //接收到服务器的心跳
    if ([messageModel.beatID isEqualToString:TCP_beatBody]) {
        
        //未接到服务器心跳次数置为0
        _senBeatCount = 0;
        NSLog(@"------------------接收到服务器心跳-------------------");
        return;
    }
```
8.socket已经断开连接.
```
#pragma mark - TCP已经断开连接
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    //    //如果是主动断开连接
    //    if (_connectStatus == SocketConnectStatus_DisconnectByUser) return;
    //置为未连接状态
    _connectStatus  = SocketConnectStatus_UnConnected;
    //自动重连
    if (autoConnectCount) {
        [self connectServerHost];
        NSLog(@"-------------第%ld次重连--------------",(long)autoConnectCount);
        autoConnectCount -- ;
    }else{
        NSLog(@"----------------重连次数已用完------------------");
    }
}
```
9.心跳连接的建立
```
- (dispatch_source_t)beatTimer
{
    if (!_beatTimer) {
        _beatTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
        dispatch_source_set_timer(_beatTimer, DISPATCH_TIME_NOW, TCP_BeatDuration * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(_beatTimer, ^{
            //发送心跳 +1
            _senBeatCount++;
            //超过三次未收到服务器心跳, 设置为未连接状态
            if (_senBeatCount > TCP_MaxBeatMissCount) {
                _connectStatus = SocketConnectStatus_UnConnected;
            } else {
                //发送心跳
                NSData *beatData = [[NSData alloc] initWithBase64EncodedString: [TCP_beatBody stringByAppendingString:@"\n"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
                [_chatSocket writeData:beatData withTimeout:-1 tag:9999];
                NSLog(@"------------------发送了心跳------------------");
            }
        });
    }
    return _beatTimer;
}
```
声明：心跳连接是确认服务器端和客户端是否建立连接的测试，需要服务器端和客户端确定心跳包和心跳间隔。

四.IM中UI的具体实现

1.文字消息，这里不用多说，主要涉及到图文混排(可以看Github:https://github.com/AlanZhangQ/CoreTextLabel.git)，实现效果如图：



2.语音消息，主要是分为录音，转换格式(由PCM格式等转为MP3格式)，播放。实现效果如下：



录音的主要代码:
```
- (void)setSesstion
{
    _session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [_session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];

    if (_session == nil)
    {
        NSLog(@"Error creating session: %@", [sessionError description]);
    }
    else
    {
        [_session setActive:YES error:nil];
    }
}
- (void)setRecorder
{
    _recorder = nil;
    NSError             *recorderSetupError = nil;
    NSURL               *url                = [NSURL fileURLWithPath:[self cafPath]];
    NSMutableDictionary *settings           = [[NSMutableDictionary alloc] init];
    //录音格式 无法使用
    [settings setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    //采样率
    [settings setValue:[NSNumber numberWithFloat:11025.0] forKey:AVSampleRateKey]; //44100.0
    [settings setValue:[NSNumber numberWithFloat:38400.0] forKey:AVEncoderBitRateKey];
    //通道数
    [settings setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    //音频质量,采样质量
    [settings setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];
//    [];
    _recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&recorderSetupError];
    if (recorderSetupError)
    {
        NSLog(@"%@", recorderSetupError);
    }
    _recorder.meteringEnabled = YES;
    _recorder.delegate        = self;
    [_recorder prepareToRecord];
}
```
转换格式的主要代码：
```
- (void)audio_PCMtoMP3:(NSTimeInterval)recordTime
{
    NSString *cafFilePath = [self cafPath];
    NSString *mp3FilePath = [self mp3Path];

    // remove the old mp3 file
    [self deleteMp3Cache];

    NSLog(@"MP3转换开始");
    if (_delegate && [_delegate respondsToSelector:@selector(beginConvert)])
    {
        [_delegate beginConvert];
    }
    @try
    {
        int read, write;

        FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb"); //source 被转换的音频文件位置
        fseek(pcm, 4 * 1024, SEEK_CUR);                                //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb"); //output 输出生成的Mp3文件位置

        const int     PCM_SIZE = 8192;
        const int     MP3_SIZE = 8192;
        short int     pcm_buffer[PCM_SIZE * 2];
        unsigned char mp3_buffer[MP3_SIZE];

        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 11025.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);

        do
        {
            read = fread(pcm_buffer, 2 * sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
            {
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            }
            else
            {
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            }

            fwrite(mp3_buffer, write, 1, mp3);

        }
        while (read != 0);

        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@", [exception description]);
    }
    @finally
    {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategorySoloAmbient error:nil];
    }

    [self deleteCafCache];
    NSLog(@"MP3转换结束");
    if (_delegate && [_delegate respondsToSelector:@selector(endConvertWithData:seconds:)])
    {
        NSData *voiceData = [NSData dataWithContentsOfFile:[self mp3Path]];
        [_delegate endConvertWithData:voiceData seconds:recordTime];
    }
}
```
播放的主要代码如下：
```
- (instancetype)initWithPath:(NSString *)path
{
    if (self = [super init]) {
        self.item   = [[AVPlayerItem alloc]initWithURL:[NSURL fileURLWithPath:path]];
        self.player = [[AVPlayer alloc]initWithPlayerItem:self.item];
        UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
        AudioSessionSetProperty(kAudioSessionProperty_AudioCategory,
                                sizeof(sessionCategory),
                                &sessionCategory);
        
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
                                 sizeof (audioRouteOverride),
                                 &audioRouteOverride);
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        //静音模式依然播放
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        [audioSession setActive:YES error:nil];
    }
    return self;
}


- (void)play
{
    [self.player play];
}
```
3.图片和视频消息，主要是通过阿里巴巴的TZImagerPicker框架实现存取，实现效果如下：



五.IM整体逻辑和问题的梳理

关于Socket连接

登录 -> 连接服务器端口 -> 成功连接 -> SSL验证 -> 发送登录TCP请求(login) -> 收到服务端返回登录成功回执(loginReceipt) ->发送心跳 -> 出现连接中断 ->断网重连3次 -> 退出程序主动断开连接

关于连接状态监听

1. 普通网络监听

由于即时通讯对于网络状态的判断需要较为精确 ，原生的Reachability实际上在很多时候判断并不可靠 。 
主要体现在当网络较差时，程序可能会出现连接上网络 ， 但并未实际上能够进行数据传输 。 
开始尝试着用Reachability加上一个普通的网络请求来双重判断实现更加精确的网络监听 ， 但是实际上是不可行的 。 
如果使用异步请求依然判断不精确 ， 若是同步请求 ， 对性能的消耗会很大 。 
最终采取的解决办法 ， 使用RealReachability ，对网络监听同时 ，PING服务器地址或者百度 ，网络监听问题基本上得以解决

2. TCP连接状态监听：

TCP的连接状态监听主要使用服务器和客户端互相发送心跳 ，彼此验证对方的连接状态 。 
规则可以自己定义 ， 当前使用的规则是 ，当客户端连接上服务器端口后 ，且成功建立SSL验证后 ，向服务器发送一个登陆的消息(login)。 
当收到服务器的登陆成功回执（loginReceipt)开启心跳定时器 ，每一秒钟向服务器发送一次心跳 ，心跳的内容以安卓端/iOS端/服务端最终协商后为准 。 
当服务端收到客户端心跳时，也给服务端发送一次心跳 。正常接收到对方的心跳时，当前连接状态为已连接状态 ，当服务端或者客户端超过3次（自定义）没有收到对方的心跳时，判断连接状态为未连接。

关于本地缓存

1. 数据库缓存

建议每个登陆用户创建一个DB ，切换用户时切换DB即可 。 
搭建一个完善IM体系 ， 每个DB至少对应3张表 。 
一张用户存储聊天列表信息，这里假如它叫chatlist ，即微信首页 ，用户存储每个群或者单人会话的最后一条信息 。来消息时更新该表，并更新内存数据源中列表信息。或者每次来消息时更新内存数据源中列表信息 ，退出程序或者退出聊天列表页时进行数据库更新。后者避免了频繁操作数据库，效率更高。 
一张用户存储每个会话中的详细聊天记录 ，这里假如它叫chatinfo。该表也是如此 ，要么接到消息立马更新数据库，要么先存入内存中，退出程序时进行数据库缓存。 
一张用于存储好友或者群列表信息 ，这里假如它叫myFriends ，每次登陆或者退出，或者修改好友备注，删除好友，设置星标好友等操作都需要更新该表。

2. 沙盒缓存

当发送或者接收图片、语音、文件信息时，需要对信息内容进行沙盒缓存。 
沙盒缓存的目录分层 ，个人建议是在每个用户根据自己的userID在Cache中创建文件夹，该文件夹目录下创建每个会话的文件夹。 
这样做的好处在于 ， 当你需要删除聊天列表会话或者清空聊天记录 ，或者app进行内存清理时 ，便于找到该会话的所有缓存。大致的目录结构如下 
../Cache/userID(当前用户ID)/toUserID(某个群或者单聊对象)/…（图片，语音等缓存）

关于消息分发

全局咱们设定了一个ChatHandler单例，用于处理TCP的相关逻辑 。那么当TCP推送过来消息时，我该将这些消息发给谁？谁注册成为我的代理，我就发给谁。 
ChatHandler单例为全局的，并且生命周期为整个app运行期间不会销毁。在ChatHandler中引用一个数组 ，该数组中存放所有注册成为需要收取消息的代理，当每来一条消息时，遍历该数组，并向所有的代理推送该条消息.

聊天UI的搭建

1. 聊天列表UI（微信首页）

这个页面没有太多可说的 ， 一个tableView即可搞定 。需要注意的是 ，每次收到消息时，都需要将该消息置顶 。每次进入程序时，拉取chatlist表存储的每个会话的最后一条聊天记录进行展示 。

2. 会话页面

该页面tableView或者collectionView均可实现 ，看个人喜好 。这里是我用的是tableView . 
根据消息类型大致分为普通消息 ，语音消息 ，图片消息 ，文件消息 ，视频消息 ，提示语消息（以上为打招呼内容，xxx已加入群，xxx撤回了一条消息等）这几种 ，固cell的注册差不多为5种类型，每种消息对应一种消息。 
视频消息和图片消息cell可以复用 。 
不建议使用过少的cell类型 ，首先是逻辑太多 ，不便于处理 。其次是效率并不高。

发送消息

1. 文本消息/表情消息

直接调用咱们封装好的ChatHandler的sendMessage方法即可 ， 发送消息时 ，需要存入或者更新chatlist和chatinfo两张表。若是未连接或者发送超时 ，需要重新更新数据库存储的发送成功与否状态 ，同时更新内存数据源 ，刷新该条消息展示即可。 
若是表情消息 ，传输过程也是以文本的方式传输 ，比如一个大笑的表情 ，可以定义为[大笑] ，当然规则自己可以和安卓端web端协商，本地根据plist文件和表情包匹配进行图文混排展示即可 。 
https://github.com/coderMyy/MYCoreTextLabel ，图文混排地址 ， 如果觉得有用 ， 请star一下 ，好人一生平安

2. 语音消息

语音消息需要注意的是 ，多和安卓端或者web端沟通 ，找到一个大家都可以接受的格式 ，转码时使用同一种格式，避免某些格式其他端无法播放，个人建议Mp3格式即可。 
同时，语音也需要做相应的降噪 ，压缩等操作。 
发送语音大约有两种方式 。 
一是先对该条语音进行本地缓存 ， 然后全部内容均通过TCP传输并携带该条语音的相关信息，例如时长，大小等信息，具体的你得测试一条压缩后的语音体积有多大，若是过大，则需要进行分割然后以消息的方法时发送。接收语音时也进行拼接。同时发送或接收时，对chatinfo和chatlist表和内存数据源进行更新 ，超时或者失败再次更新。 
二是先对该条语音进行本地缓存 ， 语音内容使用http传输，传输到服务器生成相应的id ，获取该id再附带该条语音的相关信息 ，以TCP方式发送给对方，当对方收到该条消息时，先去下载该条信息，并根据该条语音的相关信息进行展示。同时发送或接收时，对chatinfo和chatlist表和内存数据源进行更新 ，超时或者失败再次更新。

3. 图片消息

图片消息需要注意是 ，通过拍照或者相册中选择的图片应当分成两种大小 ， 一种是压缩得非常小的状态，一种是图片本身的大小状态。 聊天页面展示的 ，仅仅是小图 ，只有点击查看时才去加载大图。这样做的目的在于提高发送和接收的效率。 
同样发送图片也有两种方式 。 
一是先对该图片进行本地缓存 ， 然后全部内容均通过TCP传输 ，并携带该图片的相关信息 ，例如图片的大小 ，名字 ，宽高比等信息 。同样如果过大也需要进行分割传输。同时发送或接收时，对chatinfo和chatlist表和内存数据源进行更新 ，超时或者失败再次更新。 
二是先对该图片进行本地缓存 ， 然后通过http传输到服务器 ，成功后发送TCP消息 ，并携带相关消息 。接收方根据你该条图片信息进行UI布局。同时发送或接收时，对chatinfo和chatlist表和内存数据源进行更新 ，超时或者失败再次更新。

4. 视频消息

视频消息值得注意的是 ，小的视频没有太多异议，跟图片消息的规则差不多 。只是当你从拍照或者相册中获取到视频时，第一时间要获取到视频第一帧用于展示 ，然后再发送视频的内容。大的视频 ，有个问题就是当你选择一个视频时，首先做的是缓存到本地，在那一瞬间 ，可能会出现内存峰值问题 。只要不是过大的视频 ，现在的手机硬件配置完全可以接受的。而上传采取分段式读取，这个问题并不会影响太多。

视频消息我个人建议是走http上传比较好 ，因为内容一般偏大 。TCP部分仅需要传输该视频封面以及相关信息比如时长，下载地址等相关信息即可。接收方可以通过视频大小判断，如果是小视频可以接收到后默认自动下载，自动播放 ，大的视频则只展示封面，只有当用户手动点击时才去加载。具体的还是需要根据项目本身的设计而定。

5. 文件消息

文件方面 ，iOS端并不如安卓端那种可操作性强 ,安卓可以完全获取到用户里的所有文件，iOS则有保护机制。通常iOS端发送的文件 ，基本上仅仅局限于当前app自己缓存的一些文件 ，原理跟发送图片类似。

6. 撤回消息

撤回消息也是消息内容的一种类型 。例如 A给B发送了一条消息 “你好” ，服务端会对该条消息生成一个messageID ，接收方收到该条消息的messageID和发送方的该条消息messageID一致。如果发送端需要撤回该条消息 ，仅仅需要拿到该条消息messageID ，设置一下消息类型 ，发送给对方 ，当收到撤回消息的成功回执(repealReceipt)时，移除该会话的内存数据源和更新chatinfo和chatlist表 ，并加载提示类型的cell进行展示例如“你撤回了一条消息”即可。接收方收到撤回消息时 ，同样移除内存数据源 ，并对数据库进行更新 ，再加载提示类型的cell例如“张三撤回了一条消息”即可。

7. 提示语消息

提示语消息通常来说是服务器做的事情更多 ，除了撤回消息是需要客户端自己做的事情并不多。 
当有人退出群 ，或者自己被群主踢掉 ，时服务端推送一条提示语消息类型，并附带内容，客户端仅仅需要做展示即可，例如“张三已经加入群聊”，“以上为打招呼内容”，“你已被踢出该群”等。 
当然 ，撤回消息也可以这样实现 ，这样提示消息类型逻辑就相当统一，不会显得很乱 。把主要逻辑交于了服务端来实现。

消息删除

这里需要注意的一点是 ，类似微信的长按消息操作 ，我采用的是UIMenuController来做的 ，实际上有一点问题 ，就是第一响应者的问题 ，想要展示该menu ，必须将该条消息的cell置为第一响应者，然后底部的键盘失去第一响应者，会降下去 。所以该长按出现menu最好还是自定义 ，根据计算相对frame进行布局较好，自定义程度也更好。

消息删除大概分为删除该条消息 ，删除该会话 ，清空聊天记录几种 
删除该条消息仅仅需要移除本地数据源的消息模型 ，更新chatlist和chatinfo表即可。 
删除该会话需要移除chatlist和chatinfo该会话对应的列 ，并根据当前登录用户的userID和该会话的toUserID或者groupID移除沙盒中的缓存。 
清空聊天记录，需要更新chatlist表最后一条消息内容 ，删除chatinfo表，并删除该会话的沙盒缓存.

消息拷贝

这个不用多说 ，一两句话搞定

消息转发

拿到该条消息的模型 ，并创建新的消息 ，把内容赋值到新消息 ，然后选择人或者群发送即可。

值得注意的是 ，如果是转发图片或者视频 ，本地沙盒中的缓存也应当copy一份到转发对象所对应的沙盒目录缓存中 ，不能和被转发消息的会话共用一张图或者视频 。因为比如 ：A给B发了一张图 ，A把该图转发给了C ，A移除掉A和B的会话 ，那么如果是共用一张图的话 ，A和C的会话中就再也无法找到这张图进行展示了。

重新发送

这个没有什么好说的。

标记已读

功能实现比较简单 ，仅仅需要修改数据源和数据库的该条会话的未读数（unreadCount），刷新UI即可。

以下为发送消息具体大致的实现步骤

文本/表情消息 ：

方式一： 输入 ->发送 -> 消息加入聊天数据源 -> 更新数据库 -> 展示到聊天会话中 -> 调用TCP发送到服务器（若超时，更新聊天数据源，更新数据库 ，刷新聊天UI） ->收到服务器成功回执(normalReceipt) ->修改数据源该条消息发送状态(isSend) -> 更新数据库

方式二： 输入 ->发送 -> 消息加入聊天数据源 -> 展示到聊天会话中 -> 调用TCP发送到服务器（若超时，更新聊天数据源，刷新聊天UI） ->收到服务器成功回执(normalReceipt) ->修改数据源该条消息发送状态(isSend) ->退出app或者页面时 ，更新数据库

语音消息 ：（这里以http上传，TCP原理一致）

方式一： 长按录制 ->压缩转格式 -> 缓存到沙盒 -> 更新数据库->展示到聊天会话中，展示转圈发送中状态 -> 调用http分段式上传(若失败，刷新UI展示) ->调用TCP发送该语音消息相关信息（若超时，刷新聊天UI） ->收到服务器成功回执 -> 修改数据源该条消息发送状态(isSend) ->修改数据源该条消息发送状态(isSend)-> 更新数据库-> 刷新聊天会话中该条消息UI

方式二： 长按录制 ->压缩转格式 -> 缓存到沙盒 ->展示到聊天会话中，展示转圈发送中状态 -> 调用http分段式上传（若失败，更新聊天数据源，刷新UI展示） ->调用TCP发送该语音消息相关信息（若超时,更新聊天数据源，刷新聊天UI） ->收到服务器成功回执 -> 修改数据源该条消息发送状态(isSend -> 刷新聊天会话中该条消息UI - >退出程序或者页面时进行数据库更新

图片消息 ：（两种考虑，一是展示和http上传均为同一张图 ，二是展示使用压缩更小的图，http上传使用选择的真实图片，想要做到精致，方法二更为可靠）

方式一： 打开相册选择图片 ->获取图片相关信息，大小，名称等，根据用户是否选择原图，考虑是否压缩 ->缓存到沙盒 -> 更新数据库 ->展示到聊天会话中，根据上传显示进度 ->http分段式上传(若失败，更新聊天数据,更新数据库,刷新聊天UI) ->调用TCP发送该图片消息相关信息（若超时，更新聊天数据源，更新数据库,刷新聊天UI）->收到服务器成功回执 -> 修改数据源该条消息发送状态(isSend) ->更新数据库 -> 刷新聊天会话中该条消息UI

方式二：打开相册选择图片 ->获取图片相关信息，大小，名称等，根据用户是否选择原图，考虑是否压缩 ->缓存到沙盒 ->展示到聊天会话中，根据上传显示进度 ->http分段式上传(若失败，更细聊天数据源 ，刷新聊天UI) ->调用TCP发送该图片消息相关信息（若超时，更新聊天数据源 ，刷新聊天UI）->收到服务器成功回执 -> 修改数据源该条消息发送状态(isSend) -> 刷新聊天会话中该条消息UI ->退出程序或者离开页面更新数据库

视频消息：需要注意的是 ,不要太过于频繁的去刷新进度 , 最好控制在2秒刷新一次即可

方式一：打开相册或者开启相机录制 -> 压缩转格式 ->获取视频相关信息，第一帧图片，时长，名称，大小等信息 ->缓存到沙盒 ->更新数据库 ->第一帧图展示到聊天会话中，根据上传显示进度 ->http分段式上传(若失败，更新聊天数据,更新数据库,刷新聊天UI) ->调用TCP发送该视频消息相关信息（若超时，更新聊天数据源，更新数据库,刷新聊天UI）->收到服务器成功回执 -> 修改数据源该条消息发送状态(isSend) ->更新数据库 -> 刷新聊天会话中该条消息UI

方式二：打开相册或者开启相机录制 ->压缩转格式 ->获取视频相关信息，第一帧图片，时长，名称，大小等信息 ->缓存到沙盒 ->第一帧图展示到聊天会话中，根据上传显示进度 ->http分段式上传(若失败，更细聊天数据源 ，刷新聊天UI) ->调用TCP发送该视频消息相关信息（若超时，更新聊天数据源 ，刷新聊天UI）->收到服务器成功回执 -> 修改数据源该条消息发送状态(isSend) -> 刷新聊天会话中该条消息UI ->退出程序或者离开页面更新数据库

文件消息： 
跟上述一致 ，需要注意的是，如果要实现该功能 ，接收到的文件需要在沙盒中单独开辟缓存。比如接收到web端或者安卓端的文件

消息丢失问题

消息为什么会丢失 ？

最主要原因应该归结于服务器对客户端的网络判断不准确。尽管客户端已经和服务端建立了心跳验证 ， 但是心跳始终是有间隔的，且TCP的连接中断也是有延迟的。例如，在此时我向服务器发送了一次心跳，然后网络失去了连接，或者网络信号不好。服务器接收到了该心跳 ，服务器认为客户端是处于连接状态的，向我推送了某个人向我发送的消息 ，然而此时我却不能收到消息，所以出现了消息丢失的情况。

解决办法 ：客户端向服务端发送消息，服务端会给客户端返回一个回执，告知该条消息已经发送成功。所以，客户端有必要在收到消息时，也向服务端发送一个回执，告知服务端成功收到了该条消息。而客户端，默认收到的所有消息都是离线的，只有收到客户端的接收消息的成功回执后，才会移除掉该离线消息缓存，否则将会把该条消息以离线消息方式推送。离线消息后面会做解释。此时的双向回执，可以把消息丢失概率降到非常低。

消息乱序问题

消息为什么会乱序 ？

客户端发送消息，该消息会默认赋值当前时间戳 ，收到安卓端或者web端发来的消息时，该时间戳是安卓和web端获取，这样就可能会出现时间戳的误差情况。比如当前聊天展示顺序并没有什么问题，因为展示是收到一条展示一条。但是当退出页面重新进入时，如果拉取数据库是根据时间戳的降序拉取 ，那么就很容易出现混乱。 
解决办法 ：表结构设置自增ID ，消息的顺序展示以入库顺序为准 ，拉取数据库获取消息记录时，根据自增ID降序拉取 。这样就解决了乱序问题 ，至少保证了，展示的消息顺序和我聊天时的一样。尽管时间戳可能并不一样是按照严谨的降序排列的。

离线消息

进入后台，接收消息提醒:

解决方式要么采用极光推送进行解决 ，要么让自己服务器接苹果的服务器也行。毕竟极光只是作为一个中间者，最终都是通过苹果服务器推送到每个手机。

进入程序加载离线消息：此处需要注意的是，若服务器仅仅是把每条消息逐个推送过来，那么客户端会出现一些小问题，比如角标数为每次增加1，最后一条消息不断更新 ，直到离线消息接收到完毕，造成一种不好的体验。

解决办法：离线消息服务端全部进行拼接或者以jsonArray方式，并协议分割方式，客户端收到后仅需仅需切割，直接在角标上进行总数的相加，并直接更新最后一条消息即可。亦或者，设置包头信息，告知每条消息长度，切割方式等。

版本兼容性问题处理

其实 , 做IM遇到最麻烦的问题之一 , 就应当是版本兼容问题 . 即时通讯的功能点有很多 , 项目不可能一期所有的功能全部做完 , 那么就会涉及到新老版本兼容的问题 . 当然如果服务端经验足够丰富 , 版本兼容的问题可以交于服务端来完成 , 客户端并不需要做太多额外的事情 . 如果是并行开发 , 服务端思路不够长远 ,或者产品需求变更频繁且比较大.那么客户端也需要做一些相应的版本兼容问题 . 处理版本兼容问题并不难 , 主要问题在于当增加一个新功能时 , 服务端或许会推送过来更多的字段 , 而老版本的项目数据库如果没有预留足够的字段 , 就涉及到了数据库升级 . 而当收到高版本新功能的消息时 , 客户端也应当对该消息做相应的处理 . 例如,老版本的app不支持消息撤回 , 而新版本支持消息撤回 , 当新版本发送消息撤回时 , 老版本可以拦截到这条未知的消息类型 , 做相应的处理 , 比如替换成一条提示”该版本暂不支持,请前往appstore下载新版本”等. 而当必要时 , 如果整个IM结构没有经过深思熟虑 , 还可能会涉及到强制升级。

以上仅为大体的思路 , 实际上搭建IM , 更多的难点在于逻辑的处理和各种细节问题 . 比如数据库,本地缓存,和服务端的通信协议,和安卓端私下通信协议.以及聊天UI的细节处理,例如聊天背景实时拉高,图文混排等等一系列麻烦的事.没办法写到很详细 ,都需要自己仔细的去思考.难度并不算很大,只是比较费心。
