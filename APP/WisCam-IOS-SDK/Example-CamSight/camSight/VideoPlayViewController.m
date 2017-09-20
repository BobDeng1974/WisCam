#import "VideoPlayViewController.h"
#import "AppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <netdb.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import "MBProgressHUD.h"
#import "HttpRequest.h"
#import "Scanner.h"
#import "WisView.h"
#import "MediaViewController.h"
#include <ifaddrs.h>
#include <sys/socket.h>
#include <net/if.h>
#import "AlbumObject.h"
#import "CommanParameter.h"
#import "LoadingView.h"

Scanner *_deviceScan;

NSString* _userid = nil;
NSString* _userip = nil;
NSString* _username = nil;
NSString* _userpassword = nil;

static NSTimer* CheckVideoPlay = nil;
int scanCount=0;
int playCount=0;
int _width=1280;
int _height=720;

WisView *_videoView;
NSMutableArray *photo_timesamp;
NSMutableArray *video_timesamp;
NSString *video_type=@"mpeg4";
//NSString *video_type=@"h264";
NSString *album_name=@"WISCAM";
bool audioisEnable = NO;
enum ButtonEnable{
    Enable,
    Unable
};
static enum ButtonEnable SavePictureEnable;
static enum ButtonEnable RecordVideoEnable;
NSTimer* timer;

@interface VideoPlayViewController()
@property (nonatomic,strong) UIImage* DecodeOutImage;
@property  bool videoisplaying;
@end


@implementation VideoPlayViewController
{
    LoadingView *_loadingView;
    AlbumObject *_albumObject;
    BOOL _isPlaying;
    NSString *_url;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    NSLog(@"===video===");
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self view_init];
    _albumObject=[[AlbumObject alloc]init];
    [_albumObject delegate:self];
    _url=[self Get_Strings:@"PLAYURL"];
    
    _userip = @"192.168.100.1";
    _username = @"admin";
    _userpassword = @"admin";
    audioisEnable=NO;
    SavePictureEnable = Unable;
    RecordVideoEnable = Unable;
    _isExit=NO;
    self.videoisplaying = NO;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    _isExit=NO;
    if (play_success==NO){
        dispatch_async(dispatch_get_main_queue(),^ {
            [_loadingView setLoadingShow:YES :@"CONNECTING..."];
        });
        [self disableControl];
        if (_isPlayurl) {
            [_videoView play:_url useTcp:NO];
            [_videoView sound:audioisEnable];
            self.videoisplaying = YES;
        }
        else{
            _deviceScan = [[Scanner alloc] init];
            [self scanDevice];
        }
    }
    CheckVideoPlay = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(CheckVideoPlayTimer) userInfo:nil repeats:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        scanCount=0;
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateUI) userInfo:nil repeats:YES];
    });
}

-(void)back{
    NSLog(@"back");
    if (timer) {
        [timer invalidate];
        timer = nil;
    }

    if (play_success) {
        [_videoView stop];
        NSLog(@"stop play");
    }
    self.videoisplaying = NO;
    play_success=NO;
    dispatch_async(dispatch_get_main_queue(),^ {
        [_loadingView setLoadingShow:NO :@""];
    });
    [CheckVideoPlay invalidate];
    CheckVideoPlay = nil;
    [self.navigationController popViewControllerAnimated:YES];
}
bool _isExit=NO;
- (void)videoBackClick{
    _isExit=YES;
    [self back];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    _isExit=YES;
    [_loadingView setLoadingShow:NO :@""];
}

