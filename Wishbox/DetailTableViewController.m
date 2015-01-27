//
//  DetailTableViewController.m
//  Wishbox
//
//  Created by Albert Villanueva on 19/11/14.
//  Copyright (c) 2014 Albert Villanueva. All rights reserved.
//

#import "DetailTableViewController.h"
#import "MapAnnotation.h"

@interface DetailTableViewController () <MKAnnotation>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (nonatomic, strong) MapAnnotation *annotation;

@property (weak, nonatomic) IBOutlet UITableViewCell *locationCell;

@end

@implementation DetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    UIImageView *view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"fonsPrincipal2"]];
    self.tableView.backgroundView = view;

    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [[UITableViewCell appearance] setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.cornerRadius = 72;
    

    
    self.title = self.wish.name;
    self.priceLabel.text = [NSString stringWithFormat:@"%@ €", self.wish.price];
    [self.wish.image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        
        if (data) {
            
            UIImage *image = [UIImage imageWithData:data];
            self.imageView.image = image;
        }
        else if (error){
            NSLog(@"Error downloading imageWish: %@", error);
        }
    }];

    self.descriptionTextView.text = self.wish.textDescription;

    
    self.annotation = [[MapAnnotation alloc]init];
    
    [self.annotation setCoordinate:CLLocationCoordinate2DMake([self.wish.latitude floatValue], [self.wish.longitude floatValue])];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSNumber *zero = 0;
    
    if (self.wish.latitude == self.wish.longitude) {
        
        [self.locationCell setHidden:YES];
        
    }
    else{
        
        [self.locationCell setHidden:NO];
        
        MKCoordinateRegion region;
        MKCoordinateSpan span;
        span.latitudeDelta = 0.005;
        span.longitudeDelta = 0.005;
        CLLocationCoordinate2D location;
        location.latitude = self.annotation.coordinate.latitude;
        location.longitude = self.annotation.coordinate.longitude;
        region.span = span;
        region.center = location;
        [self.mapView setRegion:region animated:YES];
        
        [self.mapView addAnnotation:self.annotation];
    }

}



@end
