// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Wish.m instead.

#import "_Wish.h"

const struct WishAttributes WishAttributes = {
	.image = @"image",
	.isBooked = @"isBooked",
	.lastUpdatedAt = @"lastUpdatedAt",
	.latitude = @"latitude",
	.longitude = @"longitude",
	.name = @"name",
	.objectId = @"objectId",
	.price = @"price",
	.textDescription = @"textDescription",
	.user = @"user",
};

@implementation WishID
@end

@implementation _Wish

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Wish" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Wish";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Wish" inManagedObjectContext:moc_];
}

- (WishID*)objectID {
	return (WishID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"isBookedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isBooked"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"latitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"latitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"longitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"longitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic image;

@dynamic isBooked;

- (BOOL)isBookedValue {
	NSNumber *result = [self isBooked];
	return [result boolValue];
}

- (void)setIsBookedValue:(BOOL)value_ {
	[self setIsBooked:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsBookedValue {
	NSNumber *result = [self primitiveIsBooked];
	return [result boolValue];
}

- (void)setPrimitiveIsBookedValue:(BOOL)value_ {
	[self setPrimitiveIsBooked:[NSNumber numberWithBool:value_]];
}

@dynamic lastUpdatedAt;

@dynamic latitude;

- (double)latitudeValue {
	NSNumber *result = [self latitude];
	return [result doubleValue];
}

- (void)setLatitudeValue:(double)value_ {
	[self setLatitude:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLatitudeValue {
	NSNumber *result = [self primitiveLatitude];
	return [result doubleValue];
}

- (void)setPrimitiveLatitudeValue:(double)value_ {
	[self setPrimitiveLatitude:[NSNumber numberWithDouble:value_]];
}

@dynamic longitude;

- (double)longitudeValue {
	NSNumber *result = [self longitude];
	return [result doubleValue];
}

- (void)setLongitudeValue:(double)value_ {
	[self setLongitude:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLongitudeValue {
	NSNumber *result = [self primitiveLongitude];
	return [result doubleValue];
}

- (void)setPrimitiveLongitudeValue:(double)value_ {
	[self setPrimitiveLongitude:[NSNumber numberWithDouble:value_]];
}

@dynamic name;

@dynamic objectId;

@dynamic price;

@dynamic textDescription;

@dynamic user;

@end