- (void) view_init
{
    CGFloat H=self.view.frame.size.height;
    CGFloat W=self.view.frame.size.width;
    CGFloat temp=0;
    if (H>W) {
        temp=H;
        H=W;
        W=temp;
    }
    //视频显示view
    _videoView.userInteractionEnabled = YES;
    
    _videoView = [[WisView alloc] initWithFrame:CGRectMake(0, 0, W, H)];
    NSLog(@"W=%f,H=%f",W,H);
    [_videoView setView1Frame:CGRectMake(0, 0, W, H)];

//    if (self.view.frame.size.height<self.view.frame.size.width*_height/_width) {
//        [_videoView setView1Frame:CGRectMake((self.view.frame.size.width-self.view.frame.size.height*_width/_height)*0.5, 0, self.view.frame.size.height*_width/_height, self.view.frame.size.height)];
//    }
//    else{
//        [_videoView setView1Frame:CGRectMake(0, (self.view.frame.size.height-self.view.frame.size.width*_height/_width)*0.5, self.view.frame.size.width, self.view.frame.size.width*_height/_width)];
//    }
    _videoView.center=self.view.center;
    
    _videoView.backgroundColor = [UIColor blackColor];
    [_videoView set_log_level:4];
    [_videoView startGetYUVData:YES];
    [_videoView delegate:self];
    [self.view addSubview:_videoView];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchesImage)];
    [_videoView addGestureRecognizer:singleTap];
    
    _loadingView = [[LoadingView alloc] initWithFrame:self.view.frame];
    [_loadingView setLoadingShow:NO :@""];
    [self.view addSubview:_loadingView];
    
    videoBack=[UIButton buttonWithType:UIButtonTypeCustom];
    videoBack.frame=CGRectMake(0, 0, viewH*44/view_fix_height, viewH*44/view_fix_height);
    [videoBack setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [videoBack addTarget:nil action:@selector(videoBackClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:videoBack];
    
    //拍照／录像等控制的view
    view_control= [[UIView alloc] initWithFrame:CGRectMake(0, viewH-viewH*66/view_fix_height, viewW,viewH*66/view_fix_height)];
    [view_control setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:view_control];
    
    button_savepicture = [[UIButton alloc]initWithFrame:CGRectMake(viewW*130/view_fix_width, 0, viewH*66/view_fix_height, viewH*66/view_fix_height)];
    [button_savepicture setBackgroundColor:[UIColor clearColor]];
    [button_savepicture addTarget:self action:@selector(button_savepicture:)  forControlEvents:UIControlEventTouchUpInside];
    [button_savepicture setImage:[UIImage imageNamed:@"photo_dis.png"] forState:UIControlStateNormal];
    [button_savepicture setImage:[UIImage imageNamed:@"photo_pre.png"] forState:UIControlStateHighlighted];
    [view_control addSubview:button_savepicture];
    
    button_recodevideo = [[UIButton alloc]initWithFrame:CGRectMake(viewW*244/view_fix_width, 0, viewH*66/view_fix_height, viewH*66/view_fix_height)];
    [button_recodevideo setBackgroundColor:[UIColor clearColor]];
    [button_recodevideo addTarget:self action:@selector(button_recodevideo:)  forControlEvents:UIControlEventTouchUpInside];
    [button_recodevideo setImage:[UIImage imageNamed:@"record_dis.png"] forState:UIControlStateNormal];
    [button_recodevideo setImage:[UIImage imageNamed:@"record_start_nor.png"] forState:UIControlStateHighlighted];
    [view_control addSubview:button_recodevideo];
    
    button_playback = [[UIButton alloc]initWithFrame:CGRectMake(viewW*358/view_fix_width, 0, viewH*66/view_fix_height, viewH*66/view_fix_height)];
    [button_playback setBackgroundColor:[UIColor clearColor]];
    [button_playback addTarget:self action:@selector(button_playback)  forControlEvents:UIControlEventTouchUpInside];
    [button_playback setImage:[UIImage imageNamed:@"album_nor.png"] forState:UIControlStateNormal];
    [button_playback setImage:[UIImage imageNamed:@"album_pre.png"] forState:UIControlStateHighlighted];
    [view_control addSubview:button_playback];
    
    button_voice = [[UIButton alloc]initWithFrame:CGRectMake(viewW*472/view_fix_width, 0, viewH*66/view_fix_height, viewH*66/view_fix_height)];
    [button_voice setBackgroundColor:[UIColor clearColor]];
    [button_voice addTarget:self action:@selector(button_voice)  forControlEvents:UIControlEventTouchUpInside];
    [button_voice setImage:[UIImage imageNamed:@"voice_nor"] forState:UIControlStateNormal];
    [view_control addSubview:button_voice];
    
    button_slider = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, H*0.1*30/104, H*0.1)];
    button_slider.center=CGPointMake(H*0.1*30*0.5/104-1, H*0.5);
    [button_slider setBackgroundColor:[UIColor clearColor]];
    [button_slider addTarget:self action:@selector(button_slider)  forControlEvents:UIControlEventTouchUpInside];
    [button_slider setImage:[UIImage imageNamed:@"panel_btn_open.png"] forState:UIControlStateNormal];
    [self.view addSubview:button_slider];
    button_slider.hidden=YES;
    
    CGFloat u_diff=5;
    view_slider= [[UIView alloc] initWithFrame:CGRectMake(button_slider.frame.origin.x+button_slider.frame.size.width,40*2+2+u_diff*3, H*0.2,40*4+4+u_diff*6)];
    view_slider.center=CGPointMake(button_slider.frame.origin.x+button_slider.frame.size.width+H*0.1, H*0.5);
    view_slider.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    [view_slider setBackgroundColor:[UIColor colorWithRed:0.078 green:0.106 blue:0.137 alpha:0.4]];
    [self.view addSubview:view_slider];

    UILabel *l1 = [[UILabel alloc]initWithFrame:CGRectMake(0, u_diff, self.view.frame.size.height*0.12, 40)];
    l1.text = @"CH_924";
    l1.center=CGPointMake(view_slider.frame.size.width/2, l1.frame.origin.y+l1.frame.size.height/2);
    l1.textColor = [UIColor whiteColor];
    l1.adjustsFontSizeToFitWidth = YES;
    l1.textAlignment=UITextAlignmentCenter;
    l1.numberOfLines = 1;
    l1.backgroundColor=[UIColor clearColor];
    [view_slider addSubview:l1];
    
    UILabel *line1=[[UILabel alloc]init];
    line1.frame=CGRectMake(0, l1.frame.size.height+l1.frame.origin.y+u_diff,l1.frame.size.width, 1);
    line1.center=CGPointMake(view_slider.frame.size.width/2, line1.frame.origin.y+line1.frame.size.height/2);
    line1.backgroundColor=[UIColor whiteColor];
    [view_slider addSubview:line1];
    
    UILabel *l2 = [[UILabel alloc]initWithFrame:CGRectMake(0, u_diff, self.view.frame.size.height*0.12, 40)];
    l2.text = @"CH_906";
    l2.center=CGPointMake(view_slider.frame.size.width/2, l1.frame.origin.y+l1.frame.size.height+l2.frame.origin.y+l2.frame.size.height/2);
    l2.textColor = [UIColor whiteColor];
    l2.adjustsFontSizeToFitWidth = YES;
    l2.textAlignment=UITextAlignmentCenter;
    l2.numberOfLines = 1;
    l2.backgroundColor=[UIColor clearColor];
    [view_slider addSubview:l2];
    
    UILabel *line2=[[UILabel alloc]init];
    line2.frame=CGRectMake(0, l2.frame.size.height+l2.frame.origin.y+u_diff,l2.frame.size.width, 1);
    line2.center=CGPointMake(view_slider.frame.size.width/2, line2.frame.origin.y+line2.frame.size.height/2);
    line2.backgroundColor=[UIColor whiteColor];
    [view_slider addSubview:line2];
    
    UILabel *l3 = [[UILabel alloc]initWithFrame:CGRectMake(0, u_diff, self.view.frame.size.height*0.12, 40)];
    l3.text = @"CH_912";
    l3.center=CGPointMake(view_slider.frame.size.width/2, l2.frame.origin.y+l2.frame.size.height+l3.frame.origin.y+l3.frame.size.height/2);
    l3.textColor = [UIColor whiteColor];
    l3.adjustsFontSizeToFitWidth = YES;
    l3.textAlignment=UITextAlignmentCenter;
    l3.numberOfLines = 1;
    l3.backgroundColor=[UIColor clearColor];
    [view_slider addSubview:l3];
    
    UILabel *line3=[[UILabel alloc]init];
    line3.frame=CGRectMake(0, l3.frame.size.height+l3.frame.origin.y+u_diff,l3.frame.size.width, 1);
    line3.center=CGPointMake(view_slider.frame.size.width/2, line3.frame.origin.y+line3.frame.size.height/2);
    line3.backgroundColor=[UIColor whiteColor];
    [view_slider addSubview:line3];

    UILabel *l4 = [[UILabel alloc]initWithFrame:CGRectMake(0, u_diff, self.view.frame.size.height*0.12, 40)];
    l4.text = @"CH_918";
    l4.center=CGPointMake(view_slider.frame.size.width/2, l3.frame.origin.y+l3.frame.size.height+l4.frame.origin.y+l4.frame.size.height/2);
    l4.textColor = [UIColor whiteColor];
    l4.adjustsFontSizeToFitWidth = YES;
    l4.textAlignment=UITextAlignmentCenter;
    l4.numberOfLines = 1;
    l4.backgroundColor=[UIColor clearColor];
    [view_slider addSubview:l4];
    
    UILabel *line4=[[UILabel alloc]init];
    line4.frame=CGRectMake(0, l4.frame.size.height+l4.frame.origin.y+u_diff,l4.frame.size.width, 1);
    line4.center=CGPointMake(view_slider.frame.size.width/2, line4.frame.origin.y+line4.frame.size.height/2);
    line4.backgroundColor=[UIColor whiteColor];
    [view_slider addSubview:line4];
    view_slider.hidden=YES;
}

