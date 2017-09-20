#import <Foundation/Foundation.h>

@interface CDate : NSObject

+(NSString*)GetStringDate:(NSDate*) nsDate;
+(NSString*)GetStringDateWithFormat:(NSDate*) nsDate format:(NSString*)format;
+(NSString*)GetStringNow;
+(NSString*)GetStringDateWithStrDateFormat:(NSString*) strDate format:(NSString*)format;
+(NSString*)GetStringNowWithFormat:(NSString*)format;

+(NSDate*)GetDate:(NSString *) strDate;
+(NSDate*)GetDateWithFormat:(NSString *) strDate format:(NSString*)format;
+(NSDate*)GetNow;


+(NSString*)GetHisvideoTime:(NSString*)fileName;
@end
