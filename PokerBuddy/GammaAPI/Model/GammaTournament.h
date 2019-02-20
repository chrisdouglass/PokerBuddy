#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, TournamentDaysOfWeek) {
  TournamentDaysOfWeekSunday = 1 << 0,
  TournamentDaysOfWeekMonday = 1 << 1,
  TournamentDaysOfWeekTuesday = 1 << 2,
  TournamentDaysOfWeekWednesday = 1 << 3,
  TournamentDaysOfWeekThursday = 1 << 4,
  TournamentDaysOfWeekFriday = 1 << 5,
  TournamentDaysOfWeekSaturday = 1 << 6,
};

@interface GammaTournament : NSObject

@property(nonatomic, copy, nullable) NSString *startDateString; // startDate
@property(nonatomic, copy, nullable) NSString *endDateString; // endDate
@property(nonatomic, copy, nullable) NSString *tournamentName;
@property(nonatomic, copy, nullable) NSString *startTimeString; // startTime
@property(nonatomic, copy, nullable) NSString *dailyDescription; // dailydescription
@property(nonatomic, copy, nullable) NSString *entryFeeString; // entryFee
@property(nonatomic) TournamentDaysOfWeek daysOfWeek; // sun, mon, tue, wed, thu, fri, sat

+ (instancetype)tournamentFromJSONDictionary:(NSDictionary<NSString *, id> *)jsonDictionary;

@end

NS_ASSUME_NONNULL_END