- (void)GetYUVData:(int)width :(int)height
                  :(Byte*)yData :(Byte*)uData :(Byte*)vData
                  :(int)ySize :(int)uSize :(int)vSize
{
    _isPlaying=YES;
//    if ((_width==width)&&(_height==height)) {
//        return;
//    }
//    _width=width;
//    _height=height;
//    if (self.view.frame.size.height<self.view.frame.size.width*_height/_width) {
//        [_videoView setView1Frame:CGRectMake((self.view.frame.size.width-self.view.frame.size.height*_width/_height)*0.5, 0, self.view.frame.size.height*_width/_height, self.view.frame.size.height)];
//    }
//    else{
//        [_videoView setView1Frame:CGRectMake(0, (self.view.frame.size.height-self.view.frame.size.width*_height/_width)*0.5, self.view.frame.size.width, self.view.frame.size.width*_height/_width)];
//    }
    _videoView.center=self.view.center;
}

-(void)button_slider{
    if (view_slider.hidden) {
        [button_slider setImage:[UIImage imageNamed:@"panel_btn_close.png"] forState:UIControlStateNormal];
        view_slider.hidden=NO;
    }
    else{
        [button_slider setImage:[UIImage imageNamed:@"panel_btn_open.png"] forState:UIControlStateNormal];
        view_slider.hidden=YES;
    }
}

