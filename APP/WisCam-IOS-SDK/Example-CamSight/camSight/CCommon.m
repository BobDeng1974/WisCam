#import "CCommon.h"
#include <sys/param.h>
#include <sys/mount.h>
#import <AVFoundation/AVFoundation.h>
#import "CDate.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface CCommon ()
{

}

@end


@implementation CCommon

+(void)showAlertViewWithOK:(NSString*)title content:(NSString*)content Delegate:(id<UIAlertViewDelegate>)delegate
{
    UIAlertView* alertView=[[UIAlertView alloc] initWithTitle:title message:content delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alertView.delegate=delegate;
    [alertView show];
    
}

+(void)showAlertViewWithOKCancel:(NSString*)title content:(NSString*)content Delegate:(id<UIAlertViewDelegate>)delegate
{
    
    UIAlertView* alertView=[[UIAlertView alloc] initWithTitle:title message:content delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.delegate=delegate;
    [alertView show];
    
}

+(void)showAlertViewWithLookCancel:(NSString*)title content:(NSString*)content Delegate:(id<UIAlertViewDelegate>)delegate
{
    UIAlertView* alertView=[[UIAlertView alloc] initWithTitle:title message:content delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看", nil];
    alertView.delegate=delegate;
    [alertView show];

}

+(void)WriteKeyValue:(NSString*)key value:(NSString*)value
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(void)WriteDictionary:(NSString*)key value:(NSDictionary*)value
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
+(void)WriteNsmutableArray:(NSString *)key value:(NSMutableArray *)value
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(void)WriteKeyBoolValue:(NSString*)key value:(BOOL)value
{
    
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)WriteKeyIntValue:(NSString*)key value:(NSInteger)value
{
    
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(void)writeKeyDataValue:(NSString*)key value:(NSData*)data
{
    [[NSUserDefaults standardUserDefaults]setObject:data forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+(void)RemoveKey:(NSString*)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString*)ReadKeyValue:(NSString*)key
{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:key]) {
        return @"";
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}
+(NSString*)ReadKeyValueWithDefaultValue:(NSString*)key defaultValue:(NSString*)defaultValue
{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:key]) {
        return defaultValue;
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}
+(NSDictionary*)ReadDictionary:(NSString*)key
{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:key]) {
        return nil;
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+(NSMutableArray*)ReadMutableArray:(NSString*)key
{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:key]) {
        return nil;
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+(NSInteger)ReadIntValue:(NSString*)key
{
    if (![[NSUserDefaults standardUserDefaults]integerForKey:key]) {
        return 10;
    }
    return [[NSUserDefaults standardUserDefaults] integerForKey:key];
}
+(NSInteger)ReadIntValue:(NSString *)key defaultValue:(NSInteger)defaultValue
{
    if (![[NSUserDefaults standardUserDefaults]integerForKey:key]) {
        return defaultValue;
    }
    return [[NSUserDefaults standardUserDefaults] integerForKey:key];
}


+(BOOL)ReadKeyBoolValue:(NSString*)key
{
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:key]) {
        return NO;
    }
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

+(NSData*)ReadKeyDataValue:(NSString*)key
{
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:key]) {
        return nil;
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}


+(NSString*)ReadLanguageValue:(NSString*)key
{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:key]) {
        return @"";
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}


+(NSString*)dealErrWithMutable:(NSMutableString*)resultStr{
    if (resultStr.length<7) {
        return @"success";
    }
    NSString * result=[resultStr substringWithRange:NSMakeRange(0, 7)];
    if ([result isEqualToString:@"<Error>"]||[result isEqualToString:@"<ERROR>"]) {
        return [resultStr substringFromIndex:7];
        
    }
    result=[resultStr substringWithRange:NSMakeRange(0, 4)];
    if ([result isEqualToString:@"<htm"])
    {
        return @"请检查你的网络配置";
    }else
    {
        return @"success";
    }
    
}
+(NSString*)dealErr:(NSString*)resultStr
{
    NSMutableString * str=(NSMutableString*)[NSString stringWithFormat:@"%@",resultStr];
    return [self dealErrWithMutable:str];
}


