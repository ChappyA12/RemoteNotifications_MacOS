//
//  PushNotificationManager.m
//  Notifications_MacOS
//
//  Created by Chappy Asel on 6/25/17.
//  Copyright © 2017 CD. All rights reserved.
//

#import "PushNotificationManager.h"
#import "NotificationKeys.h"
#import "NWPusher.h"
#import "NWPushFeedback.h"

@interface PushNotificationManager ()
    @property NWPusher *pusher;
    @property NWPushFeedback *feedback;
@end

@implementation PushNotificationManager

- (id) init {
    if (self = [super init]) {
        [self connectToAPN];
    }
    return self;
}

- (BOOL)connectToAPN {
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

- (BOOL)pushNotificationWithToken: (NSString *) token Payload: (NSString *)payload {
    NSError *error;
    BOOL pushed = [self.pusher pushPayload:payload token:token identifier:rand() error:&error];
    if (pushed) {
        dispatch_after(5.0, dispatch_get_main_queue(), ^{ [self performFollowup]; });
        return YES;
    } else {
        NSLog(@"Unable to push: %@", error);
        return NO;
    }
}

- (void)performFollowup {
    NSUInteger identifier;
    NSError *apnError;
    NSError *error;
    BOOL read = [self.pusher readFailedIdentifier:&identifier apnError:&apnError error:&error];
    if (read && apnError) NSLog(@"Notification with identifier %i rejected: %@", (int)identifier, apnError);
    else if (read) return; //no error
    else NSLog(@"Unable to read: %@", error);
}

- (BOOL)connectToFeedbackService {
    NSURL *url = [NSBundle.mainBundle URLForResource:@"pusher.p12" withExtension:nil];
    NSData *pkcs12 = [NSData dataWithContentsOfURL:url];
    NSError *error = nil;
    self.feedback = [NWPushFeedback connectWithPKCS12Data:pkcs12 password:@"pa$$word" error:&error];
    if (self.feedback) return YES;
    else {
        NSLog(@"Unable to connect to feedback service: %@", error);
        return NO;
    }
}

- (NSArray *)retrieveInvalidatedTokens {
    NSError *error;
    NSArray *pairs = [self.feedback readTokenDatePairsWithMax:25 error:&error];
    if (pairs) {
        NSLog(@"Read token-date pairs: %@", pairs);
    }
    else NSLog(@"Unable to read feedback: %@", error);
    return nil;
}

@end
