#import "MediaViewController.h"
#import "ShowPhotoController.h"
#import "ShowVideoController.h"
#import "CommanParameter.h"

@interface MediaViewController ()

@end

@implementation MediaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    titleView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewW,viewH*64/view_fix_height)];
    [titleView setBackgroundColor:[UIColor colorWithRed:42/255.0 green:167/255.0 blue:237/255.0 alpha:1.0]];
    [self.view addSubview:titleView];
    
    UIButton *mediaBack=[UIButton buttonWithType:UIButtonTypeCustom];
    mediaBack.frame=CGRectMake(0, viewH*20/view_fix_height, viewH*44/view_fix_height, viewH*44/view_fix_height);
    [mediaBack setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [mediaBack addTarget:nil action:@selector(mediaBackClick) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:mediaBack];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, viewH*20/view_fix_height, viewH*200/view_fix_height, viewH*44/view_fix_height)];
    title.center=CGPointMake(viewW*0.5, title.center.y);
    title.text = @"Playback";
    title.textColor = [UIColor whiteColor];
    title.textAlignment=UITextAlignmentCenter;
    title.numberOfLines = 1;
    title.font=[UIFont systemFontOfSize:main_title_size];
    title.backgroundColor=[UIColor clearColor];
    [titleView addSubview:title];
    
    photoView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewH*100/view_fix_height,viewH*120/view_fix_height)];
    photoView.center=CGPointMake(viewW*0.25, viewH*0.5);
    [self.view addSubview:photoView];
    photoView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPhotoClick)];
    [photoView addGestureRecognizer:singleTap];
    
    UIButton *showPhoto=[UIButton buttonWithType:UIButtonTypeCustom];
    showPhoto.frame=CGRectMake(0, 0, viewH*100/view_fix_height,viewH*100/view_fix_height);
    [showPhoto setImage:[UIImage imageNamed:@"library_picture.png"] forState:UIControlStateNormal];
    [showPhoto addTarget:self action:@selector(showPhotoClick) forControlEvents:UIControlEventTouchUpInside];
    [photoView addSubview:showPhoto];
    
    UILabel *photo = [[UILabel alloc]initWithFrame:CGRectMake(0, viewH*100/view_fix_height, viewH*100/view_fix_height, viewH*20/view_fix_height)];
    photo.text = @"Images";
    photo.textColor = [UIColor blackColor];
    photo.textAlignment=UITextAlignmentCenter;
    photo.numberOfLines = 1;
    photo.backgroundColor=[UIColor clearColor];
    [photoView addSubview:photo];
    
    videoView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewH*100/view_fix_height,viewH*120/view_fix_height)];
    videoView.center=CGPointMake(viewW*0.75, viewH*0.5);
    [self.view addSubview:videoView];
    videoView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showVideoClick)];
    [videoView addGestureRecognizer:singleTap2];
    
    UIButton *showVideo=[UIButton buttonWithType:UIButtonTypeCustom];
    showVideo.frame=CGRectMake(0, 0, viewH*100/view_fix_height,viewH*100/view_fix_height);
    [showVideo setImage:[UIImage imageNamed:@"library_video.png"] forState:UIControlStateNormal];
    [showVideo addTarget:self action:@selector(showVideoClick) forControlEvents:UIControlEventTouchUpInside];
    [videoView addSubview:showVideo];
    UILabel *video = [[UILabel alloc]initWithFrame:CGRectMake(0, viewH*100/view_fix_height, viewH*100/view_fix_height, viewH*20/view_fix_height)];
    video.text = @"Video";
    video.textColor = [UIColor blackColor];
    video.textAlignment=UITextAlignmentCenter;
    video.numberOfLines = 1;
    video.backgroundColor=[UIColor clearColor];
    [videoView addSubview:video];
}

- (void)showPhotoClick{
    ShowPhotoController *v = [[ShowPhotoController alloc] init];
    [self.navigationController pushViewController: v animated:true];
}

- (void)showVideoClick{
    ShowVideoController *v = [[ShowVideoController alloc] init];
    [self.navigationController pushViewController: v animated:true];
}

- (void)mediaBackClick{
    [self.navigationController popViewControllerAnimated:YES];
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

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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
