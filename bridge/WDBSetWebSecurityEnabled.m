//
//  WDBSetWebSecurityEnabled.m
//  wkwebview
//
//  Created by Khairul Anshar on 8/12/21.
//

#import "WDBSetWebSecurityEnabled.h"
@import WebKit;
@import ObjectiveC;

void WKPreferencesSetWebSecurityEnabled(id, bool);

@interface WDBFakeWebKitPointer: NSObject
@property (nonatomic) void* _apiObject;
@end
@implementation WDBFakeWebKitPointer
@end

@implementation WDBSetWebSecurity

- (void) update {
    Ivar ivar = class_getInstanceVariable([WKPreferences class], "_preferences");
    void* realPreferences = (void*)(((uintptr_t)self.prefs) + ivar_getOffset(ivar));
    WDBFakeWebKitPointer* fake = [WDBFakeWebKitPointer new];
    fake._apiObject = realPreferences;
    WKPreferencesSetWebSecurityEnabled(fake, self.enabled);
}

@end