+(BOOL)CreatPreviewImageFileWithName:(NSString*)fileName Type:(NSString*)type Image:(UIImage*)image
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString * baseDirctory=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],type];
    NSFileManager * fileManger=[NSFileManager defaultManager];
    BOOL isdir=NO;
    //创建文件夹
    if (![fileManger fileExistsAtPath:baseDirctory isDirectory:&isdir]) {
        BOOL success =[fileManger createDirectoryAtPath:baseDirctory withIntermediateDirectories:YES attributes:nil error:nil];
        if (success) {
            NSLog(@"创建文件夹成功!");
        }
    }
    NSString *filePath = [baseDirctory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];   // 保存文件的名称
    if (![fileManger fileExistsAtPath:filePath isDirectory:&isdir]) {
        BOOL success= [fileManger createFileAtPath:filePath contents:nil attributes:nil];
        if (success) {
            NSLog(@"创建文件成功!");
        }
        
    }
    BOOL ISSuccess;
    ISSuccess =[UIImageJPEGRepresentation(image, 1.0) writeToFile:filePath atomically:YES];
    return ISSuccess;

}

+(BOOL)CreatImageFileWithName:(NSString*)fileName Type:(NSString*)type Image:(UIImage*)image
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString * baseDirctory=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],type];
    NSFileManager * fileManger=[NSFileManager defaultManager];
    BOOL isdir=NO;
    //创建文件夹
    if (![fileManger fileExistsAtPath:baseDirctory isDirectory:&isdir]) {
        BOOL success =[fileManger createDirectoryAtPath:baseDirctory withIntermediateDirectories:YES attributes:nil error:nil];
        if (success) {
            NSLog(@"创建文件夹成功!");
        }
    }
    NSString *filePath = [baseDirctory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];   // 保存文件的名称
    if (![fileManger fileExistsAtPath:filePath isDirectory:&isdir]) {
        BOOL success= [fileManger createFileAtPath:filePath contents:nil attributes:nil];
        if (success) {
            NSLog(@"创建文件成功!");
        }
        
    }
    BOOL ISSuccess;
    ISSuccess =[UIImageJPEGRepresentation(image, 1.0) writeToFile:filePath atomically:YES];
    return ISSuccess;
    
}

+(BOOL)CreatVideoFileWithName:(NSString*)fileName Type:(NSString*)type
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString * baseDirctory=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],type];
    NSFileManager * fileManger=[NSFileManager defaultManager];
    BOOL isdir=NO;
    //创建文件夹
    if (![fileManger fileExistsAtPath:baseDirctory isDirectory:&isdir]) {
        BOOL success =[fileManger createDirectoryAtPath:baseDirctory withIntermediateDirectories:YES attributes:nil error:nil];
        if (success) {
            NSLog(@"创建文件夹成功!");
        }
    }
    BOOL ISSuccess;
    NSString *filePath = [baseDirctory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];   // 保存文件的名称
    if (![fileManger fileExistsAtPath:filePath isDirectory:&isdir]) {
        BOOL success= [fileManger createFileAtPath:filePath contents:nil attributes:nil];
        if (success) {
            NSLog(@"创建文件成功!");
        }
    }
    return ISSuccess;
}

+(NSString*)ReadFileWithName:(NSString*)fileName Type:(NSString*)type  //返回文件的路径
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString * baseDirctory=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],type];
    NSString *filePath = [baseDirctory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
    return filePath;
}
+(BOOL)RemoveFileWith:(NSString*)fileName Type:(NSString*)type
{
    NSFileManager * fileManger=[NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString * baseDirctory=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],type];
    NSString *filePath = [baseDirctory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
    BOOL isdir=NO;
    BOOL ISSuccess=NO;
    if ([fileManger fileExistsAtPath:filePath isDirectory:&isdir])
    {
        ISSuccess=  [fileManger removeItemAtPath:filePath error:nil];
        if (ISSuccess) {
            NSLog(@"删除成功");
        }
    }
    return ISSuccess;
}
+(NSString*) fileSizeAtPath:(NSString*) fileName Type:(NSString*)type
{
    NSFileManager* manager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString * baseDirctory=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],type];
    NSString *filePath = [baseDirctory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
    NSString * sizeStr=@"未知";
    if ([manager fileExistsAtPath:filePath]){
        long long size=[[manager attributesOfItemAtPath:filePath error:nil] fileSize];
        if (size>=1024.0*1024.0*1024.0)
        {
            sizeStr=[NSString stringWithFormat:@"%0.2fG",size/1024.0/1024.0/1024.0];
            return sizeStr;
        }else if (size>=1024.0*1024.0)
        {
            sizeStr=[NSString stringWithFormat:@"%0.2fMB",size/1024.0/1024.0];
            return sizeStr;

        }else
        {
            sizeStr=[NSString stringWithFormat:@"%0.2fKB",size/1024.0];
            return sizeStr;

        }
    }
    return sizeStr;
}

