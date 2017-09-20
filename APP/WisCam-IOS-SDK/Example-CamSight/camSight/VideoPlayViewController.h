#import <UIKit/UIKit.h>

@interface VideoPlayViewController : UIViewController
{
    CGSize videoSize;
    UILabel *l_recodevideo;
    UIButton *button_slider;
    UIView *view_slider;
    UIButton *videoBack;
    UIView *view_control;
    UIButton *button_savepicture;
    UIButton *button_recodevideo;
    UIButton *button_playback;
    UIButton *button_voice;
}

@property (nonatomic) BOOL isPlayurl;
- (NSString *)stringFromDate:(NSDate *)date;

@end
