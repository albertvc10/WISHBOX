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

@interface ParseLocalDataManager ()

@property (nonatomic) BOOL isUserLoggedIn;

@end

@implementation ParseLocalDataManager

- (void)downloadParseRemoteObjects{

    PFQuery *query = [PFQuery queryWithClassName:@"Items"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    // Query for new results from the network
    [query orderByDescending:@"name"];
    [[query findObjectsInBackground] continueWithSuccessBlock:^id(BFTask *task) {
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


@end
