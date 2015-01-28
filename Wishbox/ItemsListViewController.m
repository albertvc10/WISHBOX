
#import "ItemsListViewController.h"
#import "NewItemTableViewController.h"
#import "ItemCellTableViewCell.h"
#import "Person.h"
#import "Wish.h"
#import "FriendCellTableViewCell.h"
#import "DetailTableViewController.h"
#import "CheckLogin.h"
#import "ParseLocalDataManager.h"
#import "FacebookFriendsDataManager.h"
#import "EmptyTable.h"



@interface ItemsListViewController () <ParseDataManagerDelegate, FacebookFriendsDataManagerDelegate, WishStatusDelegate>

@property (nonatomic, strong) NSArray *arrayWishes;
@property (nonatomic, strong) NSMutableArray *arrayUserWishes;
@property (nonatomic, assign) BOOL isUserLoggedIn;
@property (nonatomic, strong) ParseLocalDataManager *localDataManager;
@property (nonatomic, strong) FacebookFriendsDataManager *facebookDataManager;
@property (nonatomic, strong) PFUser *lastUser;
@property (nonatomic) BOOL isFirstTime;
@property (nonatomic, strong) Wish *wish;
@property (nonatomic, strong) EmptyTable *emptyTable;


@end


@implementation ItemsListViewController

- (ParseLocalDataManager *)localDataManager{
    
    if (!_localDataManager) {
        _localDataManager = [[ParseLocalDataManager alloc]init];
    }
    return _localDataManager;
}

- (FacebookFriendsDataManager *)facebookDataManager{
    
    if (!_facebookDataManager) {
        _facebookDataManager = [[FacebookFriendsDataManager alloc]init];
    }
    return _facebookDataManager;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"fonsPrincipal2"]];
    self.tableView.backgroundView = view;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [CheckLogin checkIfUserIsCached];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.isUserLoggedIn = [defaults boolForKey:@"isUserLoggedIn"];
    
    self.lastUser = [PFUser currentUser];

    self.localDataManager.delegate = self;
    
    if (self.friendsMode == NO) {
        if (self.isUserLoggedIn == YES) {
            [self.localDataManager downloadParseRemoteObjects];

        }
    }
    
    self.isFirstTime = YES;
}


-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBarItem.title = nil;
    
    if (self.isFirstTime == NO) {
        [CheckLogin checkIfUserIsCached];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.isUserLoggedIn = [defaults boolForKey:@"isUserLoggedIn"];
        
        
    }else{
        self.isFirstTime = NO;
    }

    if (self.friendsMode == YES) {
        self.navigationItem.rightBarButtonItem = nil;
        self.facebookDataManager.delegate = self;        
        [self.facebookDataManager requestFriendWishesInfo:self.person];
    }
    else {
        self.title = @"My List";
        self.navigationItem.leftBarButtonItem= self.editButtonItem;
        
        if (self.isUserLoggedIn == YES) {
            
            if (self.isFirstTime == NO) {
                if (self.lastUser) {
                    [self.localDataManager retrieveLocalObjects];
                }else{
                    [self.localDataManager downloadParseRemoteObjects];
                    self.lastUser = [PFUser currentUser];
                }
                
            }

            self.refreshControl = [[UIRefreshControl alloc] init];
            [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
            [self.refreshControl setTintColor:[UIColor whiteColor]];
            
            //Show refresh control over background image from TableView
            self.refreshControl.layer.zPosition = self.tableView.backgroundView.layer.zPosition + 1;
            
        }else{
           
            self.refreshControl = nil;
            [self.localDataManager retrieveLocalObjects];
        }

    }
    
    
}