+(NSString*)fileCreateDateAtPath:(NSString*) fileName Type:(NSString*)type
{
    NSFileManager* manager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString * baseDirctory=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],type];
    NSString *filePath = [baseDirctory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
    NSDictionary *fileAttributes = [manager fileAttributesAtPath:filePath traverseLink:YES];
    if (fileAttributes!=nil)
    {
        NSDate*date=[fileAttributes objectForKey:NSFileCreationDate];
        NSString * dateStr=[CDate GetStringDate:date];
       // NSDate * fileDate=[[NSDate alloc] initWithTimeInterval:8*60*60 sinceDate:date];
        return dateStr;
    }
    return [NSString stringWithFormat:@"未知"];
}
+(NSString*)filePlayTimeAtPath:(NSString*)fileName Type:(NSString*)type
{
    NSFileManager* manager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString * baseDirctory=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],type];
    NSString *filePath = [baseDirctory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
     if ([manager fileExistsAtPath:filePath])
     {
         NSURL *sourceMovieURL = [NSURL fileURLWithPath:filePath];
         AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:sourceMovieURL options:nil];
         CMTime audioDuration = movieAsset.duration;
         float audioDurationSeconds =CMTimeGetSeconds(audioDuration);
         return [NSString stringWithFormat:@"%02d:%02d",(int)audioDurationSeconds/60,(int)audioDurationSeconds%60];
     }
    
    return @"未知";
}

+ (BOOL)CreateFinishedPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString * baseDirctory=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],@"historyVideo"];
    NSFileManager * fileManger=[NSFileManager defaultManager];
    BOOL isdir=NO;
    //创建文件夹
    if (![fileManger fileExistsAtPath:baseDirctory isDirectory:&isdir]) {
        BOOL success =[fileManger createDirectoryAtPath:baseDirctory withIntermediateDirectories:YES attributes:nil error:nil];
        if (success) {
            NSLog(@"创建文件夹成功!");
        }
    }
    BOOL ISSuccess;
    NSString *filePath = [baseDirctory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",@"finish.plist"]];   // 保存文件的名称
    if (![fileManger fileExistsAtPath:filePath isDirectory:&isdir]) {
        ISSuccess= [fileManger createFileAtPath:filePath contents:nil attributes:nil];
        if (ISSuccess) {
            NSLog(@"创建plist文件成功!");
        }
    }
    return  ISSuccess;
}
+(NSString*)GetFinishedPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString * baseDirctory=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],@"historyVideo"];
    NSString *filePath = [baseDirctory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",@"finish.plist"]];
    return filePath;
}
+(BOOL)IsexitFile:(NSString*)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString * baseDirctory=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],@"historyVideo"];
     NSString *filePath = [baseDirctory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
    NSFileManager * fileManger=[NSFileManager defaultManager];
    BOOL success=NO;
    BOOL isdir=NO;
    if ([fileManger fileExistsAtPath:filePath isDirectory:&isdir]) {
        success=YES;
    }
    return success;
}

+(NSArray*)GetFilesWithType:(NSString*)folderName
{
    
    NSFileManager * manger=[NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString * baseDirctory=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],folderName];
    NSError * error;
    NSArray * fileArray=[manger contentsOfDirectoryAtPath:baseDirctory error:&error];
    return fileArray;
}


/***********每个账户下的文件操作*************/

+(BOOL)CreateUserIDFolder:(NSString*)userID
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString * rootDirctory=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],userID];
    NSFileManager * fileManger=[NSFileManager defaultManager];
    BOOL isdir=NO;
    //创建用户文件夹
    BOOL success=YES;
    if (![fileManger fileExistsAtPath:rootDirctory isDirectory:&isdir]) {
         success =[fileManger createDirectoryAtPath:rootDirctory withIntermediateDirectories:YES attributes:nil error:nil];
        if (success) {
            NSLog(@"创建文件夹成功!");
        }
    }
    return success;
}

