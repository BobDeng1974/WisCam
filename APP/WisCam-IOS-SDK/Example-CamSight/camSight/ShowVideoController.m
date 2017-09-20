#import "ShowVideoController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MediaData.h"
#import "MediaGroup.h"
#import "PlayVideoViewController.h"
#import "CommanParameter.h"

CGFloat VH;
CGFloat VW;
UITableViewCell *Vcell;
NSMutableArray *VMedias;
NSMutableArray *VselectedDic;
BOOL Vis_grouped;
BOOL _VisExist;

// 照片原图路径
#define KOriginalPhotoImagePath   \
[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"OriginalPhotoImages"]
// 视频URL路径
#define KVideoUrlPath   \
[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"VideoURL"]
// caches路径
#define KCachesPath   \
[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]

@interface ShowVideoController ()
@property (nonatomic,strong) NSMutableArray        *groupArrays;
@end

@implementation ShowVideoController
@synthesize groupArrays;

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化
    self.groupArrays = [NSMutableArray array];
    VMedias=[[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    VH=self.view.frame.size.height;
    VW=self.view.frame.size.width;
    VselectedDic = [[NSMutableArray alloc] init];
    self.view.backgroundColor=[UIColor lightGrayColor];
//    bgShowVideo=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"file_bg.png"]];
//    bgShowVideo.frame = CGRectMake(0, 0, VW, VH);
//    bgShowVideo.contentMode=UIViewContentModeScaleToFill;
//    [self.view addSubview:bgShowVideo];
    titleView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewW,viewH*64/view_fix_height)];
    [titleView setBackgroundColor:[UIColor colorWithRed:42/255.0 green:167/255.0 blue:237/255.0 alpha:1.0]];
    [self.view addSubview:titleView];
    
    btnShowVideoBack=[UIButton buttonWithType:UIButtonTypeCustom];
    btnShowVideoBack.frame=CGRectMake(0, viewH*20/view_fix_height, viewH*44/view_fix_height, viewH*44/view_fix_height);
    [btnShowVideoBack setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnShowVideoBack addTarget:nil action:@selector(btnShowVideoBackClick) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:btnShowVideoBack];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, viewH*20/view_fix_height, viewH*200/view_fix_height, viewH*44/view_fix_height)];
    title.center=CGPointMake(viewW*0.5, title.center.y);
    title.text = @"Video";
    title.textColor = [UIColor whiteColor];
    title.textAlignment=UITextAlignmentCenter;
    title.numberOfLines = 1;
    title.font=[UIFont systemFontOfSize:main_title_size];
    title.backgroundColor=[UIColor clearColor];
    [titleView addSubview:title];
    
    lableEditVideo=[[UILabel alloc]init];
    lableEditVideo.frame = CGRectMake(viewW-viewH*116/view_fix_height, viewH*20/view_fix_height, viewH*100/view_fix_height, viewH*44/view_fix_height);
    lableEditVideo.text=@"Edit";
    lableEditVideo.font=[UIFont systemFontOfSize:main_title_size];
    lableEditVideo.textAlignment=UITextAlignmentRight;
    lableEditVideo.userInteractionEnabled=YES;
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lableEditVideoClick)];
    [lableEditVideo addGestureRecognizer:labelTapGestureRecognizer];
    lableEditVideo.textColor=[UIColor whiteColor];
    [titleView addSubview:lableEditVideo];
    
    ShowVideoTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, titleView.frame.size.height, VW, VH-ShowVideoTableview.frame.size.height) style:UITableViewStyleGrouped];
    ShowVideoTableview.dataSource = self;
    ShowVideoTableview.delegate = self;
    ShowVideoTableview.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view  addSubview:ShowVideoTableview];
    
    [self GetVideo];
  
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    int count = (int)[VselectedDic count];
    if (buttonIndex==0) {
        
    }
    else if(buttonIndex==1){
        NSMutableArray *videos=[self Get_Paths:@"video_flag"];
        NSMutableArray *mutaArray = [[NSMutableArray alloc] init];
        [mutaArray addObjectsFromArray:videos];
        for (int i = 0; i < count; i++) {
            [VMedias enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                //根据记录的删除的键值，删除组内元素
                MediaGroup *get_medias=VMedias[idx];
                [get_medias.medias enumerateObjectsUsingBlock:^(id obj, NSUInteger idx2, BOOL *stop) {
                    MediaData *media=get_medias.medias[idx2];
                    if([([media getName]) compare:(VselectedDic[i])]==NSOrderedSame ){
                        NSString *timeSp=[media getTimesamp];
                        
                        for(int i=0;i<[videos count];i++)
                        {
                            if (([timeSp compare:videos[i]]==NSOrderedSame )) {
                                [mutaArray removeObject:timeSp];
                                break;
                            }
                        }
                        [[VMedias[idx] getMedias] removeObject:media];
                    }
                }];
                //当组内元素为0时，删除组
                if ([[VMedias[idx] getMedias] count]==0) {
                    [VMedias removeObject :VMedias[idx]];
                }
            }];
        }
        [self Save_Paths:mutaArray :@"video_flag"];
        [ShowVideoTableview reloadData];
    }
    [VselectedDic removeAllObjects];
    lableEditVideo.text=@"Edit";
    lableEditVideo.textColor=[UIColor whiteColor];
    [ShowVideoTableview setEditing:NO animated:YES];
}


