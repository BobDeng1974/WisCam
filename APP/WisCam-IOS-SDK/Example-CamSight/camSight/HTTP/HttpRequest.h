#import <Foundation/Foundation.h>

@interface HttpRequest : NSObject

@property (nonatomic) int StatusCode;
@property (nonatomic) int ContentLength;
@property (nonatomic) NSString* Connection;
@property (nonatomic) NSString* ContentType;
@property (nonatomic) NSString* Server;
@property (nonatomic) NSData* ResponseData;
@property (nonatomic) NSString* ResponseString;
+(HttpRequest*)HTTPRequestWithUrl:(NSString*)HttpURL andData:(NSString*)PostData andMethod:(NSString*)Method andUserName:(NSString*)UserName andPassword:(NSString*)Password;
@end
