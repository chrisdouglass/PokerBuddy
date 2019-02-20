#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GammaCasino : NSObject

@property(nonatomic) BOOL active;
@property(nonatomic) BOOL enableGameList;
@property(nonatomic) BOOL enableTournamentInfo;
@property(nonatomic) BOOL enableTournRegistration;
@property(nonatomic) BOOL enableWaitListRegistration;
@property(nonatomic) BOOL enableWaitListInfo;
@property(nonatomic) BOOL hiddenFromList;
@property(nonatomic) BOOL liveGamePit;
@property(nonatomic) BOOL liveGamePoker;
@property(nonatomic) double distance;
@property(nonatomic) double latitiude;
@property(nonatomic) double longitude;
@property(nonatomic, copy, nullable) NSURL *smallImageURL;  // json:smallURL
@property(nonatomic, copy, nullable) NSURL *mediumImageURL; // json:medURL
@property(nonatomic, copy, nullable) NSURL *largeImageURL;  // json:largURL
@property(nonatomic, copy, nullable) NSURL *rewardSignupURL;
@property(nonatomic, copy, nullable) NSNumber *gameCount;

@property(nonatomic, copy, nullable) NSString *address;
@property(nonatomic, copy, nullable) NSString *city;
@property(nonatomic, copy, nullable) NSString *zipCode;
@property(nonatomic, copy, nullable) NSString *state;
@property(nonatomic, copy, nullable) NSString *region;
@property(nonatomic, copy, nullable) NSString *contactNumber; // json:contact_number
@property(nonatomic, copy, nullable) NSString *email;
@property(nonatomic, copy, nullable) NSString *facebook;
@property(nonatomic, copy, nullable) NSString *twitter;
@property(nonatomic, copy, nullable) NSString *webAddress; // json:web_address

@property(nonatomic, copy, nullable) NSString *bannedMessage;
@property(nonatomic, copy, nullable) NSString *cashierCheckEmail;
@property(nonatomic, copy, nullable) NSString *cashierCheckNote;
@property(nonatomic, copy, nullable) NSString *casinoShortDescription;  // json:casinodescription
@property(nonatomic, copy, nullable) NSString *casinoDescription;  // json:description
@property(nonatomic, copy, nullable) NSString *casinoID;
@property(nonatomic, copy, nullable) NSString *domesticWireEmail;
@property(nonatomic, copy, nullable) NSString *domesticWireNote;
@property(nonatomic, copy, nullable) NSString *internationalWireNote;
@property(nonatomic, copy, nullable) NSString *lastEditDateString;
@property(nonatomic, copy, nullable) NSString *majorEvent; // json:majorevent
@property(nonatomic, copy, nullable) NSString *manager;
@property(nonatomic, copy, nullable) NSString *managementID;
@property(nonatomic, copy, nullable) NSString *optionalFeeLabel;
@property(nonatomic, copy, nullable) NSString *playerIDLabel;
@property(nonatomic, copy, nullable) NSString *promoText; // json:promotext
@property(nonatomic, copy, nullable) NSString *responsibleGamingNote;
@property(nonatomic, copy, nullable) NSString *shortName;
@property(nonatomic, copy, nullable) NSString *tournamentRegEmail;
@property(nonatomic, copy, nullable) NSString *tournamentResEmail;
@property(nonatomic, copy, nullable) NSString *tournamentRegNote;
@property(nonatomic, copy, nullable) NSString *tournamentResNote;
@property(nonatomic, copy, nullable) NSString *tournamentResVoidEmail;
@property(nonatomic, copy, nullable) NSString *tournamentRegVoidNote;
@property(nonatomic, copy, nullable) NSString *tournamentResVoidNote;
@property(nonatomic, copy, nullable) NSString *tournamentText;  // json:tournamenttext
@property(nonatomic, copy, nullable) NSString *waitlistSignupEmail;
@property(nonatomic, copy, nullable) NSString *waitListSignupNote;
@property(nonatomic, copy, nullable) NSString *waiverNote;

+ (instancetype)casinoFromJSONDictionary:(NSDictionary<NSString *, id> *)jsonDictionary;

