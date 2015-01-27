//
//  ParseLocalDataManager.m
//  Wishbox
//
//  Created by Albert Villanueva on 10/1/15.
//  Copyright (c) 2015 Albert Villanueva. All rights reserved.
//

#import "ParseLocalDataManager.h"
#import <Parse/Parse.h>

@interface ParseLocalDataManager ()

@property (nonatomic) BOOL isUserLoggedIn;

@property (nonatomic, strong)NSMutableArray *arrayWishes;
@property (nonatomic, strong) NSMutableArray *arrayLocalWishes;

@end

@implementation ParseLocalDataManager

-(NSMutableArray *)arrayWishes{
    
    if (!_arrayWishes) {
        _arrayWishes = [[NSMutableArray alloc]init];
    }
    return _arrayWishes;
}

- (NSMutableArray *)arrayLocalWishes{
    
    if (!_arrayLocalWishes) {
        _arrayLocalWishes = [[NSMutableArray alloc]init];
    }
    return _arrayLocalWishes;
}

- (void)downloadParseRemoteObjects{

    PFQuery *query = [PFQuery queryWithClassName:@"Wishes"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    // Query for new results from the network
    [query orderByDescending:@"name"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [PFObject unpinAllObjectsInBackgroundWithName:@"MyWishes" block:^(BOOL succeeded, NSError *error) {
            
            [self.arrayWishes removeAllObjects];
                for (PFObject *object in objects) {
                
                Wish *wish = [[Wish alloc]init];
                
                NSString *name = [object valueForKey:@"name"];
                NSNumber *price = [object valueForKey:@"price"];
                NSNumber *latitude = [object valueForKey:@"latitude"];
                NSNumber *longitude = [object valueForKey:@"longitude"];
                PFUser *user = [object valueForKey:@"user"];
                PFFile *imageFile = [object valueForKey:@"image"];
                NSString *objectId = [object valueForKey:@"objectId"];
                NSString *textDescription = [object valueForKey:@"textDescription"];
                
                
                wish.name = name;
                wish.price = price;
                wish.latitude = latitude;
                wish.longitude = longitude;
                wish.user = user;
                wish.image = imageFile;
                wish.objectId = objectId;
                wish.textDescription = textDescription;
                        
                [self.arrayWishes addObject:wish];
                        
                NSLog(@"WISHES: %@", [wish valueForKey:@"name"]);
                
            }
            
            [PFObject pinAllInBackground:objects withName:@"MyWishes" block:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"Remote object pinned in Local Data");
                    
                    [self.delegate parseDidFinishDownloadingRemoteObjects:self.arrayWishes];
                    
                }
            }];
            
            PFUser *user = [PFUser currentUser];
            
            NSUInteger intVal = [objects count];
            int iInt1 = (int)intVal;
            [user setObject:[NSNumber numberWithInt:iInt1] forKey:@"numWishes"];
            
            [user saveEventually];
            

        }];
    }];
    
}

- (void)retrieveLocalObjects {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Wishes"];
    [query fromPinWithName:@"MyWishes"];
    [query orderByDescending:@"name"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        
        if (!error) {
            [self.arrayLocalWishes removeAllObjects];
            
            for (PFObject *object in objects) {
                Wish *wish = [[Wish alloc]init];
                
                NSString *name = [object valueForKey:@"name"];
                NSNumber *price = [object valueForKey:@"price"];
                NSNumber *latitude = [object valueForKey:@"latitude"];
                NSNumber *longitude = [object valueForKey:@"longitude"];
                PFUser *user = [object valueForKey:@"user"];
                PFFile *imageFile = [object valueForKey:@"image"];
                NSData *localImageData = [object valueForKey:@"localImageData"];
                NSString *textDescription = [object valueForKey:@"textDescription"];
                
                wish.name = name;
                wish.price = price;
                wish.latitude = latitude;
                wish.longitude = longitude;
                wish.user = user;
                wish.image = imageFile;
                wish.localImageData = localImageData;
                wish.textDescription = textDescription;
                
                [self.arrayLocalWishes addObject:wish];
                
                NSLog(@"WISHES: %@", [wish valueForKey:@"name"]);
            }

            
            [self.delegate parseDidFinishDownloadingLocalObjects:self.arrayLocalWishes];
        }

    }];
    
}

- (void)removeWish:(Wish *)wish
{
    
    NSString *wishId = wish.objectId;
    PFObject *object = [PFObject objectWithoutDataWithClassName:@"Wishes" objectId:wishId];
    
    [object unpinInBackgroundWithName:@"MyWishes" block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Object Unpinned!!");
        }
        else if (error) {
            NSLog(@"Error unpinning remote object: %@", error);
        }
    }];
    
    [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (succeeded) {
            NSLog(@"Object Removed from Parse 💪");
        }
        else if (error){
            
            NSLog(@"Object can't be removed from Parse: %@", error);
            
            //Try remove eventually
            [object deleteEventually];
            
            
        }
    }];

}

- (void)removeLocalWish:(Wish *)wish{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Wishes"];
    [query fromPinWithName:@"MyWishes"];
    [query whereKey:@"name" equalTo:wish.name];
    [query whereKey:@"price" equalTo:wish.price];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects) {
            
            PFObject *object = [objects objectAtIndex:0];
            
            [object unpinInBackgroundWithName:@"MyWishes" block:^(BOOL succeeded, NSError *error) {
                if(succeeded){
                    
                    NSLog(@"Local Object Removed✌️");
                }
            }];
            

            
        }
        else if (error){
            
            NSLog(@"Error removing Local Object: %@", error);
        }
    }];

}


@end
