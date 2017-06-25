//
//  PayloadModel.m
//  Notifications_MacOS
//
//  Created by Chappy Asel on 6/25/17.
//  Copyright © 2017 CD. All rights reserved.
//

#import "PayloadModel.h"

@implementation PayloadModel

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (NSString *)toString {
    NSString *finalString = @"{\"aps\":{\"alert\":{";
    if (self.title) finalString = [NSString stringWithFormat:@"%@\"title\":\"%@\",",finalString, self.title];
    if (self.body) finalString = [NSString stringWithFormat:@"%@\"body\":\"%@\",",finalString, self.body];
    finalString = [NSString stringWithFormat:@"%@},",finalString];
    if (self.badge) finalString = [NSString stringWithFormat:@"%@\"badge\":\"%d\",",finalString, self.badge];
    if (self.sound) finalString = [NSString stringWithFormat:@"%@\"sound\":\"%@\",",finalString, self.sound];
    return [NSString stringWithFormat:@"%@}}",finalString];
}

@end

//{
//    "aps" : {
//        "alert" : {
//            "title" : "Update",
//            "body" : "Bryce Harper is up to bat!",
//        },
//        "badge" : 1,
//        "sound" : "."
//    }
//}
