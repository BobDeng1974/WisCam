#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface CCommon : NSObject
+(void)showAlertViewWithOK:(NSString*)title content:(NSString*)content Delegate:(id<UIAlertViewDelegate>)delegate;
+(void)showAlertViewWithOKCancel:(NSString*)title content:(NSString*)content Delegate:(id<UIAlertViewDelegate>)delegate;
+(void)showAlertViewWithLookCancel:(NSString*)title content:(NSString*)content Delegate:(id<UIAlertViewDelegate>)delegate;

+(void)WriteKeyValue:(NSString*)key value:(NSString*)value;
+(void)WriteDictionary:(NSString*)key value:(NSDictionary*)value;
+(void)WriteNsmutableArray:(NSString*)key value:(NSMutableArray*)value;
+(void)WriteKeyBoolValue:(NSString*)key value:(BOOL)value;
+(void)WriteKeyIntValue:(NSString*)key value:(NSInteger)value;
+(void)writeKeyDataValue:(NSString*)key value:(NSData*)data;
+(void)RemoveKey:(NSString*)key;

+(NSString*)ReadKeyValue:(NSString*)key;
+(NSString*)ReadKeyValueWithDefaultValue:(NSString*)key defaultValue:(NSString*)defaultValue;
+(NSDictionary*)ReadDictionary:(NSString*)key;
+(NSMutableArray*)ReadMutableArray:(NSString*)key;
+(NSInteger)ReadIntValue:(NSString*)key;
+(NSInteger)ReadIntValue:(NSString *)key defaultValue:(NSInteger)defaultValue;
+(BOOL)ReadKeyBoolValue:(NSString*)key;
+(NSData*)ReadKeyDataValue:(NSString*)key;
+(NSString*)ReadLanguageValue:(NSString*)key;


+(NSString*)dealErrWithMutable:(NSMutableString*)resultStr;
+(NSString*)dealErr:(NSString*)resultStr;

/********文件操作**************************/
+(BOOL)CreatPreviewImageFileWithName:(NSString*)fileName Type:(NSString*)type Image:(UIImage*)image;

+(BOOL)CreatImageFileWithName:(NSString*)fileName Type:(NSString*)type Image:(UIImage*)image;
+(BOOL)CreatVideoFileWithName:(NSString*)fileName Type:(NSString*)type;
+(NSString*)ReadFileWithName:(NSString*)fileName Type:(NSString*)type;
+(BOOL)RemoveFileWith:(NSString*)fileName Type:(NSString*)type;
+(NSString*) fileSizeAtPath:(NSString*) fileName Type:(NSString*)type;  //获取文件的大小
+(NSString*)fileCreateDateAtPath:(NSString*) fileName Type:(NSString*)type ;   //获取文件的创建时间
+(NSString*)filePlayTimeAtPath:(NSString*)fileName Type:(NSString*)type;      //获取文件视频的播放时长
+ (BOOL)CreateFinishedPath;
+(NSString*)GetFinishedPath;
+(BOOL)IsexitFile:(NSString*)fileName;
+(NSArray*)GetFilesWithType:(NSString*)folderName;


/***********每个账户下的文件操作*************/

+(BOOL)CreateUserIDFolder:(NSString*)userID;
+(NSArray*)GetFilesWithType:(NSString*)folderName UserID:(NSString*)userID;
+(BOOL)CreatImageFileWithName:(NSString*)fileName Type:(NSString*)type Image:(UIImage*)image  UserID:(NSString*)userID;
+(BOOL)CreatVideoFileWithName:(NSString*)fileName Type:(NSString*)type UserID:(NSString*)userID ;
+(NSString*)ReadFileWithName:(NSString*)fileName Type:(NSString*)type UserID:(NSString*)userID;
+(BOOL)RemoveFileWith:(NSString*)fileName Type:(NSString*)type UserID:(NSString*)userID;
+(NSString*) fileSizeAtPath:(NSString*) fileName Type:(NSString*)type UserID:(NSString*)userID;
+(NSString*)fileCreateDateAtPath:(NSString*) fileName Type:(NSString*)type UserID:(NSString*)userID;
+(NSString*)filePlayTimeAtPath:(NSString*)fileName Type:(NSString*)type UserID:(NSString*)userID;
+(BOOL)IsexitFile:(NSString*)fileName UserID:(NSString*)userID;
+(BOOL)IsexitPhotoFile:(NSString *)fileName UserID:(NSString*)userID;



/***************获取系统空间**.
 "***************/
+(long long)freeDiskSpaceInBytes;
+(void)usedSpaceAndfreeSpace;
+(float)getTotalDiskSpaceInBytes;


/**************相册操作********************/
+(void)createAlbumInPhoneAlbum:(NSString*)photoAlbum;
+(void)saveImage:(UIImage*)image  PhotoAlbum:(NSString*)photoAlbum;
+(void)saveToAlbumWithMetadata:(NSDictionary *)metadata
                     imageData:(NSData *)imageData
               customAlbumName:(NSString *)customAlbumName
               completionsBlock:(void (^)(void))completionBlock
                  failureBlock:(void (^)(NSError *error))failureBlock;
+(void)readImageFromGroup;
+(NSMutableArray*)readImage:(NSString*)photoAlbum;;
+(UIImage*)SaveScreenImage:(UIView*)view Imagesize:(CGSize)size;    //截屏

/************转成本地时间****************/
+ (NSDate *)convertDateToLocalTime: (NSDate *)forDate;


/************判断是否为本地wifi***********/
+(BOOL)ISlocalWIFI:(NSString*)deviceID;


+(NSString*)GetSizeToString:(long long)value;
+(BOOL)validateMobile:(NSString *)mobileNum; //判断是否为手机号
+(BOOL)checkNumber:(NSString *)number;

+(NSInteger)indexFisrstofString:(NSString*)str;  //返回在字符串的第一个位置
+(NSInteger)FisrstofString:(NSString *)str;

+(NSString *)gen_uuid;



+(NSString *) getDeviceSSID; //获取ssid
@end
