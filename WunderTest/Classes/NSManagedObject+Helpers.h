@interface NSManagedObject (Helpers)


+(instancetype)newInContext:(NSManagedObjectContext *)context;

+(NSEntityDescription *)entityDescriptionInContext:(NSManagedObjectContext *)context;
+(NSArray *)allObjects;
+(NSArray *)allObjectsInContext:(NSManagedObjectContext *)context;


-(void)saveInContext:(NSManagedObjectContext *)context;

@end
