#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HSTableViewCell : UITableViewCell
@end

@class HSTextFieldCell;
@protocol HSTextFieldCellDelegate <NSObject>
- (void)textFieldCellValueDidChange:(HSTextFieldCell *)cell;
@end

@interface HSTextFieldCell : HSTableViewCell
@property(nonatomic, copy) NSString *placeholder;
@property(nonatomic, readonly) double doubleValue;
@property(nonatomic) NSString *stringValue;
@property(nonatomic, weak) id<HSTextFieldCellDelegate> cellDelegate;
@end

@interface HSTwoValueCell : HSTableViewCell
@property(nonatomic, readonly) UILabel *valueLabel;
@end

@interface HSTwoValueIntegerCell : HSTwoValueCell
@property(nonatomic) int64_t integerValue;
@end

@interface HSTwoValueFloatCell : HSTwoValueCell
@property(nonatomic) CGFloat floatValue;
@end

NS_ASSUME_NONNULL_END
