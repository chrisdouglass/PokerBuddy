#import "CasinoList/CasinoListTableViewController.h"

#import "GammaAPI/Model/GammaCasino.h"

#warning remove these
#import "Model/Store.h"

NS_ASSUME_NONNULL_BEGIN

@interface CasinoListTableViewController ()
@end

@implementation CasinoListTableViewController

+ (instancetype)casinoListWithCasinos:(nullable NSArray<GammaCasino *> *)casinos {
  CasinoListTableViewController *casinoList =
      [[CasinoListTableViewController alloc] initWithStyle:UITableViewStylePlain];
  casinoList.casinos = casinos;
  return casinoList;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"identifier"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.casinos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier"];
  cell.textLabel.text = self.casinos[indexPath.row].shortName;
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  Store *store = [[Store alloc] init];
  (void)[store insertCasinoFromGammaCasino:self.casinos[indexPath.row]];
  NSError *error = nil;
  [store save:&error];
  NSAssert(!error, @"");
}

- (void)setCasinos:(nullable NSArray<GammaCasino *> *)casinos {
  if (casinos == _casinos) {
    return;
  }
  _casinos = [casinos copy];
  [self.tableView reloadData];
}

@end

NS_ASSUME_NONNULL_END
