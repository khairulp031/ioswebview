//
//  WDBSetWebSecurityEnabled.h
//  Bridge
//
//  Created by Khairul Anshar on 8/12/21.
//
#import <Foundation/Foundation.h>
@import WebKit;
@import ObjectiveC;

@interface WDBSetWebSecurity : NSObject
@property WKPreferences* prefs;
@property bool enabled;

- (void) update;
@end
