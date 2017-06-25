//
//  PushNotificationManager.m
//  Notifications_MacOS
//
//  Created by Chappy Asel on 6/25/17.
//  Copyright © 2017 CD. All rights reserved.
//

#import "PushNotificationManager.h"

@interface PushNotificationManager ()
    @property NWPusher *pusher;
@end

@implementation PushNotificationManager

- (id) init {
    if (self = [super init]) {
        [self connect];
    }
    return self;
}

- (BOOL)connect {
    NSURL *url = [NSBundle.mainBundle URLForResource:P12_FILENAME withExtension:nil];
    NSData *pkcs12 = [NSData dataWithContentsOfURL:url];
    NSError *error;
    self.pusher = [NWPusher connectWithPKCS12Data:pkcs12 password:P12_PASSWORD error:&error];
    if (self.pusher) return YES;
    else {
        NSLog(@"Unable to connect: %@", error);
        return NO;
    }
}

- (BOOL)pushNotificationWithPayload: (NSString *)payload {
    NSError *error;
    BOOL pushed = [self.pusher pushPayload:payload token:PUSH_TOKEN identifier:rand() error:&error];
    if (pushed) {
        return YES;
    } else {
        NSLog(@"Unable to push: %@", error);
        return NO;
    }
}

@end
