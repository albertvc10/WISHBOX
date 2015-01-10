//
//  ProfileViewController.h
//  Wishbox
//
//  Created by Albert Villanueva on 19/11/14.
//  Copyright (c) 2014 Albert Villanueva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataStack.h"


@interface ProfileViewController : UIViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
