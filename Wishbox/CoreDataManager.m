//
//  CoreDataManager.m
//  Wishbox
//
//  Created by Albert Villanueva on 2/1/15.
//  Copyright (c) 2015 Albert Villanueva. All rights reserved.
//

#import "CoreDataManager.h"

@implementation CoreDataManager

- (NSArray *)arrayWishesInCoreData {
    
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"Wish"];
    
    fetch.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    NSError *error;
    
    NSMutableArray *arrayCoreData = [[NSMutableArray alloc]initWithArray:[self.managedObjectContext executeFetchRequest:fetch error:&error]];
    
    return arrayCoreData;
}

@end
