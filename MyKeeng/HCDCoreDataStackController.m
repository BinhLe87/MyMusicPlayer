//
//  HCDCoreDataStackController.m
//  Pods
//
//  Created by Sergii Kryvoblotskyi on 5/12/15.
//
//

#import "HCDCoreDataStackController.h"
#import "LBURLToNSDataTransformer.h"

@implementation HCDCoreDataStackController



+ (instancetype)controllerWithStack:(id <HCDCoreDataStack>)stack
{
    return [[self alloc] initWithStack:stack];
}

- (instancetype)initWithStack:(id <HCDCoreDataStack>)stack
{
    self = [super init];
    if (self) {
        _stack = stack;
    }
    return self;
}

#pragma mark - Public

- (NSManagedObjectContext *)createChildContextWithType:(NSManagedObjectContextConcurrencyType)type
{
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:type];
    context.parentContext = self.stack.mainManagedObjectContext;
    return context;
}

-(void)save:(void (^)(BOOL, NSError *))completion
{
    if (![self.stack.mainManagedObjectContext hasChanges]) {
        return;
    }
    
    /* Save main context */
    NSManagedObjectContext *mainContext = self.stack.mainManagedObjectContext;
    [mainContext performBlockAndWait:^{
        
        NSError *error = nil;
        if (![mainContext save:&error]) {
            [self _printSaveError:error inContext:mainContext];
            completion(NO, error);
        } else {
            
            /* Push changes to the store */
            NSManagedObjectContext *parentContext = mainContext.parentContext;
            [parentContext performBlock:^{
                
                NSError *error = nil;
                if (![parentContext save:&error]) {
                    [self _printSaveError:error inContext:parentContext];
                    completion(NO, error);
                }
            }];
        }
        completion(YES, nil);
    }];
}

#pragma mark - Setup controller configuration
-(void)setupTransformers {
    
    LBURLToNSDataTransformer *urlTransformer = [[LBURLToNSDataTransformer alloc] init];
    [NSValueTransformer setValueTransformer:urlTransformer forName:@"LBURLToNSDataTransformer"];
}

#pragma mark - Private

- (void)_printSaveError:(NSError *)error inContext:(NSManagedObjectContext *)context
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"%@", error);
    NSLog(@"%@", context);
}

#pragma mark - Shared instances
+(NSManagedObjectContext *)sharedLBMediaChildContextWithSQLiteStore {
    
    static NSManagedObjectContext *LBMediaMOC;
    
    if (!LBMediaMOC) {
        
        LBMediaMOC = [[HCDCoreDataStackController sharedInstanceWithSQLiteStore] createChildContextWithType:NSPrivateQueueConcurrencyType];
        
        [LBMediaMOC setMergePolicy:NSOverwriteMergePolicy];
    }
    
    return LBMediaMOC;
}

+(HCDCoreDataStackController *)sharedInstanceWithSQLiteStore {
    
    static dispatch_once_t once;
    static id instance;
    
    dispatch_once(&once, ^{
        
        instance = [self controllerWithStack:[HCDCoreDataStack sharedInstanceWithSQLiteStore]];
        [instance setupTransformers];
    });
    
    return instance;
}

@end