+(NSArray*)GetFilesWithType:(NSString*)folderName UserID:(NSString*)userID
{
    NSFileManager * manger=[NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString * rootDirctory=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],userID];
    NSString * baseDirctory=[NSString stringWithFormat:@"%@/%@",rootDirctory,folderName];
    NSError * error;
    NSArray * fileArray=[manger contentsOfDirectoryAtPath:baseDirctory error:&error];
    return fileArray;
}

+(BOOL)CreatImageFileWithName:(NSString*)fileName Type:(NSString*)type Image:(UIImage*)image  UserID:(NSString*)userID
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString * rootDirctory=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],userID];
    NSFileManager * fileManger=[NSFileManager defaultManager];
    BOOL isdir=NO;
    //UserID创建文件夹
    if (![fileManger fileExistsAtPath:rootDirctory isDirectory:&isdir]) {
        BOOL success =[fileManger createDirectoryAtPath:rootDirctory withIntermediateDirectories:YES attributes:nil error:nil];
        if (success) {
            NSLog(@"创建用户文件夹成功!");
        }
    }
    NSString *basePath = [rootDirctory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",type]];   // 保存子文件的名称
    if (![fileManger fileExistsAtPath:basePath isDirectory:&isdir]) {
        
        BOOL success =[fileManger createDirectoryAtPath:basePath withIntermediateDirectories:YES attributes:nil error:nil];
        if (success) {
            NSLog(@"创建子文件夹成功!");
        }
    }
    NSString * filePath=[NSString stringWithFormat:@"%@/%@",basePath,fileName];
    if (![fileManger fileExistsAtPath:filePath isDirectory:&isdir]) {
        BOOL success= [fileManger createFileAtPath:filePath contents:nil attributes:nil];
        if (success) {
            NSLog(@"创建文件成功!");
        }
    }
    BOOL ISSuccess;
    ISSuccess =[UIImageJPEGRepresentation(image, 1.0) writeToFile:filePath atomically:YES];
    return ISSuccess;
}

+(BOOL)CreatVideoFileWithName:(NSString*)fileName Type:(NSString*)type UserID:(NSString*)userID
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString * rootDirctory=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],userID];
    NSFileManager * fileManger=[NSFileManager defaultManager];
    BOOL isdir=NO;
    //UserID创建文件夹
    if (![fileManger fileExistsAtPath:rootDirctory isDirectory:&isdir]) {
        BOOL success =[fileManger createDirectoryAtPath:rootDirctory withIntermediateDirectories:YES attributes:nil error:nil];
        if (success) {
            NSLog(@"创建用户文件夹成功!");
        }
    }
    NSString *basePath = [rootDirctory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",type]];   // 保存子文件的名称
    if (![fileManger fileExistsAtPath:basePath isDirectory:&isdir]) {
        
        BOOL success =[fileManger createDirectoryAtPath:basePath withIntermediateDirectories:YES attributes:nil error:nil];
        if (success) {
            NSLog(@"创建子文件夹成功!");
        }
    }
    BOOL success;
    NSString * filePath=[NSString stringWithFormat:@"%@/%@",basePath,fileName];
    if (![fileManger fileExistsAtPath:filePath isDirectory:&isdir]) {
        success= [fileManger createFileAtPath:filePath contents:nil attributes:nil];
        if (success) {
            NSLog(@"创建文件成功!");
        }
    }
    return success;
}

