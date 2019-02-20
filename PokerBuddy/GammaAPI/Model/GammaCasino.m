#import "GammaCasino.h"

NS_ASSUME_NONNULL_BEGIN

@interface GammaCasino ()
@end

@implementation GammaCasino

+ (instancetype)casinoFromJSONDictionary:(NSDictionary<NSString *, id> *)jsonDictionary {
  return [[[self class] alloc] initWithJSONDictionary:jsonDictionary];
}

- (instancetype)initWithJSONDictionary:(NSDictionary<NSString *, id> *)jsonDictionary {
  self = [super init];
  if (self) {
    _active = [[[self class] objectForKey:@"active" inJSONDictionary:jsonDictionary] boolValue];
    _enableGameList =
        [[[self class] objectForKey:@"enableGameList" inJSONDictionary:jsonDictionary] boolValue];
    _enableTournamentInfo = [[[self class] objectForKey:@"enableTournamentInfo"
                                       inJSONDictionary:jsonDictionary] boolValue];
    _enableTournRegistration = [[[self class] objectForKey:@"enableTournRegistration"
                                          inJSONDictionary:jsonDictionary] boolValue];
    _enableWaitListRegistration = [[[self class] objectForKey:@"enableWaitListRegistration"
                                             inJSONDictionary:jsonDictionary] boolValue];
    _enableWaitListInfo = [[[self class] objectForKey:@"enableWaitListInfo"
                                     inJSONDictionary:jsonDictionary] boolValue];
    _hiddenFromList =
        [[[self class] objectForKey:@"hiddenFromList" inJSONDictionary:jsonDictionary] boolValue];
    _liveGamePit =
        [[[self class] objectForKey:@"liveGamePit" inJSONDictionary:jsonDictionary] boolValue];
    _liveGamePoker =
        [[[self class] objectForKey:@"liveGamePoker" inJSONDictionary:jsonDictionary] boolValue];

    _distance =
        [[[self class] objectForKey:@"distance" inJSONDictionary:jsonDictionary] doubleValue];
    _latitiude =
        [[[self class] objectForKey:@"latitude" inJSONDictionary:jsonDictionary] doubleValue];
    _longitude =
        [[[self class] objectForKey:@"longitude" inJSONDictionary:jsonDictionary] doubleValue];

    _smallImageURL = [[[self class] objectForKey:@"smallURL" inJSONDictionary:jsonDictionary] copy];
    _mediumImageURL =
        [[[self class] objectForKey:@"medURL" inJSONDictionary:jsonDictionary] copy];
    _largeImageURL = [[[self class] objectForKey:@"largURL" inJSONDictionary:jsonDictionary] copy];
    _rewardSignupURL =
        [[[self class] objectForKey:@"rewardSignupURL" inJSONDictionary:jsonDictionary] copy];
    _gameCount = [[self class] objectForKey:@"gameCount" inJSONDictionary:jsonDictionary];

    _address = [[[self class] objectForKey:@"address" inJSONDictionary:jsonDictionary] copy];
    _city = [[[self class] objectForKey:@"city" inJSONDictionary:jsonDictionary] copy];
    _zipCode = [[[self class] objectForKey:@"zipCode" inJSONDictionary:jsonDictionary] copy];
    _state = [[[self class] objectForKey:@"state" inJSONDictionary:jsonDictionary] copy];
    _region = [[[self class] objectForKey:@"region" inJSONDictionary:jsonDictionary] copy];
    _contactNumber =
        [[[self class] objectForKey:@"contact_number" inJSONDictionary:jsonDictionary] copy];
    _email = [[[self class] objectForKey:@"email" inJSONDictionary:jsonDictionary] copy];
    _facebook = [[[self class] objectForKey:@"facebook" inJSONDictionary:jsonDictionary] copy];
    _twitter = [[[self class] objectForKey:@"twitter" inJSONDictionary:jsonDictionary] copy];
    _webAddress = [[[self class] objectForKey:@"web_address" inJSONDictionary:jsonDictionary] copy];

    _bannedMessage =
        [[[self class] objectForKey:@"bannedMessage" inJSONDictionary:jsonDictionary] copy];
    _cashierCheckEmail =
        [[[self class] objectForKey:@"cashierCheckEmail" inJSONDictionary:jsonDictionary] copy];
    _cashierCheckNote =
        [[[self class] objectForKey:@"cashierCheckNote" inJSONDictionary:jsonDictionary] copy];
    _casinoShortDescription =
        [[[self class] objectForKey:@"casinodescription" inJSONDictionary:jsonDictionary] copy];
    _casinoDescription =
        [[[self class] objectForKey:@"description" inJSONDictionary:jsonDictionary] copy];
    _casinoID = [[jsonDictionary objectForKey:@"casinoID"] copy];  // Should always exist.
    NSAssert(_casinoID != nil, @"No casino ID in dictionary %@", jsonDictionary);
    _domesticWireEmail =
        [[[self class] objectForKey:@"domesticWireEmail" inJSONDictionary:jsonDictionary] copy];
    _domesticWireNote =
        [[[self class] objectForKey:@"domesticWireNote" inJSONDictionary:jsonDictionary] copy];
    _internationalWireNote =
        [[[self class] objectForKey:@"internationalWireNote" inJSONDictionary:jsonDictionary] copy];
    _lastEditDateString =
        [[[self class] objectForKey:@"lastEditDateString" inJSONDictionary:jsonDictionary] copy];
    _majorEvent = [[[self class] objectForKey:@"majorevent" inJSONDictionary:jsonDictionary] copy];
    _manager = [[[self class] objectForKey:@"manager" inJSONDictionary:jsonDictionary] copy];
    _managementID =
        [[[self class] objectForKey:@"managementID" inJSONDictionary:jsonDictionary] copy];
    _optionalFeeLabel =
        [[[self class] objectForKey:@"optionalFeeLabel" inJSONDictionary:jsonDictionary] copy];
    _playerIDLabel =
        [[[self class] objectForKey:@"playerIDLabel" inJSONDictionary:jsonDictionary] copy];
    _promoText = [[[self class] objectForKey:@"promotext" inJSONDictionary:jsonDictionary] copy];
    _responsibleGamingNote =
        [[[self class] objectForKey:@"responsibleGamingNote" inJSONDictionary:jsonDictionary] copy];
    _shortName = [[[self class] objectForKey:@"shortName" inJSONDictionary:jsonDictionary] copy];
    _tournamentRegEmail =
        [[[self class] objectForKey:@"tournamentRegEmail" inJSONDictionary:jsonDictionary] copy];
    _tournamentResEmail =
        [[[self class] objectForKey:@"tournamentResEmail" inJSONDictionary:jsonDictionary] copy];
    _tournamentRegNote =
        [[[self class] objectForKey:@"tournamentRegNote" inJSONDictionary:jsonDictionary] copy];
    _tournamentResNote =
        [[[self class] objectForKey:@"tournamentResNote" inJSONDictionary:jsonDictionary] copy];
    _tournamentResVoidEmail =
        [[[self class] objectForKey:@"tournamentResVoidEmail"
                   inJSONDictionary:jsonDictionary] copy];
    _tournamentRegVoidNote =
        [[[self class] objectForKey:@"tournamentRegVoidNote" inJSONDictionary:jsonDictionary] copy];
    _tournamentResVoidNote =
        [[[self class] objectForKey:@"tournamentResVoidNote" inJSONDictionary:jsonDictionary] copy];
    _tournamentText =
        [[[self class] objectForKey:@"tournamenttext" inJSONDictionary:jsonDictionary] copy];
    _waitlistSignupEmail =
        [[[self class] objectForKey:@"waitlistSignupEmail" inJSONDictionary:jsonDictionary] copy];
    _waitListSignupNote =
        [[[self class] objectForKey:@"waitListSignupNote" inJSONDictionary:jsonDictionary] copy];
    _waiverNote = [[[self class] objectForKey:@"waiverNote" inJSONDictionary:jsonDictionary] copy];
  }
  return self;
}

+ (nullable id)objectForKey:(NSString *)key
           inJSONDictionary:(NSDictionary<NSString *, id> *)jsonDictionary {
  id object = [jsonDictionary objectForKey:key];
  if (!object) {
//    NSLog(@"Did not find key %@ in dictionary.", key);
    return nil;
  }
  if (object == [NSNull null]) {
    return nil;
  }
  return object;
}

@end

NS_ASSUME_NONNULL_END
