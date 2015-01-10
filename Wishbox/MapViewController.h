//
//  MapViewController.h
//  Wishbox
//
//  Created by Albert Villanueva on 20/11/14.
//  Copyright (c) 2014 Albert Villanueva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MapAnnotation.h"

@protocol MapLocationDelegate <NSObject>
@required
- (void)didUpdateLocationWithAnnotation:(MapAnnotation*)annotation;

@optional
@end


@interface MapViewController : UIViewController <MKAnnotation>

{
    id <MapLocationDelegate> _delegate;
}
@property (nonatomic,strong) id delegate;

@property (nonatomic, strong) MapAnnotation *annotation;

@end