+(NSString*)ReadFileWithName:(NSString*)fileName Type:(NSString*)type UserID:(NSString*)userID
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString * rootDirctory=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],userID];
    NSString *basePath = [rootDirctory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",type]];
    NSString * filePath=[basePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
    return filePath;
}

+(BOOL)RemoveFileWith:(NSString*)fileName Type:(NSString*)type UserID:(NSString*)userID
{
    NSFileManager * fileManger=[NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString * rootDirctory=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],userID];
    NSString *basePath = [rootDirctory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",type]];
    NSString * filePath=[basePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
    BOOL isdir=NO;
    BOOL ISSuccess=NO;
    if ([fileManger fileExistsAtPath:filePath isDirectory:&isdir])
    {
        ISSuccess=  [fileManger removeItemAtPath:filePath error:nil];
        if (ISSuccess) {
            NSLog(@"删除成功");
        }
    }
    return ISSuccess;
}


+(NSString*) fileSizeAtPath:(NSString*) fileName Type:(NSString*)type UserID:(NSString*)userID
{
    NSFileManager* manager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString * rootDirctory=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],userID];
    NSString *basePath = [rootDirctory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",type]];
     NSString *filePath = [basePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
    NSString * sizeStr=@"未知";
    if ([manager fileExistsAtPath:filePath]){
        long long size=[[manager attributesOfItemAtPath:filePath error:nil] fileSize];
        if (size>=1024.0*1024.0*1024.0)
        {
            sizeStr=[NSString stringWithFormat:@"%0.2fG",size/1024.0/1024.0/1024.0];
            return sizeStr;
        }else if (size>=1024.0*1024.0)
        {
            sizeStr=[NSString stringWithFormat:@"%0.2fMB",size/1024.0/1024.0];
            return sizeStr;
            
        }else
        {
            sizeStr=[NSString stringWithFormat:@"%0.2fKB",size/1024.0];
            return sizeStr;
            
        }
    }
    return sizeStr;

}

+(NSString*)fileCreateDateAtPath:(NSString*) fileName Type:(NSString*)type UserID:(NSString*)userID
{
    NSFileManager* manager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString * rootDirctory=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],userID];
    NSString *basePath = [rootDirctory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",type]];
     NSString *filePath = [basePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
    NSDictionary *fileAttributes = [manager fileAttributesAtPath:filePath traverseLink:YES];
    if (fileAttributes!=nil)
    {
        NSDate*date=[fileAttributes objectForKey:NSFileCreationDate];
        NSString * dateStr=[CDate GetStringDate:date];
        // NSDate * fileDate=[[NSDate alloc] initWithTimeInterval:8*60*60 sinceDate:date];
        return dateStr;
    }
    return [NSString stringWithFormat:@"未知"];
}

+(NSString*)filePlayTimeAtPath:(NSString*)fileName Type:(NSString*)type UserID:(NSString*)userID
{
    NSFileManager* manager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString * rootDirctory=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],userID];
    NSString *basePath = [rootDirctory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",type]];
    NSString *filePath = [basePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
    if ([manager fileExistsAtPath:filePath])
    {
        NSURL *sourceMovieURL = [NSURL fileURLWithPath:filePath];
        AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:sourceMovieURL options:nil];
        CMTime audioDuration = movieAsset.duration;
        float audioDurationSeconds =CMTimeGetSeconds(audioDuration);
        return [NSString stringWithFormat:@"%02d:%02d",(int)audioDurationSeconds/60,(int)audioDurationSeconds%60];
    }
    return @"未知";
}


+(BOOL)IsexitFile:(NSString*)fileName UserID:(NSString*)userID
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString * rootDirctory=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],userID];
    NSString *basePath = [rootDirctory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",@"historyVideo"]];
    NSString * filePath=[basePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
    NSFileManager * fileManger=[NSFileManager defaultManager];
    BOOL success=NO;
    BOOL isdir=NO;
    if ([fileManger fileExistsAtPath:filePath isDirectory:&isdir]) {
        success=YES;
    }
    return success;
}


+(BOOL)IsexitPhotoFile:(NSString *)fileName UserID:(NSString*)userID
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString * rootDirctory=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],userID];
    NSString *basePath = [rootDirctory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",@"photo"]];
    NSString * filePath=[basePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
    NSFileManager * fileManger=[NSFileManager defaultManager];
    BOOL success=NO;
    BOOL isdir=NO;
    if ([fileManger fileExistsAtPath:filePath isDirectory:&isdir]) {
        success=YES;
    }
    return success;

}



+(long long)freeDiskSpaceInBytes
{
    struct statfs buf;
    long long freespace = -1;
    if(statfs("/var", &buf) >= 0){
        freespace = (long long)(buf.f_bsize * buf.f_bfree);
        freespace=freespace/1024.0/1024.0;
    }
    return freespace;
}
+(void)usedSpaceAndfreeSpace
{
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] ;
    NSFileManager* fileManager = [[NSFileManager alloc ]init];
    NSDictionary *fileSysAttributes = [fileManager attributesOfFileSystemForPath:path error:nil];
    NSNumber *freeSpace = [fileSysAttributes objectForKey:NSFileSystemFreeSize];
    NSNumber *totalSpace = [fileSysAttributes objectForKey:NSFileSystemSize];
    NSString  * str= [NSString stringWithFormat:@"已占用%0.1fG/剩余%0.1fG",([totalSpace longLongValue] - [freeSpace longLongValue])/1024.0/1024.0/1024.0,[freeSpace longLongValue]/1024.0/1024.0/1024.0];
    NSLog(@"--------%@",str);
}