/**
 [{
 "waitListSignUpNote": null,
 "enableTournRegistration": false,
 "tournamentRegNote": null,
 "tournamentRegVoidNote": null,
 "web_address": "https://www.gratonresortcasino.com/Gaming/Live-Poker-Room",
 "twitter": "https://twitter.com/GratonPoker",
 "medURL": null,
 "bannedMessage": null,
 "optionalFeeLabel": null,
 "active": true,
 "tournamenttext": "Now Feturing BB Ante Tournaments \r\nSaturday $340\r\nSunday $140\r\n \r\n\r\n\r\n\r\n\r\n \r\n\r\n\r\n\r\n",
 "smallURL": null,
 "liveGamePit": false,
 "lng": 38.357005,
 "largURL": null,
 "shortName": "Graton Resort & Casino",
 "managementID": "x",
 "tournamentResNote": null,
 "city": "Rohnert Park",
 "contact_number": "707-588-7388",
 "enableWaitListRegistration": false,
 "waiverNote": null,
 "casinoID": "GRTN",
 "rewardSignUpUrl": null,
 "zipcode": "94928",
 "tournamentRegEmail": null,
 "domesticWireEmail": null,
 "state": "CA",
 "enableTournamentInfo": true,
 "casinodescription": "Graton Resort & Casino",
 "promotext": "M.U.G with Andrew Nemee & Brad Owen\r\nSaturday February 23 2PM \r\n\r\nHoldem Progressive Royal Flushes\r\nClubs           $ 751 \r\nDiamonds     $2189 \r\nHearts          $7759\r\nSpades         $9086\r\n\r\nBig Omaha Progressive\r\nRoyal Flushs and Steel Wheels\r\n\r\nRoyals\r\n            \r\nClubs        $518\r\nDiamonds $226\r\nHearts      $422\r\nSpades     $173\r\n\r\nSteel Wheels\r\n\r\nClubs        $226\r\nDiamonds  $414\r\nHearts       $828\r\nSpades      $43\r\n\r\nOmahaProgressive Royal Flushes\r\n \r\nRoyals  \r\n         \r\nClubs         $1368\r\nDiamonds   $1368\r\nHearts        $1368\r\nSpades       $ 215\r\n\r\nSaturdays 12PM - 8PM   \r\n$500 per hour High Hands \r\n\r\nSundays 12PM-8PM\r\nWe're giving away up to $650 per hour!!\r\nWith Hot Seat Drawings with Table Shares. \r\n   \r\nHigh Hands  M-TH 10 AM - 10 PM\r\n$100 every hour\r\n\r\nShare the Wealth Jumbo Holdem Jackpot, where every qualifying guests WINS.\r\n\r\nJumbo Holdem Jackpot $84,902.00 \r\n\r\nLose with Quad Duece's (2,2,2,2) or better and win.\r\nLosing hand receives 40% of the total jackpot.\r\nWinning Hand receives 25% of the total jackpot.\r\nTable share of 5% of the total jackpot\r\nRoom share 30% split between every qualified guest in the room. \r\nJumbo Jackpot rules apply. \r\n\r\nOmaha Bad Beat Jackpot $10,613.00\r\n\r\nLose with Quad Deuces (2,2,2,2 ) or better and win. \r\nLosing hand receives 40% of the total jackpot.\r\nWinning Hand receives 30% of the total jackpot.\r\nA table share of 30% split between the remaining qualified players.  \r\n\r\nBig O Bad Beat Jackpot $3,159.00\r\n\r\nLose with Quad Tens (10,10,10,10) or better and win. \r\nLosing hand receives 40% of the total jackpot.\r\nWinning Hand receives 30% of the total jackpot.\r\nA table share of 30% split between the remaining qualified players. \r\nBad Beat Jackpots may not reflect current value.\r\n\r\nEarly Morning Special \r\nMonday - Friday 8:30AM - 9:30AM\r\nBuy-in for $80 and receive $100 in chips (2 hours of play required) \r\n\r\nMini Bad Beats \r\nGet beat with Aces Full or better by Quads and you WIN!\r\nLosing hand $500 \r\nWinning hand $250\r\nQualifying table shares $50 each \r\nJumbo Jackpot rules apply. \r\n\r\n  \r\nSEE POKER ROOM FOR DETAILS !!!\r\n",
 "liveGamePoker": false,
 "enableWaitListInfo": true,
 "email": "gregory.steinmetz@gratonresortcasino.com",
 "majorevent": null,
 "physical_address": "630 Park Court Drive",
 "description": "The Bay Area\u2019s Finest Poker Room.\r\nConveniently located next to the Parking Garage,Restroom,Market Place, and G Bar. Featuring a magnificent environment splendidly decorated with 20 state of the art poker tables,luxurious chairs, in a Non Smoking atmosphere. \r\nHome of Northern California's largest Jackpots \r\nNow charge your phone from your seat, with Sit N Charge  \r\n\r\n",
 "enableTournReservation": false,
 "waitListSignUpEmail": null,
 "tournamentResVoidEmail": null,
 "facebook": null,
 "internationalWireNote": null,
 "tournamentRegVoidEmail": null,
 "lat": 38.357005,
 "responsibleGamingNote": "      ",
 "domesticWireNote": null,
 "lastEdit": "02-18-2019 23:39:49",
 "playerIDLabel": null,
 "region": "West",
 "internationalWireEmail": null,
 "manager": "Greg Steinmetz",
 "cashierCheckNote": null,
 "tournamentResVoidNote": null,
 "enableGameList": true,
 "cashierCheckEmail": null,
 "tournamentResEmail": null
 }]
 */

@end

NS_ASSUME_NONNULL_END
