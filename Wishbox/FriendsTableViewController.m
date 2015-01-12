#import "FriendsTableViewController.h"
#import "ItemsListViewController.h"
#import "FriendCellTableViewCell.h"
#import "CheckLogin.h"
#import "LoginView.h"
#import "LoginViewController.h"


@interface FriendsTableViewController () <LoginViewDelegate>

@property (nonatomic, strong) NSArray *arrayPersons;
@property (nonatomic, assign) BOOL isUserLoggedIn;
@property (nonatomic, strong) LoginView *loginView;

@end

@implementation FriendsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"fonsPrincipal2"]];
    self.tableView.backgroundView = view;

    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //[FacebookDataManager requestFriendsInfo];
    
    [CheckLogin checkIfUserIsCached];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.isUserLoggedIn = [defaults boolForKey:@"isUserLoggedIn"];
    
    [self displayScreen]; //Depending on userLoggedIn Status
    

}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
        ItemsListViewController *vc = (ItemsListViewController *)[segue destinationViewController];
        vc.friendsMode = YES;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isUserLoggedIn == NO) {
        return 0;
    }
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

        FriendCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendCell"];
        
        
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

@end
