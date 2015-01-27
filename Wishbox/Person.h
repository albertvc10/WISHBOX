//
//  Person.h
//  Wishbox
//
//  Created by Albert Villanueva on 12/1/15.
//  Copyright (c) 2015 Albert Villanueva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface Person : NSObject

@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *name;
@property (nonatomic) BOOL isUser;
@property (nonatomic) int numWishes;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) PFUser *user;

@end