+(float)getTotalDiskSpaceInBytes
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    struct statfs tStats;
    
    statfs([[paths lastObject] cString], &tStats);
    
    float totalSpace = (float)(tStats.f_blocks * tStats.f_bsize);
    
    return totalSpace/1024.0/1024.0/1024.0;
}




+(void)createAlbumInPhoneAlbum:(NSString*)photoAlbum
{
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    NSMutableArray *groups=[[NSMutableArray alloc]init];
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop)
    {
        if (group)
        {
            [groups addObject:group];
        }
        else
        {
            BOOL haveHDRGroup = NO;
            for (ALAssetsGroup *gp in groups)
            {
                NSString *name =[gp valueForProperty:ALAssetsGroupPropertyName];
                if ([name isEqualToString:photoAlbum])
                {
                    haveHDRGroup = YES;
                }
            }
            if (!haveHDRGroup)
            {
                //do add a group named "XXXX"
                [assetsLibrary addAssetsGroupAlbumWithName:photoAlbum
                                               resultBlock:^(ALAssetsGroup *group)
                 {
                     if (group!=nil) {
                         [groups addObject:group];
                     }
                 }
                                              failureBlock:nil];
                haveHDRGroup = YES;
            }
        }
    };
    //创建相簿
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:listGroupBlock failureBlock:nil];
    
}

+(void)saveImage:(UIImage*)image  PhotoAlbum:(NSString*)photoAlbum
{
    [self saveToAlbumWithMetadata:nil imageData:UIImagePNGRepresentation(image) customAlbumName:photoAlbum completionBlock:^
     {
         //这里可以创建添加成功的方法
         
     }
                     failureBlock:^(NSError *error)
     {
         //处理添加失败的方法显示alert让它回到主线程执行，不然那个框框死活不肯弹出来
         dispatch_async(dispatch_get_main_queue(), ^{
             
             //添加失败一般是由用户不允许应用访问相册造成的，这边可以取出这种情况加以判断一下
             if([error.localizedDescription rangeOfString:@"User denied access"].location != NSNotFound ||[error.localizedDescription rangeOfString:@"用户拒绝访问"].location!=NSNotFound){
                 
                 UIAlertView *alert=[[UIAlertView alloc]initWithTitle:error.localizedDescription message:error.localizedFailureReason delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
                 
                 [alert show];
                 
             }
         });
     }];
    
}

+(void)saveToAlbumWithMetadata:(NSDictionary *)metadata
                      imageData:(NSData *)imageData
                customAlbumName:(NSString *)customAlbumName
                completionBlock:(void (^)(void))completionBlock
                   failureBlock:(void (^)(NSError *error))failureBlock
{
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    void (^AddAsset)(ALAssetsLibrary *, NSURL *) = ^(ALAssetsLibrary *assetsLibrary, NSURL *assetURL) {
        [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
            [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                
                if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:customAlbumName]) {
                    [group addAsset:asset];
                    if (completionBlock) {
                        completionBlock();
                    }
                }
            } failureBlock:^(NSError *error) {
                if (failureBlock) {
                    failureBlock(error);
                }
            }];
        } failureBlock:^(NSError *error) {
            if (failureBlock) {
                failureBlock(error);
            }
        }];
    };
    [assetsLibrary writeImageDataToSavedPhotosAlbum:imageData metadata:metadata completionBlock:^(NSURL *assetURL, NSError *error) {
        if (customAlbumName) {
            [assetsLibrary addAssetsGroupAlbumWithName:customAlbumName resultBlock:^(ALAssetsGroup *group) {
                if (group) {
                    [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                        [group addAsset:asset];
                        if (completionBlock) {
                            completionBlock();
                        }
                    } failureBlock:^(NSError *error) {
                        if (failureBlock) {
                            failureBlock(error);
                        }
                    }];
                } else {
                    AddAsset(assetsLibrary, assetURL);
                }
            } failureBlock:^(NSError *error) {
                AddAsset(assetsLibrary, assetURL);
            }];
        } else {
            if (completionBlock) {
                completionBlock();
            }
        }
    }];
}