- (void)lableEditVideoClick{
    if ([lableEditVideo.text compare:@"Edit"]==NSOrderedSame) {
        lableEditVideo.text=@"Delete(0)";
        lableEditVideo.textColor=[UIColor redColor];
        [ShowVideoTableview setEditing:YES animated:YES];
    }
    else{
        if ([lableEditVideo.text compare:@"Delete(0)"]==NSOrderedSame) {
            lableEditVideo.text=@"Edit";
            lableEditVideo.textColor=[UIColor whiteColor];
            [ShowVideoTableview setEditing:NO animated:YES];
        }
        else{
            int count = (int)[VselectedDic count];
            if (count > 0 ) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete videos"
                                                                message:@"Are you sure to delete these videos?"
                                                               delegate:self cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:@"OK", nil, nil];
                [alert show];
            }else {
                lableEditVideo.text=@"Edit";
                lableEditVideo.textColor=[UIColor whiteColor];
                [ShowVideoTableview setEditing:NO animated:YES];
            }
        }
    }
}

- (NSString *)DateToString:(NSDate*)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    NSLog(@"%@", strDate);
    //[dateFormatter release];
    return strDate;
}

- (NSMutableArray *)Get_Paths:(NSString *)key
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSMutableArray *value=[defaults objectForKey:key];
    return value;
}

- (void)Save_Paths:(NSMutableArray *)Timesamp :(NSString *)key
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:Timesamp forKey:key];
    [defaults synchronize];
}

