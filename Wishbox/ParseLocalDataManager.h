//
//  ParseLocalDataManager.h
//  Wishbox
//
//  Created by Albert Villanueva on 10/1/15.
//  Copyright (c) 2015 Albert Villanueva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Wish.h"

@protocol ParseDataManagerDelegate <NSObject>
@required
- (void)parseDidFinishDownloadingRemoteObjects:(NSMutableArray *)objects;
- (void)parseDidFinishDownloadingLocalObjects:(NSMutableArray *)objects;

@end


@interface ParseLocalDataManager : NSObject

@property (nonatomic, weak) id<ParseDataManagerDelegate> delegate;

- (void)downloadParseRemoteObjects;

- (void)retrieveLocalObjects;

- (void)removeWish:(Wish *)pfo;

- (void)removeLocalWish:(Wish *)wish;
@end
