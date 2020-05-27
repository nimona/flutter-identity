#import "IdentityMobilePlugin.h"
#import <identity_mobile/identity_mobile-Swift.h>

@implementation IdentityMobilePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftIdentityMobilePlugin registerWithRegistrar:registrar];
}
@end
