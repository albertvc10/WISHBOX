#import "MapAnnotation.h"

@implementation MapAnnotation



- (void)setCoordinate:(CLLocationCoordinate2D)coordinate{
    latitude = coordinate.latitude;
    longitude = coordinate.longitude;
}

-(CLLocationCoordinate2D)coordinate {
    CLLocationCoordinate2D coordinate = {latitude,longitude};
    return coordinate;
}
- (NSString *)title {
    
    return @"Wish Location";
}


@end
