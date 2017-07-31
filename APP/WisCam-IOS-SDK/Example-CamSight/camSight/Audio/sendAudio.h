#import <Foundation/Foundation.h>

@interface sendAudio : NSObject
+(void)sendWithIp:(NSString*)IP port:(int)PORT data:(NSData*)PCMUDATA;
@end
