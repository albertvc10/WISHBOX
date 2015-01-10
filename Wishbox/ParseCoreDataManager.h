//
//  ParseCoreDataManager.h
//  Wishbox
//
//  Created by Albert Villanueva on 16/12/14.
//  Copyright (c) 2014 Albert Villanueva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "CoreDataStack.h"

@protocol ParseCoreDataManagerDelegate <NSObject>
@required
- (void)parseDidFinishDownloadingObjects:(NSArray *)objects;

@end

@interface ParseCoreDataManager : NSObject

@property (nonatomic, weak) id<ParseCoreDataManagerDelegate> delegate;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;


- (NSArray *)arrayWishesInCoreData;


- (void)saveArrayWishesFromParse;

- (NSArray *)requestRefreshedObjects;
@end

