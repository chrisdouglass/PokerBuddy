#import "Model/Extensions/Casino+Gamma.h"

#import <Contacts/CNMutablePostalAddress.h>
#import <tgmath.h>

#import "GammaAPI/Model/GammaCasino.h"

NS_ASSUME_NONNULL_BEGIN

@implementation Casino (Gamma)

- (void)gamma_updateWithGammaCasino:(GammaCasino *)gammaCasino {
  if (self.identifier.length) {
    NSAssert([gammaCasino.casinoID isEqualToString:self.identifier],
             @"GammaId %@ did not match identifier %@", gammaCasino.casinoID, self.identifier);
  } else {
    self.identifier = gammaCasino.casinoID;
  }

  self.name = gammaCasino.shortName;
  self.lastDistance = gammaCasino.distance;

  // Check for 0 values here by seeing if they are actually equal to 0. Don't use if so.
  self.latitude =
      (fabs(gammaCasino.latitiude) < FLT_EPSILON) ? gammaCasino.latitiude : self.latitude;
  self.longitude =
      (fabs(gammaCasino.longitude) < FLT_EPSILON) ? gammaCasino.longitude : self.longitude;

  self.postalAddress =
      [[self class] updatePostalAddress:self.postalAddress fromGammaCasino:gammaCasino];

  self.casinoShortDescription =
      gammaCasino.casinoShortDescription.length > 0
          ? gammaCasino.casinoShortDescription : self.casinoShortDescription;
  self.casinoLongDescription =
      gammaCasino.casinoDescription.length > 0
          ? gammaCasino.casinoDescription : self.casinoLongDescription;
}

+ (CNPostalAddress *)updatePostalAddress:(nullable CNPostalAddress *)postalAddress
                         fromGammaCasino:(GammaCasino *)casino {
  CNMutablePostalAddress *mutableAddress =
      postalAddress ? [postalAddress mutableCopy] : [[CNMutablePostalAddress alloc] init];
  mutableAddress.street = casino.address ?: postalAddress.street;
  mutableAddress.city = casino.city ?: postalAddress.city;
  mutableAddress.postalCode = casino.zipCode ?: postalAddress.postalCode;
  mutableAddress.state = casino.state ?: postalAddress.state;
  return mutableAddress;
}

@end

NS_ASSUME_NONNULL_END
