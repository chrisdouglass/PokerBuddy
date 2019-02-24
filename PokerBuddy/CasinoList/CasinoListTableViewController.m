#import "CasinoList/CasinoListTableViewController.h"

#import <SafariServices/SFSafariViewController.h>

#import "Shared/HSTableViewCells.h"

#import "Model/Objects/Casino.h"
#import "Model/Store.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *const kBravoPokerCasinoPageURLString = @"https://www.bravopokerlive.com/venues/%@";

@interface CasinoListTableViewController () <NSFetchedResultsControllerDelegate>
@property(nonatomic) Store *store;
@property(nonatomic) NSFetchedResultsController *resultsController;
@property(nonatomic, readonly) NSArray<Casino *> *casinos;
@end

@implementation CasinoListTableViewController

+ (instancetype)casinoListWithStore:(Store *)store {
  CasinoListTableViewController *casinoList =
      [[CasinoListTableViewController alloc] initWithStyle:UITableViewStylePlain store:store];
  return casinoList;
}

- (instancetype)initWithStyle:(UITableViewStyle)style store:(Store *)store {
  if (self = [super initWithStyle:style]) {
    _store = store;
    NSFetchRequest *request = [_store casinoFetchRequest];
    _resultsController = [_store resultsControllerWithRequest:request];
    _resultsController.delegate = self;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.tableView registerClass:[HSTwoValueCell class] forCellReuseIdentifier:@"identifier"];
}

- (NSArray<Casino *> *)casinos {
  if (_resultsController.fetchedObjects == nil) {
    NSError *fetchError = nil;
    [_resultsController performFetch:&fetchError];
    NSAssert(!fetchError, @"Error attempting to perform fetch: %@", fetchError);
  }
  return _resultsController.fetchedObjects;
}

- (Casino *)casinoAtIndexPath:(NSIndexPath *)indexPath {
  return self.casinos[indexPath.row];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.casinos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  HSTwoValueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier"];
  Casino *casino = [self casinoAtIndexPath:indexPath];
  cell.textLabel.text = casino.name;
  cell.valueLabel.text = [NSString stringWithFormat:@"%.f mi", casino.lastDistance];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  // ballys-las-vegas/
  Casino *casino = [self casinoAtIndexPath:indexPath];
  NSCharacterSet *charactersToRemove = [[NSCharacterSet URLPathAllowedCharacterSet] invertedSet];
  NSString *casinoName = [casino.name stringByReplacingOccurrencesOfString:@" " withString:@"-"];
  casinoName = [casinoName stringByReplacingOccurrencesOfString:@"'" withString:@""];
  NSString *urlSafe =
      [[[casinoName componentsSeparatedByCharactersInSet:charactersToRemove]
          componentsJoinedByString:@""] lowercaseString];
  NSURL *URL =
      [NSURL URLWithString:[NSString stringWithFormat:kBravoPokerCasinoPageURLString, urlSafe]];
  SFSafariViewController *safariView = [[SFSafariViewController alloc] initWithURL:URL];
  [self presentViewController:safariView animated:YES completion:nil];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
  [self.tableView reloadData];
}

@end

NS_ASSUME_NONNULL_END
