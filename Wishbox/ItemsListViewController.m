#import "ItemsListViewController.h"
#import "NewItemTableViewController.h"
#import "ItemCellTableViewCell.h"
#import "Person.h"
#import "Wish.h"
#import "FriendCellTableViewCell.h"
#import "DetailTableViewController.h"
#import "CheckLogin.h"



@interface ItemsListViewController ()

@property (nonatomic, strong) NSArray *arrayWishes;
@property (nonatomic, strong) NSMutableArray *arrayUserWishes;
@property (nonatomic, assign) BOOL isUserLoggedIn;

@end


@implementation ItemsListViewController

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [CheckLogin checkIfUserIsCached];
   
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.isUserLoggedIn = [defaults boolForKey:@"isUserLoggedIn"];
    
    if (self.friendsMode == YES) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    else {
        self.navigationItem.leftBarButtonItem= self.editButtonItem;
    }
    
    if (self.isUserLoggedIn == YES) {
        
        self.refreshControl = [[UIRefreshControl alloc] init];
        [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
        [self.refreshControl setTintColor:[UIColor whiteColor]];

        
        //Show refresh control over background image from TableView
        self.refreshControl.layer.zPosition = self.tableView.backgroundView.layer.zPosition + 1;

        
    }else{
        
//        ParseCoreDataManager *parseCoreDataManager = [[ParseCoreDataManager alloc]init];
//        parseCoreDataManager.managedObjectContext = self.managedObjectContext;
//        self.arrayWishes = [parseCoreDataManager requestRefreshedObjects];
        
        [self.tableView reloadData];
        
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIImageView *view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"fonsPrincipal2"]];
    self.tableView.backgroundView = view;
    
    if (self.isUserLoggedIn) {
        
//        ParseCoreDataManager *parseCoreDataManager = [[ParseCoreDataManager alloc]init];
//        parseCoreDataManager.managedObjectContext = self.managedObjectContext;
//        parseCoreDataManager.delegate = self;
//        self.arrayWishes = [parseCoreDataManager arrayWishesInCoreData];

    }
}

#pragma mark TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.friendsMode == YES) {

        return [self.arrayWishes count];
    }
    else{
#warning modify this later
       return [self.arrayWishes count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    ItemCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"itemCell"];
    
    if (self.friendsMode == YES) {
        
      cell.wish = [self.arrayWishes objectAtIndex:indexPath.row];
      cell.isFromUser = NO;
        cell.delegate = self;
    }
    else{
        
       // NSArray *array = [self.user.wishes allObjects];
        
        //self.arrayUserWishes = [[NSMutableArray alloc]initWithArray:array];
        
        cell.wish = [self.arrayWishes objectAtIndex:indexPath.row];
        cell.isFromUser = YES;
        
    }

    return cell;
}

#pragma mark UITableViewDelegate 

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //DELETE ITEMS FROM LIST
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Do all the insertRowAtIndexPath and all the changes to the data source array
        
        Wish *wish = [self.arrayWishes objectAtIndex:indexPath.row];
        
        [self.managedObjectContext deleteObject:wish];

        [self.managedObjectContext save:nil];
        //[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

    }
}

#pragma mark Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([sender isKindOfClass:[UIBarButtonItem class]]) {
        if (self.friendsMode == NO) {
            UINavigationController *nc = (UINavigationController *)[segue destinationViewController];
            NewItemTableViewController *vc = (NewItemTableViewController *)[nc viewControllers][0];
        }
    }
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        
        DetailTableViewController *vc = (DetailTableViewController *)[segue destinationViewController];
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        if (self.friendsMode == YES) {
            //self.wish = [self.arrayWishes objectAtIndex:indexPath.row];
        }
        else {
            //self.wish = [self.arrayWishes objectAtIndex:indexPath.row];
        }
        
        //vc.wish = self.wish;
    }
    
}





@end
