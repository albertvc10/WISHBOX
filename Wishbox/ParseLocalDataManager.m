//
//  ParseLocalDataManager.m
//  Wishbox
//
//  Created by Albert Villanueva on 10/1/15.
//  Copyright (c) 2015 Albert Villanueva. All rights reserved.
//

#import "ParseLocalDataManager.h"
#import <Parse/Parse.h>
#import <Bolts/BFTask.h>

@implementation ParseLocalDataManager

- (void)downloadParseRemoteObjects{
    
    PFQuery *query2 = [PFQuery queryWithClassName:@"Items"];
    // Query for new results from the network
    [query2 orderByDescending:@"name"];
    [[query2 findObjectsInBackground] continueWithSuccessBlock:^id(BFTask *task) {
        return [[PFObject unpinAllObjectsInBackgroundWithName:@"MyWishes"] continueWithSuccessBlock:^id(BFTask *ignored) {
            // Cache the new results.
            NSArray *arrayObjects = task.result;
            
            [self.delegate parseDidFinishDownloadingRemoteObjects:arrayObjects];
            
            return [PFObject pinAllInBackground:arrayObjects withName:@"MyWishes"];
        }];
    }];
    
}

- (void)retrieveLocalObjects {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Items"];
    [query fromLocalDatastore];
    [query orderByDescending:@"name"];
    
    [[query findObjectsInBackground] continueWithBlock:^id(BFTask *task) {
        if (task.error) {
            // Something went wrong.
            return task;
        }
        
        NSArray *arrayObjects = task.result;
        
        [self.delegate parseDidFinishDownloadingLocalObjects:arrayObjects];
        
        return task;
    }];
}

- (void)retrieveUnsavedObjects{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Items"];
    [query fromPinWithName:@"NewWish"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if ([objects count]) {
            for (PFObject *object in objects) {
                NSLog(@"OBJECT: %@", [object valueForKey:@"name"]);
                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        NSLog(@"Object %@ saved in Parse ✌️✌️✌️", [object valueForKey:@"name"]);
                        [object unpinInBackgroundWithName:@"NewWish" block:^(BOOL succeeded, NSError *error) {
                            if (succeeded) {
                                NSLog(@"Object UNPINNED ✌️");
                            }
                        }];
                        [self downloadParseRemoteObjects];
                    }
                    if (error) {
                        NSLog(@"Unsaved object: %@ still not saved in parse 😭😭😭", [object valueForKey:@"name"]);
                    }
                }];
            }
            
            
        }
        else{
            [self downloadParseRemoteObjects];
        }
        
        
    }];
    
    
}


@end