+(void)readImageFromGroup
{
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc]init];//生成整个photolibrary句柄的实例
    NSMutableArray *mediaArray = [[NSMutableArray alloc]init];//存放media的数组
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {   //获取所有group相册集合
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {//从group里面
            NSString* assetType = [result valueForProperty:ALAssetPropertyType];
            if ([assetType isEqualToString:ALAssetTypePhoto]) {
                NSLog(@"Photo");
            }else if([assetType isEqualToString:ALAssetTypeVideo]){
                NSLog(@"Video");
            }else if([assetType isEqualToString:ALAssetTypeUnknown]){
                NSLog(@"Unknow AssetType");
            }
            
            NSDictionary *assetUrls = [result valueForProperty:ALAssetPropertyURLs];
            NSUInteger assetCounter = 0;
            for (NSString *assetURLKey in assetUrls) {
                NSLog(@"Asset URL %lu = %@",(unsigned long)assetCounter,[assetUrls objectForKey:assetURLKey]);
            }
            
            NSLog(@"Representation Size = %lld",[[result defaultRepresentation]size]);
        }];
    } failureBlock:^(NSError *error) {
        NSLog(@"Enumerate the asset groups failed.");
    }];
}

-(NSMutableArray*)readImage:(NSString*)photoAlbum
{
//    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc]init];//生成整个photolibrary句柄的实例
//    NSMutableArray *mediaArray = [[NSMutableArray alloc]init];//存放media的数组
//    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
//                                 usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
//                                     // 遍历每个相册中的项ALAsset
//                                     [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index,BOOL *stop) {
//                                         
//                                         // ALAsset的类型
//                                         NSString *assetType = [result valueForProperty:ALAssetPropertyType];
//                                         if ([assetType isEqualToString:ALAssetTypePhoto]){
//                                             ALAssetRepresentation *assetRepresentation =[result defaultRepresentation];
//                                             CGFloat imageScale = [assetRepresentation scale];
//                                             UIImageOrientation imageOrientation = (UIImageOrientation)[assetRepresentation orientation];
//                                             dispatch_async(dispatch_get_main_queue(), ^(void) {
//                                                 CGImageRef imageReference = [assetRepresentation fullResolutionImage];
//                                                 // 对找到的图片进行操作
//                                                 UIImage *image =[[UIImage alloc] initWithCGImage:imageReference scale:imageScale orientation:imageOrientation];
//                                             });
//                                         }
//                                     }];
//                                 }
//                               failureBlock:^(NSError *error) {
//                                   NSLog(@"Failed to enumerate the asset groups.");
//                               }];
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    NSMutableArray *mediaArray = [[NSMutableArray alloc]init];//存放media的数组
    NSMutableArray *groups=[[NSMutableArray alloc]init];
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop)
    {
        if (group)
        {
            [groups addObject:group];
        }
        else
        {
            ALAssetsGroup *gp;
            for (gp in groups)
            {
                NSString *name =[gp valueForProperty:ALAssetsGroupPropertyName];
                if ([name isEqualToString:photoAlbum])
                {
                    // 遍历每个相册中的项ALAsset
                    [gp enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index,BOOL *stop) {
                            if ([result thumbnail] != nil) {
                                if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto])
                                {
                                    //UIImage *image = [UIImage imageWithCGImage:[result thumbnail]];
                                    NSString *fileName = [[result defaultRepresentation] filename];
                                    //NSString *url = [[[result defaultRepresentation] url] absoluteString];
                                    //int64_t fileSize = [[result defaultRepresentation] size];
                                    [mediaArray addObject:fileName];
                                }
                            }
                    }];
                }
            }
        }
    };
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:listGroupBlock failureBlock:nil];
    
    return mediaArray;
}

+(UIImage*)SaveScreenImage:(UIView*)view Imagesize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}



+(NSDate *)convertDateToLocalTime: (NSDate *)forDate
{
    NSTimeZone *nowTimeZone = [NSTimeZone localTimeZone];
    NSInteger timeOffset = [nowTimeZone secondsFromGMTForDate:forDate];
    NSDate *newDate = [forDate dateByAddingTimeInterval:timeOffset];
    return newDate;
}


+(BOOL)ISlocalWIFI:(NSString*)deviceID
{
    if (deviceID.length==0) {
        return NO;
    }
//    nabto.net
  //  rakwireless.com
    NSString * subDeviceID=[deviceID substringWithRange:NSMakeRange(deviceID.length-15, 15)];
    if ([subDeviceID isEqualToString:@"rakwireless.com"]) {
        return YES;
    }
    return NO;
}