-(void)enableControl{
    button_playback.enabled=true;
    button_recodevideo.enabled=true;
    button_savepicture.enabled=true;
}

-(void)disableControl{
    //button_playback.enabled=false;
    button_recodevideo.enabled=false;
    button_savepicture.enabled=false;
}

-(void)button_voice{
    audioisEnable=!audioisEnable;
    if (audioisEnable) {
        [button_voice setImage:[UIImage imageNamed:@"voice_pre"] forState:UIControlStateNormal];
    }
    else{
        [button_voice setImage:[UIImage imageNamed:@"voice_nor"] forState:UIControlStateNormal];
    }
    [_videoView sound:audioisEnable];
}

-(void)button_playback{
    MediaViewController *v = [[MediaViewController alloc] init];
    [self.navigationController pushViewController: v animated:true];
}

-(void)touchesImage{
//    if (play_success) {
//        if (view_control.hidden == NO) {
//            view_control.hidden = YES;
//        }
//        else{
//            view_control.hidden = NO;
//        }
//    }
//    else{
//        [self back];
//    }
}


bool play_success=NO;
- (void)playSound:(NSString *)sourcePath
{
    //1.获得音效文件的全路径
    NSURL *url=[[NSBundle mainBundle]URLForResource:sourcePath      withExtension:nil];
    //2.加载音效文件，创建音效ID（SoundID,一个ID对应一个音效文件）
    SystemSoundID soundID=0;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);
    //3.播放音效文件
    //下面的两个函数都可以用来播放音效文件，第一个函数伴随有震动效果
    //AudioServicesPlayAlertSound(soundID);
    AudioServicesPlaySystemSound(soundID);
}

