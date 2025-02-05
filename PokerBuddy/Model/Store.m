#import "Model/Store.h"

#import <CoreData/CoreData.h>

#import "GammaAPI/Model/GammaCasino.h"
#import "Model/Extensions/Casino+Gamma.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *const kStoreDBName = @"Model.sqlite";

@interface Store ()

@property(nonatomic, readonly) NSManagedObjectContext *context;

@end

@implementation Store

+ (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
  static NSPersistentStoreCoordinator *coordinator;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsDirectoryURL =
        [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    NSURL *persistentStoreURL = [documentsDirectoryURL URLByAppendingPathComponent:kStoreDBName];

    NSError *addStoreError = nil;
    [coordinator addPersistentStoreWithType:NSSQLiteStoreType
                              configuration:nil
                                        URL:persistentStoreURL
                                    options:nil
                                      error:&addStoreError];
    NSAssert(addStoreError == nil, @"Error when setting up coordinator store: %@", addStoreError);
  });
  return coordinator;
}

+ (NSManagedObjectContext *)createContext {
  NSManagedObjectContext *context =
      [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
  context.persistentStoreCoordinator = [self persistentStoreCoordinator];
  return context;
}

- (instancetype)init {
  return [self initWithManagedObjectContext:[[self class] createContext]];
}

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)context {
  self = [super init];
  if (self) {
    _context = context;
//    [[self class] registerStoreForNotifications:self];
  }
  return self;
}

- (BOOL)save:(NSError **)error {
  return [self.context save:error];
}

- (void)reset {
  // TODO: Implement using refreshAllObjects.
  [self.context rollback];
}

- (Casino *)insertCasinoFromGammaCasino:(GammaCasino *)gammaCasino {
  Casino *casino = [self insertNewEntityForName:@"Casino"];
  [casino gamma_updateWithGammaCasino:gammaCasino];
  return casino;
}

- (void)updateCasinosFromGammaCasinos:(NSArray<GammaCasino *> *)gammaCasinos {
  for (GammaCasino *gammaCasino in gammaCasinos) {
    NSFetchRequest *request = [Casino fetchRequest];
    request.predicate =
        [NSPredicate predicateWithFormat:@"identifier == %@", gammaCasino.casinoID];
    NSError *fetchError = nil;
    Casino *casino = [[self.context executeFetchRequest:request error:&fetchError] firstObject];
    NSAssert(!fetchError, @"Error fetching a casino: %@", fetchError);
    if (!casino) {
      [self insertCasinoFromGammaCasino:gammaCasino];
      continue;
    }
    [casino gamma_updateWithGammaCasino:gammaCasino];
  }
}

- (NSFetchRequest<Casino *> *)casinoFetchRequest {
  NSFetchRequest<Casino *> *request = [Casino fetchRequest];
  request.sortDescriptors =
      @[ [NSSortDescriptor sortDescriptorWithKey:@"lastDistance" ascending:YES] ];
  return request;
}

- (NSFetchedResultsController *)resultsControllerWithRequest:(NSFetchRequest *)request {
  return [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                             managedObjectContext:self.context
                                               sectionNameKeyPath:nil
                                                        cacheName:nil];
}

- (__kindof NSManagedObject *)insertNewEntityForName:(NSString *)name {
  NSManagedObject *mo = [NSEntityDescription insertNewObjectForEntityForName:name
                                                      inManagedObjectContext:self.context];
//  mo.store = self;
  return mo;
}

@end

NS_ASSUME_NONNULL_END
