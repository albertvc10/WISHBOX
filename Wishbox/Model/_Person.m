// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Person.m instead.

#import "_Person.h"

const struct PersonAttributes PersonAttributes = {
	.city = @"city",
	.image = @"image",
	.isUser = @"isUser",
	.lastUpdatedAt = @"lastUpdatedAt",
	.name = @"name",
	.numWishes = @"numWishes",
	.objectId = @"objectId",
};

@implementation PersonID
@end

@implementation _Person

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Person";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Person" inManagedObjectContext:moc_];
}

- (PersonID*)objectID {
	return (PersonID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"isUserValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isUser"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"numWishesValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"numWishes"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic city;

@dynamic image;

@dynamic isUser;

- (BOOL)isUserValue {
	NSNumber *result = [self isUser];
	return [result boolValue];
}

- (void)setIsUserValue:(BOOL)value_ {
	[self setIsUser:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsUserValue {
	NSNumber *result = [self primitiveIsUser];
	return [result boolValue];
}

- (void)setPrimitiveIsUserValue:(BOOL)value_ {
	[self setPrimitiveIsUser:[NSNumber numberWithBool:value_]];
}

@dynamic lastUpdatedAt;

@dynamic name;

@dynamic numWishes;

- (int16_t)numWishesValue {
	NSNumber *result = [self numWishes];
	return [result shortValue];
}

- (void)setNumWishesValue:(int16_t)value_ {
	[self setNumWishes:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveNumWishesValue {
	NSNumber *result = [self primitiveNumWishes];
	return [result shortValue];
}

- (void)setPrimitiveNumWishesValue:(int16_t)value_ {
	[self setPrimitiveNumWishes:[NSNumber numberWithShort:value_]];
}

@dynamic objectId;

@end

