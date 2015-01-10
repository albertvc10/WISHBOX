    //
//  ParseCoreDataManager.m
//  Wishbox
//
//  Created by Albert Villanueva on 16/12/14.
//  Copyright (c) 2014 Albert Villanueva. All rights reserved.
//

#import "ParseCoreDataManager.h"
#import "Wish.h"

@interface ParseCoreDataManager ()

@property (nonatomic, strong) NSMutableArray *arrayParse;

@property (nonatomic, strong) NSMutableArray *arrayCoreData;

@property (nonatomic, strong) NSArray *result;

@property (nonatomic, strong) NSMutableArray *arrayObjectsToRemove;

@end

@implementation ParseCoreDataManager

//Lazy instanciation
- (NSMutableArray *)arrayParse{
    if (!_arrayParse) {
        _arrayParse = [[NSMutableArray alloc]init];
    }
    return _arrayParse;
}

- (NSMutableArray *)arrayObjectsToRemove{
    
    if (!_arrayObjectsToRemove) {
        _arrayObjectsToRemove = [[NSMutableArray alloc]init];
    }
    return _arrayObjectsToRemove;
    
}

- (void)saveArrayWishesFromParse {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Wishes"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"New Query");
        // The find succeeded.
            NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            NSDate *date = [NSDate date];
            [defaults setObject:date forKey:@"lastParseUpdate"];
            [defaults synchronize];
            
        // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
                NSLog(@"%@", [object valueForKey:@"name"]);
                [self.arrayParse addObject:object];
            }
            [self refreshObjectsFromParse];
            
        } else {
        // Log details of the failure
#warning Change Error to let know the user when there is no connection
            NSLog(@"Errors: %@ %@", error, [error userInfo]);

        }
    }];
}


- (NSArray *)arrayWishesInCoreData {
    
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"Wish"];
    
    fetch.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    NSError *error;
    self.arrayCoreData = [[NSMutableArray alloc]initWithArray:[self.managedObjectContext executeFetchRequest:fetch error:&error]];
    
    [self saveArrayWishesFromParse];
    
    return self.arrayCoreData;
    
}


