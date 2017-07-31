#import <Foundation/Foundation.h>
#include "aes.h"

@interface SendPacket : NSObject
@property (nonatomic)Byte *pskssid;
@property (nonatomic)int pskssid_len;
-(id)initWithPSK:(NSString *)pskStr andssid:(NSString*)ssidStr;

@end
