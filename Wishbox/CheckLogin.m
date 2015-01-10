//
//  CheckLogin.m
//  Wishbox
//
//  Created by Albert Villanueva on 11/12/14.
//  Copyright (c) 2014 Albert Villanueva. All rights reserved.
//

#import "CheckLogin.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>


@implementation CheckLogin


+ (void)checkIfUserIsCached {
    

    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([PFUser currentUser] && // Check if user is cached
        [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) { // Check if user is linked to Facebook
        
        [defaults setBool:YES forKey:@"isUserLoggedIn"];
    }
    else {
        [defaults setBool:NO forKey:@"isUserLoggedIn"];
    }
}

@end
