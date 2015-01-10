//
//  CoreDataManager.h
//  Wishbox
//
//  Created by Albert Villanueva on 2/1/15.
//  Copyright (c) 2015 Albert Villanueva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataStack.h"

@interface CoreDataManager : NSObject

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