int VideoRecordTimerTick_s = 0;
int VideoRecordTimerTick_m = 0;
bool VideoRecordIsEnable = NO;
-(void)CheckVideoPlayTimer{
    if (RecordVideoEnable == Unable) {
        return;
    }
    VideoRecordTimerTick_s ++;
    if (VideoRecordTimerTick_s > 59) {
        VideoRecordTimerTick_m++;
        VideoRecordTimerTick_s = 0;
    }
    if (VideoRecordTimerTick_m > 59) {
        VideoRecordTimerTick_m = 0;
    }
    l_recodevideo.text = [NSString stringWithFormat:@"REC %.2d:%.2d",VideoRecordTimerTick_m,VideoRecordTimerTick_s];
}

- (void)button_savepicture:(id)sender {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [_albumObject createAlbumInPhoneAlbum:album_name];
        [_albumObject getPathForRecord:album_name];
    });
    [self playSound:@"shutter.mp3"];
    [_videoView take_photo];
}

- (NSString *)stringFromDate:(NSDate *)date
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

NSString *Videoname;
NSString *imageDir;
- (void)button_recodevideo:(id)sender {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [_albumObject createAlbumInPhoneAlbum:album_name];
        [_albumObject getPathForRecord:album_name];
    });
    if (RecordVideoEnable == Unable) {
        [self playSound:@"begin_record.mp3"];
        RecordVideoEnable = Enable;
        [button_recodevideo setImage:[UIImage imageNamed:@"record_start_nor.png"] forState:UIControlStateNormal];
        long recordTime = [[NSDate date] timeIntervalSince1970];
        NSString *timesamp=[NSString stringWithFormat:@"%ld",recordTime];
        NSLog(@"video_timesamp:%@",timesamp);
        video_timesamp=[self Get_Paths:@"video_flag"];
        if (video_timesamp==nil) {
            video_timesamp=[[NSMutableArray alloc]init];
        }
        NSMutableArray *mutaArray = [[NSMutableArray alloc] init];
        [mutaArray addObjectsFromArray:video_timesamp];
        [mutaArray addObject:timesamp];
        [self Save_Paths:mutaArray :@"video_flag"];
        NSString *curdate = [self stringFromDate: [NSDate date]];
        curdate = [curdate stringByAppendingString:@".mov"];
        //record video temp path
        
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:curdate];
        path = [path stringByReplacingOccurrencesOfString:@"Caches" withString:@"WISCAM/"];
        NSLog(@"path==>%@",path);
        
        // 照片原图路径
        path=[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"OriginalPhotoImages"];
        NSLog(@"OriginalPhotoImages==>%@",path);
        
        // 视频URL路径
        path=[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"VideoURL"];
        NSLog(@"VideoURL==>%@",path);
        
        // caches路径
        path=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSLog(@"Originalpath==>%@",path);
        
        //path=[path stringByAppendingPathComponent:@"/CAM SIGHT/"];
        //path=[path stringByAppendingPathComponent:curdate];
        path = [NSTemporaryDirectory() stringByAppendingPathComponent:curdate];
        NSLog(@"path==>%@",path);
        [_videoView begin_record:0];//AE9198F4-9F2E-48A3-9C35-59A6121C2EFF
        //[_videoView begin_record2:path];
        //[_albumObject saveVideoToAlbum:path albumName:@"CAM SIGHT"];
        VideoRecordTimerTick_s = 0;
        VideoRecordTimerTick_m = 0;
        l_recodevideo = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width -10-self.view.frame.size.height*0.2, 15, self.view.frame.size.height*0.2, 50)];
        l_recodevideo.text = @"REC 00:00";
        //l_recodevideo.font = [UIFont boldSystemFontOfSize:20];
        l_recodevideo.textAlignment=UITextAlignmentRight;
        l_recodevideo.textColor = [UIColor redColor];
        l_recodevideo.adjustsFontSizeToFitWidth = YES;
        l_recodevideo.numberOfLines = 1;
        l_recodevideo.backgroundColor=[UIColor clearColor]; //可以去掉背景色
        [_videoView addSubview:l_recodevideo];
    }
    else{
        [self playSound:@"end_record.mp3"];
        [self showAllTextDialog:@"Save video to album success"];
        RecordVideoEnable = Unable;
        [button_recodevideo setImage:[UIImage imageNamed:@"record_stop_nor.png"] forState:UIControlStateNormal];
        [l_recodevideo removeFromSuperview];
        [_videoView end_record];
    }
}

