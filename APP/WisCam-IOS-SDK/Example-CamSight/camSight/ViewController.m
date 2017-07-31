#import "ViewController.h"
#import "VideoPlayViewController.h"
#import "MBProgressHUD.h"
#import "CommanParameter.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    imageBg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home.png"]];
    imageBg.frame = CGRectMake(0, 0, viewW, viewH);
    imageBg.contentMode=UIViewContentModeScaleToFill;
    [self.view addSubview:imageBg];
    
    urlView=[[UIView alloc]init];
    urlView.frame=CGRectMake(0, 0, viewW, viewH*50/view_fix_height);
    urlView.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
    urlView.userInteractionEnabled=YES;
    [self.view addSubview:urlView];
    
    urlField = [[UITextField alloc] initWithFrame:CGRectMake(viewW*16/view_fix_width, viewH*10/view_fix_height, viewW*553/view_fix_width, viewH*30/view_fix_height)];
    urlField.placeholder = @"Please input rtsp url";
    urlField.backgroundColor = [UIColor whiteColor];
    urlField.textColor = [UIColor blackColor];
    urlField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewW*10/view_fix_width, 0)];
    urlField.leftViewMode = UITextFieldViewModeAlways;
    [[urlField layer]setCornerRadius:6];
    urlField.delegate = self;
    urlField.clearButtonMode=UITextFieldViewModeWhileEditing;
    urlField.textAlignment=UITextAlignmentLeft;
    [urlView addSubview:urlField];
    urlField.text=[self Get_Paths:@"PLAYURL"];
    
    btnPlayUrl=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnPlayUrl.backgroundColor=[UIColor whiteColor];
    [[btnPlayUrl layer]setCornerRadius:6];
    btnPlayUrl.frame=CGRectMake(viewW*585/view_fix_width, viewH*10/view_fix_height, viewW*66/view_fix_width, viewH*30/view_fix_height);
    [btnPlayUrl setTitle:@"Play" forState:UIControlStateNormal];
    btnPlayUrl.backgroundColor=[UIColor colorWithRed:42/255.0 green:167/255.0 blue:230/255.0 alpha:1.0];
    [btnPlayUrl setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnPlayUrl setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [btnPlayUrl addTarget:nil action:@selector(btnPlayUrlClick) forControlEvents:UIControlEventTouchUpInside];
    [urlView  addSubview:btnPlayUrl];
    urlView.hidden=YES;
    
    btnShowView=[UIButton buttonWithType:UIButtonTypeCustom];
    btnShowView.frame=CGRectMake(viewW-viewW*60/view_fix_width, viewH*20/view_fix_height, viewH*44/view_fix_height, viewH*44/view_fix_height);
    [btnShowView setImage:[UIImage imageNamed:@"edit_img.png"] forState:UIControlStateNormal];
    [btnShowView addTarget:nil action:@selector(_btnShowViewClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:btnShowView];
    
    line=[[UIView alloc]init];
    line.frame=CGRectMake(0, 0, 1, viewH*20/view_fix_height);
    line.center=CGPointMake(btnShowView.center.x, line.center.y);
    line.backgroundColor=[UIColor whiteColor];
    [self.view  addSubview:line];
    
    btnPlay=[UIButton buttonWithType:UIButtonTypeCustom];
    btnPlay.frame=CGRectMake(0, 0, viewH*88/view_fix_height, viewH*88/view_fix_height);
    btnPlay.center=self.view.center;
    [btnPlay setImage:[UIImage imageNamed:@"home_play.png"] forState:UIControlStateNormal];
    [btnPlay addTarget:nil action:@selector(_btnPlayClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:btnPlay];
    
    _versonLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, viewH-viewH*28/view_fix_height,viewW-viewW*20/view_fix_width, viewH*20/view_fix_height)];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version=[infoDictionary objectForKey:@"CFBundleShortVersionString"];
    version=[NSString stringWithFormat:@"V%@",version];
    _versonLabel.text = version;
    _versonLabel.font = [UIFont systemFontOfSize: contact_text_size];
    _versonLabel.backgroundColor = [UIColor clearColor];
    _versonLabel.textColor = [UIColor colorWithRed:(80 / 255.0f) green:(80 / 255.0f) blue:(80 / 255.0f) alpha:1.0];
    _versonLabel.numberOfLines = 0;
    _versonLabel.textAlignment=NSTextAlignmentRight;
    [self.view addSubview:_versonLabel];
}

- (void)_btnPlayClick{
    VideoPlayViewController *v = [[VideoPlayViewController alloc] init];
    v.isPlayurl=NO;
    [self.navigationController pushViewController: v animated:true];
}

- (void)btnPlayUrlClick{
    if ([urlField.text compare:@""]==NSOrderedSame) {
        [self showAllTextDialog:@"The rtsp url can't be empty"];
        return;
    }
    [self Save_Paths:urlField.text :@"PLAYURL"];
    VideoPlayViewController *v = [[VideoPlayViewController alloc] init];
    v.isPlayurl=YES;
    [self.navigationController pushViewController: v animated:true];
}

- (void)_btnShowViewClick{
    if (urlView.hidden) {
        urlView.hidden=NO;
        btnShowView.frame=CGRectMake(viewW-viewW*60/view_fix_width, viewH*70/view_fix_height, viewH*44/view_fix_height, viewH*44/view_fix_height);
        line.frame=CGRectMake(0, viewH*50/view_fix_height, 1, viewH*20/view_fix_height);
        line.center=CGPointMake(btnShowView.center.x, line.center.y);
        [btnShowView setImage:[UIImage imageNamed:@"delete_img.png"] forState:UIControlStateNormal];
    }
    else{
        urlView.hidden=YES;
        btnShowView.frame=CGRectMake(viewW-viewW*60/view_fix_width, viewH*20/view_fix_height, viewH*44/view_fix_height, viewH*44/view_fix_height);
        line.frame=CGRectMake(0, 0, 1, viewH*20/view_fix_height);
        line.center=CGPointMake(btnShowView.center.x, line.center.y);
        [btnShowView setImage:[UIImage imageNamed:@"edit_img.png"] forState:UIControlStateNormal];
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

- (void)Save_Paths:(NSString *)value :(NSString *)key
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}

- (NSString *)Get_Paths:(NSString *)key
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *value=[defaults objectForKey:key];
    return value;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //隐藏键盘
    [urlField resignFirstResponder];
}

//Set StatusBar
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden//for iOS7.0
{
    return YES;
}
@end
