#import <Foundation/Foundation.h>

@interface RecvPacket : NSObject
@property (nonatomic)NSString *module_id;
@property (nonatomic)NSString *module_ip;
@end

@protocol EasyConfigDelegate <NSObject>
-(void)RecvWithPacket:(RecvPacket *)recvPacket;
@end

@interface EasyConfig : NSObject
@property(nonatomic,retain) id <EasyConfigDelegate> delegate;
-(id) init:(id<EasyConfigDelegate>)delegate;
- (void)SendDataWithPsk:(NSString *)psk andSSID:(NSString*)SSID;
- (void)stop_send;
@end
