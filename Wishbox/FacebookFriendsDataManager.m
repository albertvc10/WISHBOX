//
//  FacebookFriendsDataManager.m
//  Wishbox
//
//  Created by Albert Villanueva on 19/1/15.
//  Copyright (c) 2015 Albert Villanueva. All rights reserved.
//

#import "FacebookFriendsDataManager.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "Wish.h"


@interface FacebookFriendsDataManager ()

@property (nonatomic, strong) NSMutableArray *arrayFriends;
@property (nonatomic, strong) NSMutableArray *arrayWishes;

@end

@implementation FacebookFriendsDataManager

-(NSMutableArray *)arrayFriends{
    
    if (!_arrayFriends) {
        _arrayFriends = [[NSMutableArray alloc]init];
    }
    return _arrayFriends;
    
}

-(NSMutableArray *)arrayWishes{
    
    if (!_arrayWishes) {
        _arrayWishes = [[NSMutableArray alloc]init];
    }
    return _arrayWishes;
}

- (void)requestFacebookFriendsInfo{
    
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
            [self.arrayFriends removeAllObjects];
            
            PFQuery *friendQuery = [PFUser query];
            [friendQuery whereKey:@"facebookId" containedIn:friendIds];
            
            [friendQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                
                [PFObject unpinAllObjectsInBackgroundWithName:@"MyFriends" block:^(BOOL succeeded, NSError *error) {
                    
                    if (objects) {
                        NSArray *friendUsers = objects;
                        NSLog(@"friend Users: %@", friendUsers);
                        
                        for (PFUser *pfo in friendUsers) {
                            
                            NSString *name = [pfo objectForKey:@"name"];
                            NSLog(@"Name of user: %@", name);
                            NSString *pictureURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=2", [pfo objectForKey:@"facebookId"]];
                            Person *newPerson = [[Person alloc]init];
                            newPerson.name = name;
                            newPerson.imageURL = pictureURL;
                            newPerson.user = pfo;
                            
                            [self.arrayFriends addObject:newPerson];
                            
                        }
                        
                        
                        [PFObject pinAllInBackground:objects withName:@"MyFriends" block:^(BOOL succeeded, NSError *error) {
                            if (succeeded) {
                                NSLog(@"Remote object pinned in Local Data");
                                
                                [self.delegate parseDidFinishDownloadingFacebookFriends:self.arrayFriends];
                                
                            }
                        }];
                        
                        
                    }
                    else if (!objects)
                    {
                        NSLog(@"The are no friends! Get a life...🙈");
                    }
                    
                }];
                
      
            }];
        }
    }];

}



- (void)retrieveLocalFriendObjects{
    
    
    PFQuery *query = [PFUser query];
    [query fromPinWithName:@"MyFriends"];
    [query orderByDescending:@"name"];
    
    [self.arrayFriends removeAllObjects];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects) {
            NSLog(@"Objects!!!!!! %@", objects);
            
            for (PFUser *pfo in objects) {
                
                NSString *name = [pfo objectForKey:@"name"];
                NSLog(@"Name of user: %@", name);
                NSString *pictureURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=2", [pfo objectForKey:@"facebookId"]];
                Person *newPerson = [[Person alloc]init];
                newPerson.name = name;
                newPerson.imageURL = pictureURL;
                newPerson.user = pfo;
                
                [self.arrayFriends addObject:newPerson];
                
            }
             [self.delegate parseDidFinishDownloadingFacebookFriends:self.arrayFriends];

        }
    }];
    
    
    
}


- (void)requestFriendWishesInfo:(Person *)person{
    
    [self.arrayWishes removeAllObjects];
    
  PFQuery *query = [PFQuery queryWithClassName:@"Wishes"];
    [query whereKey:@"user" equalTo:person.user];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"OBJECTS: %@", objects);
        
        for (PFObject *object in objects) {
            NSString *name = [object valueForKey:@"name"];
            NSNumber *price = [object valueForKey:@"price"];
            NSString *textDescription = [object valueForKey:@"textDescription"];
            PFUser *user = [object valueForKey:@"user"];
            NSNumber *isBooked = [object valueForKey:@"isBooked"];
            NSNumber *latitude = [object valueForKey:@"latitude"];
            NSNumber *longitude = [object valueForKey:@"longitude"];
            PFFile *imageFile = [object valueForKey:@"image"];
            NSString *objectId = [object valueForKey:@"objectId"];
            
            Wish *newWish = [[Wish alloc]init];
            
            newWish.name = name;
            newWish.price = price;
            newWish.textDescription = textDescription;
            newWish.user = user;
            newWish.isBooked = [isBooked boolValue];
            newWish.latitude = latitude;
            newWish.longitude = longitude;
            newWish.image = imageFile;
            newWish.objectId = objectId;
            
            [self.arrayWishes addObject:newWish];
        }
        
        [self.delegate parseDidFinishDownloadingFriendsWishes:self.arrayWishes];
        
    }];
    
    
}

@end
