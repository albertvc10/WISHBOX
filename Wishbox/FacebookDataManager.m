//
//  FacebookFriendsManager.m
//  Wishbox
//
//  Created by Albert Villanueva on 23/12/14.
//  Copyright (c) 2014 Albert Villanueva. All rights reserved.
//

#import "FacebookDataManager.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "Person.h"

@interface FacebookDataManager ()

@property (nonatomic, strong) NSMutableArray *arrayParse;
@property (nonatomic, strong) NSMutableArray *arrayCoreData;
@end

@implementation FacebookDataManager


+ (void)requestUserInfo{

//Request User Info
[FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
    if (!error) {
        
        // Store the current user's Facebook ID on the user
        NSLog(@"RESULT LOGIN: %@", result);
        
        [[PFUser currentUser] setObject:[result objectForKey:@"id"]
                                 forKey:@"fbId"];
        [[PFUser currentUser]setObject:[result objectForKey:@"name"] forKey:@"fullName"];
        //Url format from User Profile Picture
        NSString *pictureURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=2", [result objectForKey:@"id"]];
        
        [[PFUser currentUser]setObject:pictureURL forKey:@"profilePicture"];
        
        [[PFUser currentUser]saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"User saved in Parse!");
            }
        }];
    }
}];

}

- (void)requestParseFriendsInfo{

    //Request Friends Info
    [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result will contain an array with your user's friends in the "data" key
            NSArray *friendObjects = [result objectForKey:@"data"];
            NSMutableArray *friendIds = [NSMutableArray arrayWithCapacity:friendObjects.count];
            // Create a list of friends' Facebook IDs
            for (NSDictionary *friendObject in friendObjects) {
                [friendIds addObject:[friendObject objectForKey:@"id"]];
            }
            
            // Construct a PFUser query that will find friends whose facebook ids
            // are contained in the current user's friend list.
            PFQuery *friendQuery = [PFUser query];
            [friendQuery whereKey:@"fbId" containedIn:friendIds];
            
            [friendQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (objects) {
                    NSArray *friendUsers = objects;
                    NSLog(@"friend Users: %@", friendUsers);
                    
                    for (PFUser *pfo in friendUsers) {
                        
                        [self.arrayParse addObject:pfo];
                        
                        NSString *name = [pfo objectForKey:@"fullName"];
                        NSLog(@"Name of user: %@", name);
                        
                        NSString *pictureURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=2", [pfo objectForKey:@"fbId"]];
                    }
                    
                }
                else if (!objects)
                {
                    NSLog(@"The are no friends!");
                }
            }];
        }
    }];
}


- (NSArray *)listAllFriends{
    
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    
    fetch.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    NSError *error;
    
    NSArray *arrayRefreshedObjects = [self.managedObjectContext executeFetchRequest:fetch error:&error];
    
    return arrayRefreshedObjects;

}

- (void)saveFacebookFriends{
    
    self.arrayCoreData = [self listAllFriends];
    
    for (PFUser *userParse in self.arrayParse) {
        for (Person *personCD in self.arrayCoreData) {
            if ([[userParse objectForKey:@"objectId"] isEqualToString:personCD.objectId]) {
                
                NSDate *parseDate = [userParse valueForKey:@"updatedAt"];
                
                if ([parseDate compare:personCD.lastUpdatedAt] == NSOrderedDescending) {
                    [self.managedObjectContext deleteObject:personCD];
                    
                    Person *newPerson = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
                    
                    newPerson.name = [userParse valueForKey:@"fullName"];
                    
                }
            }
        }
    }
    
}


@end
