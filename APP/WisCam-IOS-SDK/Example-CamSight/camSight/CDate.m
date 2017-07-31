#import "CDate.h"

@implementation CDate

+(NSString*)GetStringDate:(NSDate*) nsDate
{
    
    return  [self GetStringDateWithFormat:nsDate format:@"yyyy-MM-dd HH:mm:ss"];
}
+(NSString*)GetStringDateWithFormat:(NSDate*) nsDate format:(NSString*)format
{
    NSDateFormatter * formater=[[NSDateFormatter alloc] init];
    [formater setDateFormat:format];
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    [formater setTimeZone:localTimeZone];
    return [formater stringFromDate:nsDate];
}
+(NSString*)GetStringNow
{
    return [self GetStringDate:[NSDate date]];
    
}

+(NSString*)GetStringDateWithStrDateFormat:(NSString*) strDate format:(NSString*)format
{
    NSDate *date=[self GetDate:strDate];
    return [self GetStringDateWithFormat:date format:format];
}

+(NSString*)GetStringNowWithFormat:(NSString*)format
{
    
    return [self GetStringDateWithFormat:[NSDate date] format:format];
    
}

+(NSDate*)GetDate:(NSString *) strDate
{
    
    return [self GetDateWithFormat:strDate format:@"yyyy-MM-dd HH:mm:ss"];
    
}

+(NSDate*)GetDateWithFormat:(NSString *) strDate format:(NSString*)format
{
    NSDateFormatter * formater=[[NSDateFormatter alloc] init];
    [formater setDateFormat:format];
    return [formater dateFromString:strDate];
    
}
+(NSDate*)GetNow
{
    return [NSDate date];
    
}


+(NSString*)GetHisvideoTime:(NSString*)fileName
{
    NSString * dateStr=nil;
    NSString * fffff=[fileName stringByReplacingOccurrencesOfString:@"_" withString:@""];
    NSString * sub=[fffff substringWithRange:NSMakeRange(fffff.length-18, 14)];
    sub=[sub stringByReplacingOccurrencesOfString:@"_" withString:@""];
    NSDate *date=[CDate GetDateWithFormat:sub format:@"yyyyMMddHHmmss"];
    dateStr=[self GetStringDate:date];
    return dateStr;
}


@end
