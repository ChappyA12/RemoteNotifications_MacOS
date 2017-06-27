//
//  RNPayload.h
//  Notifications_MacOS
//
//  Created by Chappy Asel on 6/25/17.
//  Copyright © 2017 CD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RNPayload : NSObject

@property NSString *title;
@property NSString *body;

@property int badge;
@property NSString *sound;

@property NSString *category;

@property NSString *S3Link;

- (id)init;

- (NSString *)toString;

@end
