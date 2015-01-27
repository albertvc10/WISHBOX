#import "ProfileViewController.h"
#import <Parse/Parse.h>
#import "CheckLogin.h"
#import "LoginView.h"
#import "LoginViewController.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>

@interface ProfileViewController () <LoginViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (nonatomic, assign) BOOL isUserLoggedIn;
@property (weak, nonatomic) IBOutlet UILabel *numberFriendsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberWishesLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendsLabel;
@property (weak, nonatomic) IBOutlet UILabel *wishesLabel;
@property (weak, nonatomic) IBOutlet UIImageView *wishesImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bar;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userCityLabel;
@property (nonatomic, strong) LoginView *loginView;
@property (nonatomic) BOOL isFirstTime;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [CheckLogin checkIfUserIsCached];
    
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"fonsPrincipal2"]];
    UIImageView *backgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height - self.tabBarController.tabBar.bounds.size.height)];
    backgroundView.image = [UIImage imageNamed:@"fonsPrincipal2"];
    [self.view addSubview:backgroundView];
    self.userImageView.clipsToBounds = YES;
    self.userImageView.layer.cornerRadius = 57;
    
    self.isFirstTime = NO;

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    
    [CheckLogin checkIfUserIsCached];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.isUserLoggedIn = [defaults boolForKey:@"isUserLoggedIn"];
    
    [self displayScreen];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
//    if ([segue.identifier isEqualToString:@"logOutSegue"]) {
//        [PFUser logOut];
//        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isUserLoggedIn"];
//        NSLog(@"PFUser logged Out");
//    }
}


- (void)displayScreen{
    
    if (self.isUserLoggedIn == NO) {
        
        //hide views
        self.userImageView.hidden = YES;
        self.userImageView.hidden = YES;
        self.numberFriendsLabel.hidden = YES;
        self.numberWishesLabel.hidden = YES;
        self.friendsLabel.hidden = YES;
        self.wishesLabel.hidden = YES;
        self.userNameLabel.hidden = YES;
        self.userCityLabel.hidden = YES;
        self.bar.hidden = YES;
        [self.navigationItem setRightBarButtonItem:nil animated:YES];
        
        if (!self.loginView) {
            LoginView *loginView = [[LoginView alloc]init];
            loginView.delegate = self;
            loginView.center = CGPointMake(self.view.center.x, self.view.frame.size.height - (loginView.frame.size.height /2));
            self.loginView = loginView;
            
            
        }
        
        [self.view addSubview:self.loginView];
        self.loginView.label.text = @"This App is related to Facebook API. You must have an account to Log In";
    
    }else {
        
        for (UIView *view in self.view.subviews) {
            if (![view isKindOfClass:[LoginView class]]) {
                view.hidden = NO;
            }
            else {
                [view removeFromSuperview];
            }
            if (self.isFirstTime == NO) {
                [self uploadUserInfo];
                self.isFirstTime = YES;
            }
            
            
        }
        
        //Show logOut Button
        if (!self.navigationItem.rightBarButtonItem) {
            UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"Log Out" style:UIBarButtonItemStylePlain target:self action:@selector(logOutButtonTapped)];
            self.navigationItem.rightBarButtonItem = rightButton;
        }
    }
    
}


- (void)logOutButtonTapped{
    
    self.isUserLoggedIn = NO;
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
//    dispatch_async(queue, ^(void) {

        [PFUser logOut];
//        dispatch_sync(dispatch_get_main_queue(), ^{
    
    [PFObject unpinAllObjectsInBackgroundWithName:@"MyWishes"];
    [PFObject unpinAllObjectsInBackgroundWithName:@"MyFriends"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:@"isUserLoggedIn"];
    
    [defaults synchronize];
    
    [self displayScreen];
    
//        });
//    });
//
    
}


#pragma mark LoginView Delegate

- (void)buttonTapped{
    
   LoginViewController *vc = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"logInViewController"];
    
    [self presentViewController:vc animated:YES completion:nil];
    
}


- (void)uploadUserInfo{
    
    NSString *objectId = [[PFUser currentUser]valueForKey:@"objectId"];
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"objectId" equalTo:objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects) {
            NSLog(@"Objects: %@", objects);
            
            PFUser *user = [objects objectAtIndex:0];
                
                NSString *name = [user valueForKey:@"name"];
                NSNumber *numWishes = [user valueForKey:@"numWishes"];
                NSString *fbId = [user objectForKey:@"facebookId"];
                NSString *pictureURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=2", fbId];
                
                NSURL *url = [NSURL URLWithString:pictureURL];
                NSData *data = [NSData dataWithContentsOfURL:url];
                UIImage *image = [UIImage imageWithData:data];
                
                self.userImageView.image = image;
                self.numberWishesLabel.text = [NSString stringWithFormat:@"%@", numWishes];
                self.userNameLabel.text = name;           

            
            //Update UI
            
            
            
        }
    }];
    
    
    
}


@end
