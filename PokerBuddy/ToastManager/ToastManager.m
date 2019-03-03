#import "ToastManager/ToastManager.h"

#import <CRToast/CRToast.h>

NS_ASSUME_NONNULL_BEGIN

@interface ToastManager ()
@end

@implementation ToastManager

+ (instancetype)manager {
  __block ToastManager *manager;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[ToastManager alloc] init];
  });
  return manager;
}

- (void)showToast:(NSString *)toastString {
  [CRToastManager showNotificationWithOptions:[[self class] optionsForMessage:toastString]
                              completionBlock:nil];
}

+ (NSDictionary *)optionsForMessage:(NSString *)message {
  return @{
    kCRToastTextKey: message,
    kCRToastBackgroundColorKey :
        [UIColor colorWithRed:50.f/255.f green:4.f/255.f blue:98.f/255.f alpha:1.f],
  };
}

@end

NS_ASSUME_NONNULL_END