#pragma mark TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.friendsMode == YES) {
        if ([self.arrayWishes count]) {
             self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            for (EmptyTable *emptyTable in self.view.subviews) {
                if ([emptyTable isKindOfClass:[EmptyTable class]]) {
                    [emptyTable removeFromSuperview];
                }
            }

            return 1;
        }
        else{
             self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            
            if (!self.emptyTable) {
                self.emptyTable = [[EmptyTable alloc]init];
                self.emptyTable.center = CGPointMake(self.view.center.x, self.view.frame.size.height - (self.emptyTable.frame.size.height /2));
                self.emptyTable.topLabel.text = [NSString stringWithFormat:@"%@ still doesn't have any Wish", self.person.name];
                [self.emptyTable.bottomLabel setHidden:YES];
                [self.emptyTable.plusButton setHidden:YES];
                
            }
            
            [self.view addSubview:self.emptyTable];

      

            return 1;
        }
    }
    else{
        if ([self.arrayUserWishes count]) {
             self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            
            for (EmptyTable *emptyTable in self.view.subviews) {
                if ([emptyTable isKindOfClass:[EmptyTable class]]) {
                    [emptyTable removeFromSuperview];
                }
            }
            
            return 1;
        }
        else{
             self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            
            if (!self.emptyTable) {
                self.emptyTable = [[EmptyTable alloc]init];
                self.emptyTable.center = CGPointMake(self.view.center.x, self.view.frame.size.height - (self.emptyTable.frame.size.height /2));

            }
            
            [self.view addSubview:self.emptyTable];
            
            return 1;
        }
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.friendsMode == YES) {

        return [self.arrayWishes count];
    }
    else{

       return [self.arrayUserWishes count];
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
        
        
        cell.wish = [self.arrayUserWishes objectAtIndex:indexPath.row];
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
        
        if (self.isUserLoggedIn == YES) {
            
            Wish *wish = [self.arrayUserWishes objectAtIndex:indexPath.row];
            [self.arrayUserWishes removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            [self.localDataManager removeWish:wish];

        }else{
            
            Wish *wish = [self.arrayUserWishes objectAtIndex:indexPath.row];
            
            [self.arrayUserWishes removeObjectAtIndex:indexPath.row];
            [self.localDataManager removeLocalWish:wish];
            
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            
            
        }
  
        
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
            self.wish = [self.arrayWishes objectAtIndex:indexPath.row];
        }
        else {
            self.wish = [self.arrayUserWishes objectAtIndex:indexPath.row];
        }
        
        vc.wish = self.wish;
    }
    
}


#pragma mark Parse Data Manager Delegate

- (void)parseDidFinishDownloadingLocalObjects:(NSMutableArray *)objects{
    
    self.arrayUserWishes = objects;
    
   //        dispatch_sync(dispatch_get_main_queue(), ^{
//                   });

    
    [self.tableView reloadData];


}

- (void)parseDidFinishDownloadingRemoteObjects:(NSMutableArray *)objects{
    
    self.arrayUserWishes = objects;
    
    if ([objects count]) {
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            
//        });
        [self.refreshControl endRefreshing];
        
        [self.tableView reloadData];

    }
}

#pragma mark Facebook Data Manager Delegate

- (void)parseDidFinishDownloadingFriendsWishes:(NSArray *)wishes{
    
    self.arrayWishes = wishes;
    
    [self.tableView reloadData];
    
    
}


#pragma mark UIRefreshControl

- (void)refresh:(UIRefreshControl *)refreshControl {

    [self.localDataManager downloadParseRemoteObjects];

    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:@"Refreshing..."];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,13)];
    self.refreshControl.attributedTitle = string;
    
    
}



#pragma mark WishStatus Delegate

-(void)didSelectWish:(Wish *)wish wishBooked:(BOOL)booked{
    
    NSLog(@"Wish selected: %@ and is Booked %@", wish, (booked ? @"YES" : @"NO"));
    
    
    PFObject *updatedWish = [PFObject objectWithoutDataWithClassName:@"Wishes" objectId:wish.objectId];

    
    [updatedWish setObject:[NSNumber numberWithBool:booked] forKey:@"isBooked"];
    
    [updatedWish saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"PFObject Updated!!");
        }
        if (error) {
            NSLog(@"ALERT ERROR!!");
        }
        
    }];

    
    if (wish.isBooked == YES) {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:wish.name
                                      message:@"You have booked this Wish"
                                      preferredStyle:UIAlertControllerStyleActionSheet];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        [alert addAction:ok];     }
    else {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:wish.name
                                      message:@"You have released this Wish"
                                      preferredStyle:UIAlertControllerStyleActionSheet];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        [alert addAction:ok];
    }
    
}


@end
