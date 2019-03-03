#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ToastManager : NSObject

+ (instancetype)manager;

- (void)showToast:(NSString *)toastString;

@end

NS_ASSUME_NONNULL_END
