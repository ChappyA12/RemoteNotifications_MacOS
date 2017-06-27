//
//  RNPayload.m
//  Notifications_MacOS
//
//  Created by Chappy Asel on 6/25/17.
//  Copyright © 2017 CD. All rights reserved.
//

#import "RNPayload.h"

@implementation RNPayload

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
    if (self.category) finalString = [NSString stringWithFormat:@"%@\"category\":\"%@\",",finalString, self.category];
    if (self.S3Link) finalString = [NSString stringWithFormat:@"%@\"mutable-content\": 1,",finalString];
    finalString = [NSString stringWithFormat:@"%@},",finalString];
    if (self.S3Link) finalString = [NSString stringWithFormat:@"%@\"S3Link\":\"%@\",",finalString, self.S3Link];
    return [NSString stringWithFormat:@"%@}",finalString];
}

@end

//{
//    "aps" : {
//        "alert" : {
//            "title" : "Update",
//            "body" : "Bryce Harper is up to bat!",
//        },
//        "badge" : 1,,
//        "sound" : ".",
//        "category" : "addRemove",
//        "mutable-content" : 1
//    },
//    "S3Link": "image.jpeg"
//}