- (void)scanDevice
{
    if (_isExit) {
        return;
    }
    [_loadingView setLoadingShow:YES :@"CONNECTING..."];
    [NSThread detachNewThreadSelector:@selector(scanDeviceTask) toTarget:self withObject:nil];
}

- (void)scanDeviceTask
{
    Scanner *result = [_deviceScan ScanDeviceWithTime:3.0f];
    [self performSelectorOnMainThread:@selector(scanDeviceOver:) withObject:result waitUntilDone:NO];
}

- (void)scanDeviceOver:(Scanner *)result;
{
    if (result.Device_ID_Arr.count > 0) {
        //使用扫描到的第一个设备
        NSString *url = [NSString stringWithFormat:@"rtsp://admin:admin@%@/cam1/%@", [result.Device_IP_Arr objectAtIndex:0],video_type];
        _userip = [result.Device_IP_Arr objectAtIndex:0];
        _userid = [result.Device_ID_Arr objectAtIndex:0];
        dispatch_async(dispatch_get_main_queue(),^ {
            [self showAllTextDialog:_userip];
        });
        
        NSLog(@"user ifo:id=%@ username=%@ userpassword=%@",_userid,_username,_userpassword);
        NSLog(@"start play==%@",url);
        [_videoView play:url useTcp:NO];
        [_videoView sound:audioisEnable];
        self.videoisplaying = YES;
    }
    else
    {
        [self scanDevice];
    }
}


#pragma mark -------------------
#pragma mark LX520Delegate
- (void)state_changed:(int)state
{
    NSLog(@"state = %d", state);
    switch (state) {
        case 0: //STATE_IDLE
        {
            play_success = NO;
            break;
        }
        case 1: //STATE_PREPARING
        {
            play_success = NO;
            break;
        }
        case 2: //STATE_PLAYING
        {
            play_success = YES;
            self.videoisplaying=YES;
            [self enableControl];
            dispatch_async(dispatch_get_main_queue(),^ {
                [_loadingView setLoadingShow:NO :@""];
                [button_savepicture setImage:[UIImage imageNamed:@"photo_nor.png"] forState:UIControlStateNormal];
                [button_recodevideo setImage:[UIImage imageNamed:@"record_start_nor.png"] forState:UIControlStateNormal];
            });
            break;
        }
        case 3: //STATE_STOPPED
        {
            play_success = NO;
            break;
        }
            
        default:
            break;
    }
}

- (void)video_info:(NSString *)codecName codecLongName:(NSString *)codecLongName
{
    
}

- (void)audio_info:(NSString *)codecName codecLongName:(NSString *)codecLongName sampleRate:(int)sampleRate channels:(int)channels
{
    
}

- (void)Save_Paths:(NSMutableArray *)Timesamp :(NSString *)key
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:Timesamp forKey:key];
    [defaults synchronize];
}

- (NSMutableArray *)Get_Paths:(NSString *)key
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSMutableArray *value=[defaults objectForKey:key];
    return value;
}

- (NSString *)Get_Strings:(NSString *)key
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *value=[defaults objectForKey:key];
    return value;
}

- (void)take_photo:(UIImage *)image
{
    //获取当前时间戳
    long recordTime = [[NSDate date] timeIntervalSince1970];
    NSString *timesamp=[NSString stringWithFormat:@"%ld",recordTime];
    NSLog(@"photo_timesamp:%@",timesamp);
    photo_timesamp=[self Get_Paths:@"photo_flag"];
    if (photo_timesamp==nil) {
        photo_timesamp=[[NSMutableArray alloc]init];
    }
    NSMutableArray *mutaArray = [[NSMutableArray alloc] init];
    [mutaArray addObjectsFromArray:photo_timesamp];
    [mutaArray addObject:timesamp];
    [self Save_Paths:mutaArray :@"photo_flag"];
    //UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    [_albumObject saveImageToAlbum:image albumName:album_name];
}

