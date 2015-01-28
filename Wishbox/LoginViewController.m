#import "LoginViewController.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>


@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) NSMutableArray *permissionsArray;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"fonsPrincipal2"]];
    
    self.activityIndicator.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)loginButtonPressed:(UIButton *)sender {
    
    self.activityIndicator.hidden = NO;
    
    NSArray *permissionsArray = @[@"public_profile", @"user_friends"];
    // Set permissions required from the facebook user account
    
    
    // [PFFacebookUtils logInWithPermissionsInBackground:self.permissionsArray]
    
    
    //    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        
        if (user) {
            NSLog(@"User Logged In");
            [self fetchUserData];
        }
        
        if (!user) {
            NSString *errorMessage = nil;
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                errorMessage = @"Uh oh. The user cancelled the Facebook login.";
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
                errorMessage = [error localizedDescription];
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error"
                                                            message:errorMessage
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Dismiss", nil];
            [alert show];
        } else {
            
            if (user.isNew) {
                NSLog(@"User with facebook signed up and logged in! %@", user);
                [self fetchUserData];
            } else {
                NSLog(@"User with facebook logged in! %@", user);
                [self fetchUserData];
            }
            
            
            
        }
    }];
    


}






- (IBAction)cancelButtonPressed:(UIButton *)sender {
    
    self.activityIndicator.hidden = YES;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)fetchUserData {
    // ...
    // Create request for user's Facebook data
    FBRequest *request = [FBRequest requestForMe];
    // Send request to Facebook
    [request startWithCompletionHandler:^(FBRequestConnection
                                          *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook
        
            NSDictionary *userData = (NSDictionary *)result;
            NSLog(@"USER DATA: %@", userData);
            NSString *facebookID = userData[@"id"];
            NSString *name = userData[@"name"];
            //NSString *location = userData[@"location"][@"name"];
            //NSString *gender = userData[@"gender"];
            //NSString *birthday = userData[@"birthday"];
           // NSString *relationship =
           // userData[@"relationship_status"];
           // NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1",facebookID]];
            // Now add the data to the UI elements
            // ... }
            
            PFUser *user = [PFUser currentUser];
            
            [user setObject:name forKey:@"name"];
            [user setObject:facebookID forKey:@"facebookId"];
            
            
            
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"User saved");
                    
                    self.activityIndicator.hidden = YES;
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
                
            }];
        }
    
    }];

}


@end
