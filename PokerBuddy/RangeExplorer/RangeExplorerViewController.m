#import "RangeExplorerViewController.h"

#import "Hand.h"
#import "HandChartViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RangeExplorerViewController ()
@property(nonatomic) UISlider *slider;
@property(nonatomic, copy) NSArray<Hand *> *selectedHands;
@property(nonatomic) UILabel *percentageLabel;
@end

@implementation RangeExplorerViewController {
  NSArray<Hand *> *_handsByEV;
  HandChartViewController *_handChart;
}

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil
                         bundle:(nullable NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _handsByEV = [Hand holdemHandsSortedByEV];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  NSArray<Hand *> *hands = [Hand holdemHandsSortedByAlpha];
  _handChart =
      [HandChartViewController handChartViewControllerFromHands:hands];

  [self addChildViewController:_handChart];
  [self.view addSubview:_handChart.view];
  [_handChart didMoveToParentViewController:self];

  _slider = [[UISlider alloc] init];
  _slider.maximumValue = 100;
  [_slider addTarget:self
              action:@selector(updateSelectedHands)
    forControlEvents:UIControlEventValueChanged];
  [self.view addSubview:_slider];

  _percentageLabel = [[UILabel alloc] init];
  _percentageLabel.font = [UIFont boldSystemFontOfSize:36.f];
  _percentageLabel.text = @"0%";
  [self.view addSubview:_percentageLabel];

  UIView *handChartView = _handChart.view;
  handChartView.translatesAutoresizingMaskIntoConstraints = NO;
  _slider.translatesAutoresizingMaskIntoConstraints = NO;
  _percentageLabel.translatesAutoresizingMaskIntoConstraints = NO;

  [NSLayoutConstraint activateConstraints:@[
    [handChartView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
    [handChartView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
    [handChartView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
    [handChartView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
    [_slider.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16.f],
    [_slider.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16.f],
    [_slider.bottomAnchor constraintEqualToAnchor:self.bottomLayoutGuide.topAnchor constant:-16.f],
    [_slider.heightAnchor constraintEqualToConstant:30.f],
    [_percentageLabel.bottomAnchor constraintEqualToAnchor:_slider.topAnchor],
    [_percentageLabel.centerXAnchor constraintEqualToAnchor:_slider.centerXAnchor],
  ]];
}

- (void)updateSelectedHands {
  [_slider setValue:(int)_slider.value animated:NO];

  float sliderValue = _slider.value;
  float percentage = sliderValue / 100.f;
  NSArray *selectedHands = [Hand topPercentageOfHoldemHandsSortedByEV:percentage];
  _percentageLabel.text = [NSString stringWithFormat:@"%.f%%", sliderValue];
  _handChart.selectedHands = [NSSet setWithArray:selectedHands];
}

@end

NS_ASSUME_NONNULL_END