- (void)refreshObjectsFromParse {
    
    
    NSMutableSet* nsset1 = [NSMutableSet setWithArray:self.arrayParse];
    
    
    NSMutableSet* nsset2 = [NSMutableSet setWithArray:self.arrayCoreData];
    
    NSSet *set1IDs = [nsset1 valueForKey:@"objectId"];
    
    NSSet *set2IDs = [nsset2 valueForKey:@"objectId"];
    
    // only keep the objects of SET1IDS(Parse) whose 'ID' are not in SET2IDS(CoreData)
    NSSet* nsset1_minus_nsset2 = [nsset1 filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"NOT objectId IN %@",set2IDs]];
    
    // only keep the objects of SET2IDS(CoreDat) whose 'ID' are not in SET1IDS(Parse)
    NSSet* nsset2_minus_nsset1 = [nsset2 filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"NOT objectId IN %@",set1IDs]];
    
    NSArray *arrayNewObjectsParse = [nsset1_minus_nsset2 allObjects];
    
    for (PFObject *object in arrayNewObjectsParse) {
        Wish *newWish = [NSEntityDescription insertNewObjectForEntityForName:@"Wish" inManagedObjectContext:self.managedObjectContext];
        newWish.name = [object valueForKey:@"name"];
        newWish.price = [object valueForKey:@"price"];
        newWish.objectId = [object valueForKey:@"objectId"];
        newWish.lastUpdatedAt = [object valueForKey:@"updatedAt"];
        newWish.latitude = [object valueForKey:@"latitude"];
        newWish.longitude = [object valueForKey:@"longitude"];
        newWish.textDescription = [object valueForKey:@"textDescription"];
        
        PFFile *file = [object objectForKey:@"image"];
        
        //Download the image from Parse
       [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
           if (!error) {
               newWish.image = data;
               
            [self.delegate parseDidFinishDownloadingObjects:[self requestRefreshedObjects]];
           }
       }];
        
        [self.arrayParse removeObject:object];
        
    }
    
    NSArray *arrayNewObjectsCD = [nsset2_minus_nsset1 allObjects];
    
    NSUserDefaults *defaultSettings = [NSUserDefaults standardUserDefaults];
    NSDate *lastDateParse = [defaultSettings objectForKey:@"lastParseUpdate"];
    NSDate *lastDateCoreData = [defaultSettings objectForKey:@"lastCoreDataUpdate"];
    

    for (Wish *wish in arrayNewObjectsCD) {
        //Wish lastUpdatedAt is earilier than lastDate that parse was Updated
        if ([wish.lastUpdatedAt compare:lastDateParse] == NSOrderedAscending){
            
            if ([wish.lastUpdatedAt compare:lastDateCoreData] == NSOrderedAscending) {
                NSLog(@"wish last Updated At is earlier than lastCoreData Date");
                wish.lastUpdatedAt = [NSDate date];
                PFObject *object = [PFObject objectWithClassName:@"Wishes"];
                
                [object setObject:wish.name forKey:@"name"];
                [object setObject:wish.price forKey:@"price"];
                [object setObject:[PFUser currentUser] forKey:@"user"];
                [object setObject:wish.latitude forKey:@"latitude"];
                [object setObject:wish.longitude forKey:@"longitude"];
                [object setObject:wish.textDescription forKey:@"textDescription"];
                
                UIImage *image = [UIImage imageWithData:wish.image];
                
                NSData *imageData = UIImageJPEGRepresentation(image, 0.2f);
                
                PFFile *imageFile = [PFFile fileWithName:[NSString stringWithFormat:@"%@.jpg",wish.name] data:imageData];
                
                object[@"image"] = imageFile;
                
                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        NSLog(@"Object %@ Saved in Parse", wish.name);
                        
                    }
                }];
                
                break;
            }
            if ([wish.lastUpdatedAt compare:lastDateCoreData] == NSOrderedDescending) {
                NSLog(@"last CoreData Update is earlier than wish Last Updated At");
                [self.managedObjectContext deleteObject:wish];
                [self.managedObjectContext save:nil];
                
            }else{
                NSLog(@"Date is the same");
                [self.managedObjectContext deleteObject:wish];
                [self.managedObjectContext save:nil];
            }
            
            
        }else{
            
            [self.managedObjectContext deleteObject:wish];
            
        }
       
    }
    
    
    if ([self.arrayCoreData count]) {
        
        //Retrieve existing objects that has changed in LAST UPDATED AT
        for (PFObject *wishFromParse in self.arrayParse) {

            for (Wish *wishFromCoreData in self.arrayCoreData) {

                //Find objects with same ID that lastUpdated has changed and should be Updated
                if ([[wishFromParse valueForKey:@"objectId"] isEqualToString:wishFromCoreData.objectId]) {
                    
                    //If the object from Parse has changed Update it
                    NSDate *parseDate = [wishFromParse valueForKey:@"updatedAt"];
                    
                    if ([parseDate compare:wishFromCoreData.lastUpdatedAt] == NSOrderedDescending) {
                        NSLog(@"Wish to update: %@", [wishFromParse valueForKey:@"name"]);
                        //Remove the old object
                        [self.managedObjectContext deleteObject:wishFromCoreData];
                        
                        //Add the updated object
                        Wish *newWish = [NSEntityDescription insertNewObjectForEntityForName:@"Wish" inManagedObjectContext:self.managedObjectContext];
                        newWish.name = [wishFromParse valueForKey:@"name"];
                        newWish.price = [wishFromParse valueForKey:@"price"];
                        newWish.objectId = [wishFromParse valueForKey:@"objectId"];
                        newWish.lastUpdatedAt = [wishFromParse valueForKey:@"updatedAt"];
                        newWish.latitude = [wishFromParse valueForKey:@"latitude"];
                        newWish.longitude = [wishFromParse valueForKey:@"longitude"];
                        newWish.textDescription = [wishFromParse valueForKey:@"textDescription"];
                        
                        PFFile *file = [wishFromParse objectForKey:@"image"];
                        
                        //Download the image from Parse
                            [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                                if (!error) {
                                    newWish.image = data;
                                    [self.delegate parseDidFinishDownloadingObjects:[self requestRefreshedObjects]];
                                }
                                if (error) {
                                    NSLog(@"Error: cannot download the image from Parse");
                                }
                            }];
                    }
                    else if ([parseDate compare:wishFromCoreData.lastUpdatedAt] == NSOrderedAscending) {
                        //add the wish from CoreData
                    
                    }
                    //If the object has the same TimeStamp Last Updated At - save the object from coreData
                    else{
                        
                    }
                    
                }
               // Diferent Objects ID
                else if(![[wishFromParse valueForKey:@"objectId"] isEqualToString:wishFromCoreData.objectId]){
                    
                    if ([self.arrayCoreData containsObject:[wishFromParse objectForKey:@"objectId"]]) {
                        NSLog(@"YES!!");
                    }else if ([self.arrayParse containsObject:wishFromCoreData]){
                        NSLog(@"ree yess!!");
                        
                    }
                }
            }
            
        }
    }

    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    [self.delegate parseDidFinishDownloadingObjects:[self requestRefreshedObjects]];

}


- (NSArray *)requestRefreshedObjects {
    
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"Wish"];
    
    fetch.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    NSError *error;
    
    NSArray *arrayRefreshedObjects = [self.managedObjectContext executeFetchRequest:fetch error:&error];
    
    return arrayRefreshedObjects;
    
}



@end
