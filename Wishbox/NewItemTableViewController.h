#import <UIKit/UIKit.h>
#import "MapAnnotation.h"
#import "CoreDataStack.h"
#import "Wish.h"
#import "Person.h"

@interface NewItemTableViewController : UITableViewController

@property (nonatomic, strong) MapAnnotation *annotation;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) Person *person;


@end
