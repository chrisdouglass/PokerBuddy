#import "HandChartViewController.h"

#import "Hand.h"

NS_ASSUME_NONNULL_BEGIN

@interface HandChartCollectionViewCell : UICollectionViewCell
@property(nonatomic, strong) Hand *hand;
@end

@interface HandChartViewController () <UICollectionViewDataSource,
                                       UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong) UICollectionViewController *handsCollectionViewController;
@end

@implementation HandChartViewController

+ (instancetype)handChartViewControllerFromHands:(NSArray<Hand *> *)hands {
  UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
  flowLayout.minimumLineSpacing = 0;
  flowLayout.minimumInteritemSpacing = 0;
  return [[HandChartViewController alloc] initWithHands:hands collectionViewLayout:flowLayout];
}

- (instancetype)initWithHands:(NSArray<Hand *> *)hands
         collectionViewLayout:(UICollectionViewLayout *)layout {
  if (self = [super initWithCollectionViewLayout:layout]) {
    _hands = [hands copy];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.collectionView.backgroundColor = UIColor.whiteColor;
  self.collectionView.allowsMultipleSelection = YES;
  [self.collectionView registerClass:[HandChartCollectionViewCell class]
          forCellWithReuseIdentifier:@"identifier"];
}

- (void)setSelectedHands:(NSSet<Hand *> *)selectedHands {
  if (_selectedHands == selectedHands) {
    return;
  }
  _selectedHands = [selectedHands copy];
  for (HandChartCollectionViewCell *cell in self.collectionView.visibleCells) {
    cell.selected = [_selectedHands containsObject:cell.hand];
  }
}

- (__kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView
                           cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
  HandChartCollectionViewCell *cell =
      [collectionView dequeueReusableCellWithReuseIdentifier:@"identifier" forIndexPath:indexPath];
  Hand *hand = self.hands[indexPath.item];
  cell.hand = hand;
  if ([self.selectedHands containsObject:hand]) {
    cell.selected = YES;
  }
  return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  return self.hands.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  NSUInteger cellsPerRow = (NSUInteger)floor(sqrt(self.hands.count));
  CGFloat diameter = collectionView.bounds.size.width / cellsPerRow;
  return CGSizeMake(diameter, diameter);
}


@end

@implementation HandChartCollectionViewCell {
  UILabel *_handLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    _handLabel = [[UILabel alloc] init];
    _handLabel.textAlignment = NSTextAlignmentCenter;
    _handLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_handLabel];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  _handLabel.frame = self.bounds;
}

- (void)setHand:(Hand *)hand {
  if (hand == _hand) {
    return;
  }
  _hand = hand;
  _handLabel.text = [_hand suitedDescription];
}

- (void)setSelected:(BOOL)selected {
  [super setSelected:selected];
  self.backgroundColor = selected ? UIColor.lightGrayColor : nil;
}

@end

NS_ASSUME_NONNULL_END
