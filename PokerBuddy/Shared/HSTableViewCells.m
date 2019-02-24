#import "HSTableViewCells.h"

NS_ASSUME_NONNULL_BEGIN

static const CGFloat kValueLabelLeadingInset = 16.f;

@implementation HSTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(nullable NSString *)reuseIdentifier {
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    UIView *highlightView = [[UIView alloc] init];
    highlightView.backgroundColor = self.tintColor;
    self.selectedBackgroundView = highlightView;
  }
  return self;
}

- (void)willMoveToSuperview:(nullable UIView *)newSuperview {
  [super willMoveToSuperview:newSuperview];
  if (newSuperview) {
    [self updateInternalImageRenderingModes];
  }
}

- (void)prepareForReuse {
  [super prepareForReuse];
  self.textLabel.text = nil;
  self.accessoryType = UITableViewCellAccessoryNone;
  [self updateInternalImageRenderingModes];
}

- (void)updateInternalImageRenderingModes {
  // This makes the disclosure indicator and the checkmark follow the tint color of the cell.
  for (UIView *subview in self.subviews) {
    if ([subview isMemberOfClass:[UIButton class]]) {
      UIButton *button = (UIButton *)subview;
      UIImage *image = [[button backgroundImageForState:UIControlStateNormal]
                            imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [button setBackgroundImage:image forState:UIControlStateNormal];
    } else if ([subview isKindOfClass:NSClassFromString(@"UITableViewCellEditControl")]) {
      UIImageView *checkImageView = [subview valueForKey:@"_imageView"];
      checkImageView.image =
          [checkImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    } else if ([subview isKindOfClass:
                    NSClassFromString(@"UITableViewCellDetailDisclosureView")]) {
      UIImageView *disclosureImageView = [subview valueForKey:@"_disclosureView"];
      disclosureImageView.image =
          [disclosureImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
  }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  [self updateInternalImageRenderingModes];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
  [super setEditing:editing animated:animated];
  [self updateInternalImageRenderingModes];
}

@end

@interface HSTextFieldCell ()

@property(nonatomic, strong) UITextField *textField;

@end

@implementation HSTextFieldCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(nullable NSString *)reuseIdentifier {
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    _textField = [[UITextField alloc] init];
    [_textField addTarget:self
                   action:@selector(textFieldDidChange:)
         forControlEvents:UIControlEventEditingChanged];
    [self addSubview:_textField];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  self.textField.frame = CGRectInset(self.bounds, 16.f, 0.f);
}

- (double)doubleValue {
  return [self.textField.text doubleValue];
}

- (NSString *)stringValue {
  return self.textField.text;
}

- (void)setStringValue:(NSString *)stringValue {
  self.textField.text = stringValue;
}

- (NSString *)placeholder {
  return self.textField.attributedPlaceholder.string;
}

- (void)setPlaceholder:(NSString *)placeholder {
  UIColor *fadedColor = [UIColor colorWithWhite:1.f alpha:0.05f];
  NSAttributedString *attributedPlaceholder =
      [[NSAttributedString alloc] initWithString:placeholder
                                      attributes:@{NSForegroundColorAttributeName : fadedColor}];
  self.textField.attributedPlaceholder = attributedPlaceholder;
}

- (void)textFieldDidChange:(UITextField *)textField {
  [self.cellDelegate textFieldCellValueDidChange:self];
}

@end

@interface HSTwoValueCell ()

@property(nonatomic, strong) UILabel *valueLabel;

@end

@implementation HSTwoValueCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(nullable NSString *)reuseIdentifier {
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    _valueLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_valueLabel];
  }
  return self;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  self.valueLabel.text = nil;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  [self.valueLabel sizeToFit];
  CGFloat valueLabelWidth = CGRectGetWidth(self.valueLabel.frame);
  CGFloat valueLabelHeight = CGRectGetHeight(self.valueLabel.frame);
  self.valueLabel.frame =
      CGRectMake(CGRectGetWidth(self.contentView.bounds) -
                    valueLabelWidth - kValueLabelLeadingInset,
                 (CGRectGetHeight(self.contentView.bounds) - valueLabelHeight) / 2.f,
                 valueLabelWidth,
                 valueLabelHeight);
}

@end

@implementation HSTwoValueIntegerCell {
  int64_t _integerValue;
}

- (int64_t)integerValue {
  return _integerValue;
}

- (void)setIntegerValue:(int64_t)integerValue {
  _integerValue = integerValue;
  self.valueLabel.text = [NSString stringWithFormat:@"%lld", self.integerValue];
  [self setNeedsLayout];
}

@end

@implementation HSTwoValueFloatCell {
  CGFloat _floatValue;
}

- (CGFloat)floatValue {
  return _floatValue;
}

- (void)setFloatValue:(CGFloat)floatValue {
  _floatValue = floatValue;
  self.valueLabel.text = [NSString stringWithFormat:@"%.1f", self.floatValue];
  [self setNeedsLayout];
}

@end

NS_ASSUME_NONNULL_END
