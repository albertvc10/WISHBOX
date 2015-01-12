#import <UIKit/UIKit.h>
#import "Person.h"
#import "Wish.h"



@interface ItemsListViewController : UITableViewController 

@property (nonatomic, assign) BOOL friendsMode;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) Person *person;

@end

