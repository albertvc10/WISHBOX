// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Wish.h instead.

#import <CoreData/CoreData.h>

extern const struct WishAttributes {
	__unsafe_unretained NSString *image;
	__unsafe_unretained NSString *isBooked;
	__unsafe_unretained NSString *lastUpdatedAt;
	__unsafe_unretained NSString *latitude;
	__unsafe_unretained NSString *longitude;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *objectId;
	__unsafe_unretained NSString *price;
	__unsafe_unretained NSString *textDescription;
	__unsafe_unretained NSString *user;
} WishAttributes;

@interface WishID : NSManagedObjectID {}
@end

@interface _Wish : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) WishID* objectID;

@property (nonatomic, strong) NSData* image;

//- (BOOL)validateImage:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* isBooked;

@property (atomic) BOOL isBookedValue;
- (BOOL)isBookedValue;
- (void)setIsBookedValue:(BOOL)value_;

//- (BOOL)validateIsBooked:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* lastUpdatedAt;

//- (BOOL)validateLastUpdatedAt:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* latitude;

@property (atomic) double latitudeValue;
- (double)latitudeValue;
- (void)setLatitudeValue:(double)value_;

//- (BOOL)validateLatitude:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* longitude;

@property (atomic) double longitudeValue;
- (double)longitudeValue;
- (void)setLongitudeValue:(double)value_;

//- (BOOL)validateLongitude:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* objectId;

//- (BOOL)validateObjectId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDecimalNumber* price;

//- (BOOL)validatePrice:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* textDescription;

//- (BOOL)validateTextDescription:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;

@end

@interface _Wish (CoreDataGeneratedPrimitiveAccessors)

- (NSData*)primitiveImage;
- (void)setPrimitiveImage:(NSData*)value;

- (NSNumber*)primitiveIsBooked;
- (void)setPrimitiveIsBooked:(NSNumber*)value;

- (BOOL)primitiveIsBookedValue;
- (void)setPrimitiveIsBookedValue:(BOOL)value_;

- (NSDate*)primitiveLastUpdatedAt;
- (void)setPrimitiveLastUpdatedAt:(NSDate*)value;

- (NSNumber*)primitiveLatitude;
- (void)setPrimitiveLatitude:(NSNumber*)value;

- (double)primitiveLatitudeValue;
- (void)setPrimitiveLatitudeValue:(double)value_;

- (NSNumber*)primitiveLongitude;
- (void)setPrimitiveLongitude:(NSNumber*)value;

- (double)primitiveLongitudeValue;
- (void)setPrimitiveLongitudeValue:(double)value_;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSString*)primitiveObjectId;
- (void)setPrimitiveObjectId:(NSString*)value;

- (NSDecimalNumber*)primitivePrice;
- (void)setPrimitivePrice:(NSDecimalNumber*)value;

- (NSString*)primitiveTextDescription;
- (void)setPrimitiveTextDescription:(NSString*)value;

- (NSString*)primitiveUser;
- (void)setPrimitiveUser:(NSString*)value;

@end
