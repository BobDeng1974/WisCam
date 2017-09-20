#import <UIKit/UIKit.h>

@interface ShowVideoController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    UIView *titleView;
    UIImageView* bgShowVideo;
    UIButton* btnShowVideoBack;
    UITableView *ShowVideoTableview;
    UILabel *lableEditVideo;
}
@end
