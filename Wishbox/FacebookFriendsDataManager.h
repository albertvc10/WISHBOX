//
//  FacebookFriendsDataManager.h
//  Wishbox
//
//  Created by Albert Villanueva on 19/1/15.
//  Copyright (c) 2015 Albert Villanueva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"

@protocol FacebookFriendsDataManagerDelegate <NSObject>

@optional
- (void)parseDidFinishDownloadingFacebookFriends:(NSArray *)friends;
- (void)parseDidFinishDownloadingFriendsWishes:(NSArray *)wishes;

@end

@interface FacebookFriendsDataManager : NSObject

@property (nonatomic, weak) id<FacebookFriendsDataManagerDelegate> delegate;

- (void)requestFacebookFriendsInfo;

- (void)retrieveLocalFriendObjects;

- (void)requestFriendWishesInfo:(Person *)person;

@end
