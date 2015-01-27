//
//  Wish.h
//  Wishbox
//
//  Created by Albert Villanueva on 12/1/15.
//  Copyright (c) 2015 Albert Villanueva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface Wish : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic , strong) NSString *textDescription;
@property (nonatomic, strong) PFFile *image;
@property (nonatomic) BOOL isBooked;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) NSData *localImageData;
@property (nonatomic, strong) NSString *objectId;

@end