//拍照回调
- (void)saveImageToAlbum:(BOOL)success{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (success) {
            [self showAllTextDialog:@"Save photo to album success"];
        }
        else{
            [self showAllTextDialog:@"Save photo to album failed"];
        }
    });
}

//拍照回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(NSDictionary  *)contextInfo
{
    [self showAllTextDialog:@"Save photo to album success"];
}

-(void)updateUI{
    if (self.videoisplaying ==NO) {
        if (scanCount>5) {
            [_loadingView setLoadingShow:YES :@"NO DEVICE FOUND!"];
            scanCount=0;
        }
        
    }
    else{
        if (play_success ==NO){
            [_loadingView setLoadingShow:YES :@"NO VIDEO,PLEASE CHECK VIDEO SOURCE..."];
        }
    }
    
    if (_isPlaying) {
        playCount=0;
    }
    else{
        playCount++;
        if (playCount>5) {
            [_videoView stop];
            play_success=NO;
//            dispatch_async(dispatch_get_main_queue(),^ {
//                ActivityIndicatorView.hidden=YES;
//                l_waittime.text = @"CONNECTING...";
//                l_waittime.hidden=NO;
//            });
            NSString *url = [NSString stringWithFormat:@"rtsp://admin:admin@%@/cam1/%@", _userip,video_type];
            [_videoView play:url useTcp:NO];
            [_videoView sound:audioisEnable];
            playCount=0;
        }
    }
    _isPlaying=NO;
    
    if (play_success) {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            
//            int netFlow = [self checkNetworkflow];
//            int flow=(int)(netFlow/1024);
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (flow>0) {
//                    if(flow<20){
//                        [self stopActivityIndicatorView];
//                        l_waittime.text=@"NO VIDEO,PLEASE CHECK VIDEO SOURCE...";
//                        l_waittime.hidden=NO;
//                    }else{
//                        l_waittime.hidden=YES;
//                        [self stopActivityIndicatorView];
//                    }
//                }
//            });
//        });
    }
    scanCount++;
}

-(int)checkNetworkflow{
    struct ifaddrs *ifa_list = 0, *ifa;
    if (getifaddrs(&ifa_list) == -1)
    {
        return 0;
    }
    uint32_t iBytes     = 0;
    uint32_t oBytes     = 0;
    uint32_t allFlow    = 0;
    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next)
    {
        if (AF_LINK != ifa->ifa_addr->sa_family)
            continue;
        if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING))
            continue;
        if (ifa->ifa_data == 0)
            continue;
        // Not a loopback device.
        // network flow
        if (strncmp(ifa->ifa_name, "lo", 2))
        {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            iBytes += if_data->ifi_ibytes;
            oBytes += if_data->ifi_obytes;
            allFlow = iBytes + oBytes;
        }
    }
    freeifaddrs(ifa_list);
    static int lastFlow = -1;
    static int flow = 0;
    if (lastFlow == -1) {
        lastFlow = allFlow;
    }
    flow = allFlow - lastFlow;
    NSString *networkFlow      = [self bytesToAvaiUnit:flow];
    lastFlow = allFlow;
    //    NSLog(@"networkFlow==%@",networkFlow);
    return flow;
}

-(NSString *)bytesToAvaiUnit:(int)bytes
{
    if(bytes < 1024)		// B
    {
        return [NSString stringWithFormat:@"%dB", bytes];
    }
    else if(bytes >= 1024 && bytes < 1024 * 1024)	// KB
    {
        return [NSString stringWithFormat:@"%.1fKB", (double)bytes / 1024];
    }
    else if(bytes >= 1024 * 1024 && bytes < 1024 * 1024 * 1024)	// MB
    {
        return [NSString stringWithFormat:@"%.2fMB", (double)bytes / (1024 * 1024)];
    }
    else	// GB
    {
        return [NSString stringWithFormat:@"%.3fGB", (double)bytes / (1024 * 1024 * 1024)];
    }
}

#pragma mark-- Toast显示示例
-(void)showAllTextDialog:(NSString *)str{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = str;
    HUD.mode = MBProgressHUDModeText;
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [HUD removeFromSuperview];
        //[HUD release];
        //HUD = nil;
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
//
- (BOOL)prefersStatusBarHidden//for iOS7.0
{
    return YES;
}

@end
