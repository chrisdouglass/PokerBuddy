#import "GammaAPIController.h"

#import "GammaCasino.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * const kGetCasinoDetailByIDURL =
    @"https://bravopokerlive.appspot.com/service/getcasinodetailbyid";
static NSString * const kGetCasinosByLocationURL =
    @"https://bravopokerlive.appspot.com/service/getcasinolistbylocation";
// https://bravopokerlive.appspot.com/service/getdailytournamentlistbycasinoid
// https://bravopokerlive.appspot.com/service/getclocksbycasinoid
// https://bravopokerlive.appspot.com/service/getgamelist
// https://bravopokerlive.appspot.com/service/getgamelimitlist
// https://bravopokerlive.appspot.com/service/getcasinolistbygame

@interface GammaAPIController ()
@end

@implementation GammaAPIController

- (void)casinoForID:(NSString *)casinoID
    completionHandler:(void(^)(GammaCasino *_Nullable, NSError *_Nullable))completionHandler {
// curl -H 'Host: bravopokerlive.appspot.com' -H 'Content-Type: application/x-www-form-urlencoded; charset=utf-8' -H 'Accept-Language: en-us' -H 'Accept: */*' -H 'User-Agent: Appcelerator Titanium/5.5.2 (iPhone/12.1.4; iPhone OS; en_US;)' -H 'X-Titanium-Id: 90bfcd89-bd49-4fc7-9999-5d5119a722e8' -H 'X-Requested-With: XMLHttpRequest' --data-binary "mgmtid=x&casinoid=OXPR" --compressed 'https://bravopokerlive.appspot.com/service/getcasinodetailbyid'

  NSString *postString = [NSString stringWithFormat:@"mgmtid=x&casinoid=%@", casinoID];
  NSURLRequest *request =
      [[self class] postRequestForURLString:kGetCasinoDetailByIDURL postString:postString];

  NSURLSessionDataTask *dataTask =
      [[NSURLSession sharedSession] dataTaskWithRequest:request
                                      completionHandler:
       ^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
         if (error) {
           completionHandler(nil, error);
           return;
         }
         NSArray<NSDictionary<NSString *, id> *> *jsonDictionaries =
            [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
         GammaCasino *casino =
            [GammaCasino casinoFromJSONDictionary:[jsonDictionaries lastObject]];
         completionHandler(casino, nil);
  }];
  [dataTask resume];
}

- (void)tournamentsForCasinoWithID:(NSString *)casinoID
                 completionHandler:(void(^)(NSArray<GammaTournament *> *_Nullable,
                                            NSError *_Nullable))completionHandler {
// curl -H 'Host: bravopokerlive.appspot.com' -H 'Content-Type: application/x-www-form-urlencoded; charset=utf-8' -H 'Accept-Language: en-us' -H 'Accept: */*' -H 'User-Agent: Appcelerator Titanium/5.5.2 (iPhone/12.1.4; iPhone OS; en_US;)' -H 'X-Titanium-Id: 90bfcd89-bd49-4fc7-9999-5d5119a722e8' -H 'X-Requested-With: XMLHttpRequest' --data-binary "mgmtid=x&casinoid=OXPR" --compressed 'https://bravopokerlive.appspot.com/service/getdailytournamentlistbycasinoid'
}

- (void)clocksForCasinoWithID:(NSString *)casinoID
            completionHandler:(void(^)(id _Nullable, NSError *_Nullable))completionHandler {
// curl -H 'Host: bravopokerlive.appspot.com' -H 'Content-Type: application/x-www-form-urlencoded; charset=utf-8' -H 'Accept-Language: en-us' -H 'Accept: */*' -H 'User-Agent: Appcelerator Titanium/5.5.2 (iPhone/12.1.4; iPhone OS; en_US;)' -H 'X-Titanium-Id: 90bfcd89-bd49-4fc7-9999-5d5119a722e8' -H 'X-Requested-With: XMLHttpRequest' --data-binary "serial=A%24KJW&mgmtid=x&casinoid=OXPR" --compressed 'https://bravopokerlive.appspot.com/service/getclocksbycasinoid'
}

