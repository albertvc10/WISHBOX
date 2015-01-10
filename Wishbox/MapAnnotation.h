//
//  MapAnnotation.h
//  MapKitPractice
//
//  Created by Albert Villanueva on 25/11/14.
//  Copyright (c) 2014 Albert Villanueva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapAnnotation : NSObject <MKAnnotation> {
    
    double latitude, longitude;
}



@end
