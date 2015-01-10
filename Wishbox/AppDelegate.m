#import "AppDelegate.h"
#import "ItemsListViewController.h"
#import "FriendsTableViewController.h"
#import "ProfileViewController.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <Parse/Parse.h>

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [Parse setApplicationId:@"aYQSirqj2R0YWMKPwgYELi23WBp4Mt8w2qqA4xoB"
                  clientKey:@"kBG0DJhHtkztEU4a7WRPCg6rlehqaRcuRsXgrkTA"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [PFFacebookUtils initializeFacebook];

    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navBar"] forBarMetrics:UIBarMetricsDefault];

    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackOpaque];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTranslucent:NO];
    
    [[UITabBar appearance] setBarTintColor:[UIColor blackColor]];

    
    [[UITableViewCell appearance] setBackgroundColor:[UIColor clearColor]];
    
    [[UIToolbar appearance] setBackgroundImage:[UIImage imageNamed:@"navBar"] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [[UIToolbar appearance]setTranslucent:NO];
    [[UIToolbar appearance]setTintColor:[UIColor whiteColor]];
    
    
#warning Check if this code is needed before updating to the App Store
    UITabBarController *tabBar = (UITabBarController *)self.window.rootViewController;
    
    UINavigationController *nc = (UINavigationController *)[tabBar viewControllers][0];
    ItemsListViewController *vc = (ItemsListViewController *)nc.topViewController;

    
    UINavigationController *nc2 = (UINavigationController *)[tabBar viewControllers][1];
    FriendsTableViewController *vc2 = (FriendsTableViewController *)nc2.topViewController;

    
    UINavigationController *nc3 = (UINavigationController *)[tabBar viewControllers][2];
    ProfileViewController *vc3 = (ProfileViewController *)nc3.topViewController;
   
    
    //CUSTOM TABBAR
    UITabBarController *tabBarController = tabBar;
    UIImage *image = [[UIImage imageNamed:@"tabBarItem1"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *imagSel = [[UIImage imageNamed:@"tabBarItem1Sel"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *tabItem = [tabBarController.tabBar.items objectAtIndex: 0];
    tabItem.image = image;
    tabItem.selectedImage = imagSel;
    tabItem.title = nil;
    
    
    UIImage *image2 = [[UIImage imageNamed:@"tabBarItem2"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *imagSel2 = [[UIImage imageNamed:@"tabBarItem2Sel"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *tabItem2 = [tabBarController.tabBar.items objectAtIndex: 1];
    tabItem2.image = image2;
    tabItem2.selectedImage = imagSel2;
    tabItem2.title = nil;
    
    UIImage *image3 = [[UIImage imageNamed:@"tabBarItem3"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *imagSel3 = [[UIImage imageNamed:@"tabBarItem3Sel"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *tabItem3 = [tabBarController.tabBar.items objectAtIndex: 2];
    tabItem3.image = image3;
    tabItem3.selectedImage = imagSel3;
    tabItem3.title = nil;

    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
     [[PFFacebookUtils session] close];
    
}

@end
