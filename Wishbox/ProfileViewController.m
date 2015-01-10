#import "ProfileViewController.h"
#import <Parse/Parse.h>
#import "CheckLogin.h"
#import "LoginView.h"
#import "LoginViewController.h"

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

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"fonsPrincipal2"]];
    self.userImageView.clipsToBounds = YES;
    self.userImageView.layer.cornerRadius = 57;

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [CheckLogin checkIfUserIsCached];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.isUserLoggedIn = [defaults boolForKey:@"isUserLoggedIn"];
    
    [self displayScreen];
    

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"logOutSegue"]) {
        [PFUser logOut];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isUserLoggedIn"];
        NSLog(@"PFUser logged Out");
    }
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
        
        
    }else {
        
        for (UIView *view in self.view.subviews) {
            if (![view isKindOfClass:[LoginView class]]) {
                view.hidden = NO;
            }
            else {
                view.hidden = YES;
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
    
    [PFUser logOut];
    self.isUserLoggedIn = NO;
    [self displayScreen];
}


#pragma mark LoginView Delegate

- (void)buttonTapped{
    
   LoginViewController *vc = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"logInViewController"];
    
    [self presentViewController:vc animated:YES completion:nil];
    
}



@end
