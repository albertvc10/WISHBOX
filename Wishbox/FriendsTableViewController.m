#import "FriendsTableViewController.h"
#import "ItemsListViewController.h"
#import "FriendCellTableViewCell.h"
#import "CheckLogin.h"
#import "LoginView.h"
#import "LoginViewController.h"
#import "FacebookFriendsDataManager.h"
#import "EmptyTable.h"

@interface FriendsTableViewController () <LoginViewDelegate, FacebookFriendsDataManagerDelegate>

@property (nonatomic, strong) NSArray *arrayPersons;
@property (nonatomic, assign) BOOL isUserLoggedIn;
@property (nonatomic, strong) LoginView *loginView;
@property (nonatomic, strong) FacebookFriendsDataManager *facebookFriendsManager;
@property (nonatomic) BOOL isFirstTime;
@property (nonatomic, strong) EmptyTable *emptyTable;

@end

@implementation FriendsTableViewController


- (FacebookFriendsDataManager *)facebookFriendsManager{
    
    if (!_facebookFriendsManager) {
        _facebookFriendsManager = [[FacebookFriendsDataManager alloc]init];
    }
    return _facebookFriendsManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"fonsPrincipal2"]];
    self.tableView.backgroundView = view;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.isFirstTime = YES;


    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //[FacebookDataManager requestFriendsInfo];
    
    [CheckLogin checkIfUserIsCached];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.isUserLoggedIn = [defaults boolForKey:@"isUserLoggedIn"];
    
    [self displayScreen]; //Depending on userLoggedIn Status
    
    if (self.isUserLoggedIn == YES) {
        self.facebookFriendsManager.delegate = self;
        if (self.isFirstTime == YES) {
            [self.facebookFriendsManager requestFacebookFriendsInfo];
            self.isFirstTime = NO;
        }
        else {
            [self.facebookFriendsManager retrieveLocalFriendObjects];
        }
        
    }
    

}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
        ItemsListViewController *vc = (ItemsListViewController *)[segue destinationViewController];
        vc.friendsMode = YES;
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        Person *person = [self.arrayPersons objectAtIndex:path.row];
        vc.person = person;
    vc.title = person.name;

}


#pragma mark TablViewData Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.arrayPersons count]) {
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        for (EmptyTable *emptyTable in self.view.subviews) {
            if ([emptyTable isKindOfClass:[EmptyTable class]]) {
                [emptyTable removeFromSuperview];
            }
        }
        
        
        return 1;
    }else{
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        if (self.isUserLoggedIn == YES) {
            if (!self.emptyTable) {
                self.emptyTable = [[EmptyTable alloc]init];
                self.emptyTable.center = CGPointMake(self.view.center.x, self.view.frame.size.height - (self.emptyTable.frame.size.height /2));
                self.emptyTable.topLabel.text = @"You still don't have any friend in Wishbox";
                self.emptyTable.bottomLabel.text = @"Invite your friends to use Wishbox";
                [self.emptyTable.plusButton setHidden:YES];
                
            }
            
            [self.view addSubview:self.emptyTable];
        }
        
        return 1;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isUserLoggedIn == NO) {
        return 0;
    }
    else{
        
        
        return [self.arrayPersons count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

        FriendCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendCell"];
    
        cell.person = [self.arrayPersons objectAtIndex:indexPath.row];
    
        
        return cell;
}

- (void)displayScreen{
    
    if (self.isUserLoggedIn == NO) {
        
        if (!self.loginView) {
            LoginView *loginView = [[LoginView alloc]init];
            loginView.delegate = self;
            loginView.center = CGPointMake(self.view.center.x, self.view.frame.size.height - (loginView.frame.size.height /2));
            self.loginView = loginView;
        }
        
        [self.view addSubview:self.loginView];
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.scrollEnabled = NO;

    }else {
        
        for (LoginView *loginView in self.view.subviews) {
            if ([loginView isKindOfClass:[LoginView class]]) {
                [loginView removeFromSuperview];
            }
        }
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.scrollEnabled = YES;
        
    }
    
}


#pragma mark LoginView Delegate

- (void)buttonTapped{
    
    LoginViewController *vc = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"logInViewController"];
    
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark Facebook Data Manager Delegate

- (void)parseDidFinishDownloadingFacebookFriends:(NSArray *)friends{
    
    self.arrayPersons = friends;
    
    [self.tableView reloadData];
    
}



@end