- (void)GetVideo
{
    __weak ShowVideoController *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
            if (group != nil) {
                [weakSelf.groupArrays addObject:group];
            } else {
                [weakSelf.groupArrays enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [obj enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                        if ([result thumbnail] != nil) {
                            // 照片
                            if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]){
                               
                            }
                            // 视频
                            else if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo] ){
                                NSString *date= [self DateToString:[result valueForProperty:ALAssetPropertyDate]];
                                UIImage *image = [UIImage imageWithCGImage:[result thumbnail]];
                                NSString *fileName = [[result defaultRepresentation] filename];
                                NSString *url = [[[result defaultRepresentation] url] absoluteString];
                                int64_t fileSize = [[result defaultRepresentation] size];
                                NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[result valueForProperty:ALAssetPropertyDate] timeIntervalSince1970]];
                                
                                NSLog(@"date = %@",date);
                                NSLog(@"fileName = %@",fileName);
                                NSLog(@"url = %@",url);
                                NSLog(@"fileSize = %lld",fileSize);
                                NSMutableArray *videos=[self Get_Paths:@"video_flag"];
                                _VisExist=false;
                                for(int i=0;i<[videos count];i++)
                                {
                                    if ([timeSp compare:videos[i]]==NSOrderedSame) {
                                        _VisExist=true;
                                        break;
                                    }
                                }
                                
                                if (_VisExist){
                                    Vis_grouped=false;
                                    [VMedias enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                        MediaGroup *get_group=VMedias[idx];
                                        //已分组则将数据添加到对应组
                                        if ([date compare:[get_group getName]]==NSOrderedSame ) {
                                            Vis_grouped=true;
                                            MediaData *get_media=[MediaData initWithDate:date andName:fileName andUrl:url andTimesamp:timeSp andImage:image];
                                            [get_group.medias addObject:get_media];
                                        }
                                        }];
                                    //未分组则添加一组，并将数据添加进去
                                    if (Vis_grouped==false) {
                                        MediaData *media=[MediaData initWithDate:date andName:fileName andUrl:url andTimesamp:timeSp andImage:image];
                                        MediaGroup *group=[MediaGroup initWithName:date andMedias:[NSMutableArray arrayWithObjects:media, nil]];
                                        [VMedias addObject:group];
                                    }
                                }
                            }
                        }
                        else{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [ShowVideoTableview reloadData];
                            });
                        }
                    }];
                }];
                
            }
        };
        
        ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error)
        {
            
            NSString *errorMessage = nil;
            
            switch ([error code]) {
                case ALAssetsLibraryAccessUserDeniedError:
                case ALAssetsLibraryAccessGloballyDeniedError:
                    errorMessage = @"用户拒绝访问相册,请在<隐私>中开启";
                    break;
                    
                default:
                    errorMessage = @"Reason unknown.";
                    break;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"错误,无法访问!"
                                                                   message:errorMessage
                                                                  delegate:self
                                                         cancelButtonTitle:@"确定"
                                                         otherButtonTitles:nil, nil,nil];
                [alertView show];
            });
        };
        
        
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc]  init];
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                     usingBlock:listGroupBlock failureBlock:failureBlock];
    });
}

#pragma mark 设置分组标题内容高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.view.frame.size.height*0.08;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    
    // Create label with section title
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(10, 0, VW, self.view.frame.size.height*0.08);
    label.center=CGPointMake(10+label.frame.size.width*0.5, self.view.frame.size.height*0.04);
    label.textColor = [UIColor grayColor];
    label.text = sectionTitle;
    
    // Create header view and add label as a subview
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, self.view.frame.size.height*0.08)];
    //[sectionView setBackgroundColor:[UIColor blackColor]];
    [sectionView addSubview:label];
    return sectionView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MediaGroup *group=VMedias[indexPath.section];
    MediaData *contact=group.medias[indexPath.row];
    UIImage *image=(UIImage*)[contact getImage];
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.frame=CGRectMake(10, 0, VW, self.view.frame.size.height*0.08);
    cell.imageView.image=image;
    cell.textLabel.text=[contact getName];
    cell.detailTextLabel.text=contact.Date;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([lableEditVideo.text compare:@"Edit"]==NSOrderedSame){
        MediaGroup *group=VMedias[indexPath.section];
        MediaData *contact=group.medias[indexPath.row];
        PlayVideoViewController *v = [[PlayVideoViewController alloc] init];
        v.Videourl=[contact getUrl];
        [self.navigationController pushViewController: v animated:true];
        
    }
    else{
        NSInteger sec = indexPath.section;
        NSInteger row = indexPath.row;
        NSMutableArray *media=[VMedias[sec] getMedias];
        [VselectedDic addObject:[media[row] getName]];
        lableEditVideo.text=[NSString stringWithFormat:@"Delete(%d)",(int)[VselectedDic count]];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([lableEditVideo.text compare:@"Edit"]==NSOrderedSame){
        
    }
    else{
        NSInteger sec = indexPath.section;
        NSInteger row = indexPath.row;
        NSMutableArray *media=[VMedias[sec] getMedias];
        [VselectedDic removeObject:[media[row] getName]];
        lableEditVideo.text=[NSString stringWithFormat:@"Delete(%d)",(int)[VselectedDic count]];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 删除操作
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 1.删除数据
        [VMedias[indexPath.section] removeObjectAtIndex:indexPath.row];
        
        // 2.更新UITableView UI界面
        [VMedias[indexPath.section] reloadData];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.view.frame.size.height*0.12;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    MediaGroup *group1=VMedias[section];
    return group1.medias.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return VMedias.count;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    MediaGroup *group=VMedias[section];
    return group.name;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (void)btnShowVideoBackClick{
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
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//    // Return YES for supported orientations
//    return YES;
//}


@end
