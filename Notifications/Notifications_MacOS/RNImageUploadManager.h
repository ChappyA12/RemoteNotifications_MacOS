//
//  RNImageUploadManager.h
//  Notifications_MacOS
//
//  Created by Chappy Asel on 6/25/17.
//  Copyright © 2017 CD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RNImageUploadManager : NSObject

- (id)init;

- (void)uploadImage: (NSImage *)image withCompletionBlock:(void (^)(BOOL success, NSString *fileName))completed;

@end
