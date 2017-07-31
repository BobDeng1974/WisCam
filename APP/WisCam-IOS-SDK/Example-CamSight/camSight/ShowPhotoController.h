#import <UIKit/UIKit.h>

@interface ShowPhotoController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UIView *titleView;
    UIImageView* bgShowPhoto;
    UIButton* btnShowPhotoBack;
    UITableView* ShowPhotoTableview;
    UIImageView* bgPhotoView;
    UILabel *lableEditPhoto;
}
@end
