//
//  PayloadModel.h
//  Notifications_MacOS
//
//  Created by Chappy Asel on 6/25/17.
//  Copyright © 2017 CD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayloadModel : NSObject

@property NSString *title;
@property NSString *body;

@property int badge;
@property NSString *sound;

- (id)init;

- (NSString *)toString;

@end
