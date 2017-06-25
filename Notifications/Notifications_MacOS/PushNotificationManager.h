//
//  PushNotificationManager.h
//  Notifications_MacOS
//
//  Created by Chappy Asel on 6/25/17.
//  Copyright © 2017 CD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NWPusher.h"
#import "NotificationKeys.h"

@interface PushNotificationManager : NSObject

- (id)init;

- (BOOL)connect;

- (BOOL)pushNotificationWithPayload: (NSString *)payload;

@end
