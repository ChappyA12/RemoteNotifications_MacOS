//
//  RNPushNotificationManager.h
//  Notifications_MacOS
//
//  Created by Chappy Asel on 6/25/17.
//  Copyright © 2017 CD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RNPushNotificationManager : NSObject

- (id)init;

- (BOOL)connectToAPN;

- (BOOL)pushNotificationWithToken: (NSString *) token Payload: (NSString *)payload;

- (BOOL)connectToFeedbackService;

- (NSArray *)retrieveInvalidatedTokens;

@end