- (void)casinosByLocation:(nullable CLLocation *)location
            radiusInMiles:(NSUInteger)radiusInMiles
        completionHandler:(void(^)(NSArray<GammaCasino *> *_Nullable,
                                   NSError *_Nullable))completionHandler {
// curl -H 'Host: bravopokerlive.appspot.com' -H 'Content-Type: application/x-www-form-urlencoded; charset=utf-8' -H 'Accept-Language: en-us' -H 'Accept: */*' -H 'User-Agent: Appcelerator Titanium/5.5.2 (iPhone/12.1.4; iPhone OS; en_US;)' -H 'X-Titanium-Id: 90bfcd89-bd49-4fc7-9999-5d5119a722e8' -H 'X-Requested-With: XMLHttpRequest' --data-binary "lat=37.32043075561523&serial=A%24KJW&lon=-121.9350662231445&mile=10000" --compressed 'https://bravopokerlive.appspot.com/service/getcasinolistbylocation'

  CLLocationCoordinate2D coordinate = location.coordinate;
  NSString *postString = [NSString stringWithFormat:@"lat=%lf&lon=%lf&mile=%ld",
                             coordinate.latitude, coordinate.longitude, radiusInMiles];
  NSURLRequest *request =
      [[self class] postRequestForURLString:kGetCasinosByLocationURL postString:postString];

  NSURLSessionDataTask *dataTask =
      [[NSURLSession sharedSession] dataTaskWithRequest:request
                                      completionHandler:
       ^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
         if (error) {
           completionHandler(nil, error);
           return;
         }
         NSArray<NSDictionary<NSString *, id> *> *jsonDictionaries =
            [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
         NSMutableArray<GammaCasino *> *casinos =
            [NSMutableArray<GammaCasino *> arrayWithCapacity:jsonDictionaries.count];
         for (NSDictionary<NSString *, id> *dictionary in jsonDictionaries) {
           [casinos addObject:[GammaCasino casinoFromJSONDictionary:dictionary]];
         }
         completionHandler(casinos, nil);
  }];
  [dataTask resume];
}

- (void)listGamesWithCompletionHandler:
    (void(^)(NSArray<GammaGame *> *_Nullable, NSError *_Nullable))completionHandler {
// curl -H 'Host: bravopokerlive.appspot.com' -H 'Content-Type: application/x-www-form-urlencoded; charset=utf-8' -H 'Accept-Language: en-us' -H 'Accept: */*' -H 'User-Agent: Appcelerator Titanium/5.5.2 (iPhone/12.1.4; iPhone OS; en_US;)' -H 'X-Titanium-Id: 90bfcd89-bd49-4fc7-9999-5d5119a722e8' -H 'X-Requested-With: XMLHttpRequest' --data-binary "" --compressed 'https://bravopokerlive.appspot.com/service/getgamelist'
}

- (void)listGameLimitsWithCompletionHandler:
    (void(^)(NSArray<GammaGameLimit *> *_Nullable, NSError *_Nullable))completionHandler {
// curl -H 'Host: bravopokerlive.appspot.com' -H 'Content-Type: application/x-www-form-urlencoded; charset=utf-8' -H 'Accept-Language: en-us' -H 'Accept: */*' -H 'User-Agent: Appcelerator Titanium/5.5.2 (iPhone/12.1.4; iPhone OS; en_US;)' -H 'X-Titanium-Id: 90bfcd89-bd49-4fc7-9999-5d5119a722e8' -H 'X-Requested-With: XMLHttpRequest' --data-binary "" --compressed 'https://bravopokerlive.appspot.com/service/getgamelimitlist'
}

- (void)searchCasinosForGame:(nullable GammaGame *)game
                       limit:(nullable GammaGameLimit *)limit
       withCompletionHandler:(void(^)(NSArray<GammaCasino *> *_Nullable,
                                      NSError *_Nullable))completionHandler {
// curl -H 'Host: bravopokerlive.appspot.com' -H 'Content-Type: application/x-www-form-urlencoded; charset=utf-8' -H 'Accept-Language: en-us' -H 'Accept: */*' -H 'User-Agent: Appcelerator Titanium/5.5.2 (iPhone/12.1.4; iPhone OS; en_US;)' -H 'X-Titanium-Id: 90bfcd89-bd49-4fc7-9999-5d5119a722e8' -H 'X-Requested-With: XMLHttpRequest' --data-binary "max=%2A&min=%2A&lat=37.32043075561523&lon=-121.9350662231445&desc=%2A&mile=10000" --compressed 'https://bravopokerlive.appspot.com/service/getcasinolistbygame'
}

+ (NSURLRequest *)postRequestForURLString:(NSString *)string postString:(NSString *)postString {
  NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
  NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
  [request setHTTPMethod:@"POST"];
  [request setURL:[NSURL URLWithString:string]];
  [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
  [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
  [request setHTTPBody:postData];
  return request;
}

@end

NS_ASSUME_NONNULL_END
