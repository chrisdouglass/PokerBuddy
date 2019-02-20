#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GammaGameLimit : NSObject

@property(nonatomic, copy) NSString *name;
@property(nonatomic) int64_t min;
@property(nonatomic) int64_t max;

@end

NS_ASSUME_NONNULL_END
