#import <UIKit/UIKit.h>
#import "Wish.h"
@class ItemCellTableViewCell;

@protocol WishStatusDelegate <NSObject>
@required
- (void)didSelectWish:(Wish *)wish wishBooked:(BOOL)booked;
@optional
@end


@interface ItemCellTableViewCell : UITableViewCell

{
    id<WishStatusDelegate>_delegate;
}
@property (nonatomic, strong)id delegate;
@property (nonatomic, strong) Wish *wish;
@property (nonatomic, assign) BOOL isFromUser;
@end