+(NSString*)GetSizeToString:(long long)value
{
    NSString * sizeStr=@"";
    if (value>=1024.0*1024.0*1024.0)
    {
        sizeStr=[NSString stringWithFormat:@"%0.2fG",value/1024.0/1024.0/1024.0];
        return sizeStr;
    }else if (value>=1024.0*1024.0)
    {
        sizeStr=[NSString stringWithFormat:@"%0.2fMB",value/1024.0/1024.0];
        return sizeStr;
        
    }else
    {
        sizeStr=[NSString stringWithFormat:@"%0.2fKB",value/1024.0];
        return sizeStr;
    }
}

+(BOOL)validateMobile:(NSString *)mobileNum //判断是否为手机号
{
    
    {
        /**
         * 手机号码
         * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
         * 联通：130,131,132,152,155,156,185,186
         * 电信：133,1349,153,180,189
         */
        NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
        /**
         10         * 中国移动：China Mobile
         11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
         12         */
        NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
        /**
         15         * 中国联通：China Unicom
         16         * 130,131,132,152,155,156,185,186
         17         */
        NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
        /**
         20         * 中国电信：China Telecom
         21         * 133,1349,153,180,189
         22         */
        NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
        /**
         25         * 大陆地区固话及小灵通
         26         * 区号：010,020,021,022,023,024,025,027,028,029
         27         * 号码：七位或八位
         28         */
        // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
        
        NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
        NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
        NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
        NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
        
        if (([regextestmobile evaluateWithObject:mobileNum] == YES)
            || ([regextestcm evaluateWithObject:mobileNum] == YES)
            || ([regextestct evaluateWithObject:mobileNum] == YES)
            || ([regextestcu evaluateWithObject:mobileNum] == YES))
        {  
            return YES;  
        }  
        else  
        {  
            return NO;  
        }  
    }
}

+(BOOL)checkNumber:(NSString *)number
{
    if([number isEqualToString:@""]){
        return NO;
    }
    NSString *fir = [number substringToIndex:1];
    if([fir isEqualToString:@"1"] && number.length == 11)
    {
        unichar c;
        for (int i=0; i<number.length; i++) {
            c=[number characterAtIndex:i];
            if (!isdigit(c)) {
                return NO;
                break;
            }
        }
        return YES;
    }
    return NO;
}

+(NSInteger)indexFisrstofString:(NSString*)str  //返回在字符串的第一个位置
{
    NSString * temp=nil;
    NSMutableArray * arr=[NSMutableArray array];
    [arr addObject:@"张"];
    [arr addObject:@"年"];
    [arr addObject:@"月"];
    [arr addObject:@"天"];
    for (int i=0; i<arr.count; i++)
    {
        NSCharacterSet * set=[NSCharacterSet characterSetWithCharactersInString:arr[i]];
        NSRange range=[str rangeOfCharacterFromSet:set];
        if (range.location!=NSNotFound) {
            temp=arr[i];
            break;
        }
    }
    if (temp!=nil) {
        NSCharacterSet * set=[NSCharacterSet characterSetWithCharactersInString:temp];
        NSRange range=[str rangeOfCharacterFromSet:set];
        return range.location;
    }
    return 10000;
}
+(NSInteger)FisrstofString:(NSString *)str
{
    unichar c;
    for (int i=0; i<str.length; i++) {
        c=[str characterAtIndex:i];
        if (!isdigit(c))
        {
            return i;
            break;
        }
    }
    return 10000;
}

+(NSString *) gen_uuid
{
    CFUUIDRef uuid_ref=CFUUIDCreate(nil);
    CFStringRef uuid_string_ref=CFUUIDCreateString(nil, uuid_ref);
    CFRelease(uuid_ref);
    NSString *uuid=[NSString stringWithString:(__bridge NSString * _Nonnull)(uuid_string_ref)];
    CFRelease(uuid_string_ref);
    return uuid;
}

+(NSString *) getDeviceSSID

{
    
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    
    
    
    id info = nil;
    
    for (NSString *ifnam in ifs) {
        
        info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        
        if (info && [info count]) {
            
            break;
            
        }
        
    }
    NSDictionary *dctySSID = (NSDictionary *)info;
    
    NSString *ssid = [[dctySSID objectForKey:@"SSID"] lowercaseString];
    
    return ssid;
    
}

@end
