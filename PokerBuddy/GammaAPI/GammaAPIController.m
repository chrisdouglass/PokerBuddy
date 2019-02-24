#import "GammaAPIController.h"

#import "GammaCasino.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * const kGetCasinoDetailByIDURL =
    @"https://bravopokerlive.appspot.com/service/getcasinodetailbyid";
static NSString * const kGetCasinosByLocationURL =
    @"https://bravopokerlive.appspot.com/service/getcasinolistbylocation";
// The UFPRT (Umbraco Form Post RouTe) is an opaque value needed for login.
static NSString * const kUFPRT = @"6D0DA25E87A10582E385368441A5D7597E0794D8D255318AA044197B8E3C98CB"
    @"168F8EFC3E86AE85729D962CEC1778238AE5072C6012D7EAC974765AB1A6EF70386E3F85B55085564927B8C95D053"
    @"D739B08151E1726075C490036B42E13222FDC81E728D5639CD6E02FBF79A10F7D8479C2866E3C474759DBA2305B40"
    @"57F028";
static NSString * const kLoginURL = @"https://www.bravopokerlive.com/login/";
static NSString * const kLoginReturnUrl = @"/venues/";

// https://bravopokerlive.appspot.com/service/getdailytournamentlistbycasinoid
// https://bravopokerlive.appspot.com/service/getclocksbycasinoid
// https://bravopokerlive.appspot.com/service/getgamelist
// https://bravopokerlive.appspot.com/service/getgamelimitlist
// https://bravopokerlive.appspot.com/service/getcasinolistbygame

@interface GammaAPIController ()
@end

@implementation GammaAPIController

- (void)loginWithEmail:(NSString *)email
              password:(NSString *)password
     completionHandler:(void (^)(NSError *_Nullable error))completionHandler {
  NSString *boundary = [[self class] boundaryString];
  NSDictionary *params = @{
    @"Email" : email,
    @"Password" : password,
    @"ufprt" : kUFPRT,
    @"ReturnUrl" : kLoginReturnUrl,
  };

  NSURL *url = [NSURL URLWithString:kLoginURL];
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
  [request setHTTPMethod:@"POST"];

  NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
  [request setValue:contentType forHTTPHeaderField: @"Content-Type"];

  NSData *httpBody = [[self class] createBodyWithBoundary:boundary parameters:params];

  NSURLSession *session = [NSURLSession sharedSession];
  NSURLSessionTask *task = [session uploadTaskWithRequest:request
                                                 fromData:httpBody
                                        completionHandler:
    ^(NSData *data, NSURLResponse *response, NSError *error) {
      if (error) {
        completionHandler(error);
        return;
      }
      completionHandler(nil);
  }];
  [task resume];
}

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

#pragma mark - Private

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

+ (NSData *)createBodyWithBoundary:(NSString *)boundary
                        parameters:(NSDictionary *)parameters {
  NSMutableData *httpBody = [NSMutableData data];
  [parameters enumerateKeysAndObjectsUsingBlock:
      ^(NSString *parameterKey, NSString *parameterValue, BOOL *stop) {
        NSString *boundaryString = [NSString stringWithFormat:@"--%@\r\n", boundary];
        [httpBody appendData:[boundaryString dataUsingEncoding:NSUTF8StringEncoding]];

        NSString *contentDispositionString =
        [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",
         parameterKey];
        [httpBody appendData:[contentDispositionString dataUsingEncoding:NSUTF8StringEncoding]];

        NSString *paramString = [NSString stringWithFormat:@"%@\r\n", parameterValue];
        [httpBody appendData:[paramString dataUsingEncoding:NSUTF8StringEncoding]];
      }];

  NSString *endBoundary = [NSString stringWithFormat:@"--%@--\r\n", boundary];
  [httpBody appendData:[endBoundary dataUsingEncoding:NSUTF8StringEncoding]];
  return httpBody;
}

+ (NSString *)boundaryString {
  return [NSString stringWithFormat:@"Boundary-%@", [[NSUUID UUID] UUIDString]];
}

@end

NS_ASSUME_NONNULL_END
