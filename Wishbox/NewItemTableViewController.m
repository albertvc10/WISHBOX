#import "NewItemTableViewController.h"
#import "ItemsListViewController.h"
#import "Wish.h"
#import "MapViewController.h"
#import <Parse/Parse.h>

@interface NewItemTableViewController () <UIImagePickerControllerDelegate, UIActionSheetDelegate, MapLocationDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;
@property (weak, nonatomic) IBOutlet UIImageView *locationImageView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSData *imageData;

@property BOOL photoIsFromCamera;

@end

@implementation NewItemTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"fonsPrincipal2"]];
    self.tableView.backgroundView = view;
    
    [[UITableViewCell appearance] setSelectionStyle:UITableViewCellSelectionStyleNone];
    
     [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed:)];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonPressed:)];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = saveButton;
    
    
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.cornerRadius = 73;
    
    self.descriptionTextView.clipsToBounds = YES;
    self.descriptionTextView.layer.cornerRadius = 5;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.annotation == nil) {
        [self.mapView setHidden:YES];
        [self.locationImageView setHidden:NO];
    }
    else{
        
        [self.mapView removeAnnotations:self.mapView.annotations];
        
        [self.mapView setHidden:NO];
        [self.locationImageView setHidden:YES];
        
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

#pragma mark MapLocationDelegate

- (void)didUpdateLocationWithAnnotation:(MapAnnotation *)annotation {
    
    self.annotation = annotation;
}




- (IBAction)cancelButtonPressed:(id)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)saveButtonPressed:(id)sender {
    
    Wish *newWish = [NSEntityDescription insertNewObjectForEntityForName:@"Wish" inManagedObjectContext:self.managedObjectContext];
    
    newWish.name = self.nameTextField.text;
    newWish.price = [NSDecimalNumber decimalNumberWithString:self.priceTextField.text];
    newWish.image = self.imageData;
    newWish.textDescription = self.descriptionTextView.text;
    newWish.latitude = [NSNumber numberWithDouble:self.annotation.coordinate.latitude];
    newWish.longitude = [NSNumber numberWithDouble:self.annotation.coordinate.longitude];
    newWish.lastUpdatedAt = [NSDate date];
    newWish.user = [NSString stringWithFormat:@"%@", [PFUser currentUser]];
    UIImage *image = self.imageView.image;
    NSData *imageData = UIImageJPEGRepresentation(image, 0.05f);
    newWish.image = imageData;
    
    if([PFUser currentUser]) {
        newWish.user = [[PFUser currentUser]valueForKey:@"objectId"];
    }
    

    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDate *date = [NSDate date];
    [defaults setObject:date forKey:@"lastCoreDataUpdate"];
    [defaults synchronize];

    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.view endEditing:YES];
    
}


- (IBAction)imageTapped:(id)sender {
    
    NSLog(@"Tapped");
    NSString *actionSheetTitle = @"Select Picture"; 
    NSString *camera = @"Take Photo";
    NSString *album = @"Choose From Library";
    NSString *cancel = @"Cancel";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancel
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:camera, album, nil];
    
    [actionSheet showInView:self.view];

}

- (void)showPotosUI:(UIImagePickerControllerSourceType)sourceType {
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = sourceType;
        [self presentViewController:imagePicker animated:YES completion:nil];
        
        NSLog(@"Pressed");
        
    }
}


#pragma mark UIActionSheet Delegate 

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            NSLog(@"Camera button pressed!");
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            [self showPotosUI:sourceType];
            self.photoIsFromCamera = YES;
            break;
            
        case 1:
            NSLog(@"Library Button pressed!");
            self.photoIsFromCamera = NO;
            [self showPotosUI:UIImagePickerControllerSourceTypePhotoLibrary];
            break;
            
        default:
            break;
    }
    
}

#pragma mark UIImagePickerControllerDelegate 

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *img = info[UIImagePickerControllerOriginalImage];
    
    self.imageData = UIImageJPEGRepresentation(img, 0.6);
    
    self.imageView.image = img;
    
    [picker dismissViewControllerAnimated:YES completion:nil];

}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UINavigationController *nc = [segue destinationViewController];
    MapViewController *vc = (MapViewController *)[nc viewControllers][0];
    vc.delegate = self;
    vc.annotation = self.annotation;
}

@end
