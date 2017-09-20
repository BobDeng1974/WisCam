#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface AudioRecord : NSObject{
    NSURL *recordedFile;
    AVAudioPlayer *player;
    AVAudioRecorder *recorder;
    NSMutableDictionary *recordSetting;
    AVAudioSession *session;
}
@property (nonatomic) BOOL isRecording;
-(id) init;
- (void)StartRecord;
- (NSData*)StopRecord;
@end
