// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Person.h instead.

#import <CoreData/CoreData.h>

extern const struct PersonAttributes {
	__unsafe_unretained NSString *city;
	__unsafe_unretained NSString *image;
	__unsafe_unretained NSString *isUser;
	__unsafe_unretained NSString *lastUpdatedAt;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *numWishes;
	__unsafe_unretained NSString *objectId;
} PersonAttributes;

@interface PersonID : NSManagedObjectID {}
@end

@interface _Person : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) PersonID* objectID;

@property (nonatomic, strong) NSString* city;

//- (BOOL)validateCity:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSData* image;

//- (BOOL)validateImage:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* isUser;

@property (atomic) BOOL isUserValue;
- (BOOL)isUserValue;
- (void)setIsUserValue:(BOOL)value_;

//- (BOOL)validateIsUser:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* lastUpdatedAt;

//- (BOOL)validateLastUpdatedAt:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* numWishes;

@property (atomic) int16_t numWishesValue;
- (int16_t)numWishesValue;
- (void)setNumWishesValue:(int16_t)value_;

//- (BOOL)validateNumWishes:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* objectId;

//- (BOOL)validateObjectId:(id*)value_ error:(NSError**)error_;

@end

@interface _Person (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveCity;
- (void)setPrimitiveCity:(NSString*)value;

- (NSData*)primitiveImage;
- (void)setPrimitiveImage:(NSData*)value;

- (NSNumber*)primitiveIsUser;
- (void)setPrimitiveIsUser:(NSNumber*)value;

- (BOOL)primitiveIsUserValue;
- (void)setPrimitiveIsUserValue:(BOOL)value_;

- (NSDate*)primitiveLastUpdatedAt;
- (void)setPrimitiveLastUpdatedAt:(NSDate*)value;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSNumber*)primitiveNumWishes;
- (void)setPrimitiveNumWishes:(NSNumber*)value;

- (int16_t)primitiveNumWishesValue;
- (void)setPrimitiveNumWishesValue:(int16_t)value_;

- (NSString*)primitiveObjectId;
- (void)setPrimitiveObjectId:(NSString*)value;

@end
