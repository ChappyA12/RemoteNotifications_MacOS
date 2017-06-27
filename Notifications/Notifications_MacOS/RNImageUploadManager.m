//
//  RNImageUploadManager.m
//  Notifications_MacOS
//
//  Created by Chappy Asel on 6/25/17.
//  Copyright © 2017 CD. All rights reserved.
//

#import "RNImageUploadManager.h"
#import <AWSS3/AWSS3.h>
#import "NotificationKeys.h"

@interface RNImageUploadManager ()

@property AWSS3TransferManager *manager;

@end

@implementation RNImageUploadManager

- (id) init {
    if (self = [super init]) {
        self.manager = [AWSS3TransferManager defaultS3TransferManager];
    }
    return self;
}

- (void)uploadImage: (NSImage *)image withCompletionBlock:(void (^)(BOOL success, NSString *fileName))completed {
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directory = [paths objectAtIndex:0];
    NSString *name = [NSString stringWithFormat:@"%@.jpeg",[[NSProcessInfo processInfo] globallyUniqueString]];
    NSString *path = [NSString stringWithFormat:@"%@/%@",directory,name];
    NSData *imageData = [image TIFFRepresentation];
    NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imageData];
    NSData *data = [imageRep representationUsingType: NSJPEGFileType properties:
                    [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:1.0] forKey:NSImageCompressionFactor]];
    [data writeToFile: path atomically: NO];
    [self uploadImageWithPath:path name:name completionBlock:^(BOOL success) {
        [self deleteImageAtPath:path];
        completed(YES, name);
    }];
}

- (void)deleteImageAtPath: (NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    if (![fileManager removeItemAtPath:path error:&error])
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
}

- (void)uploadImageWithPath: (NSString *)path name: (NSString *)name completionBlock:(void (^)(BOOL success))completed {
    NSURL *url = [NSURL fileURLWithPath:path];
    AWSS3TransferManagerUploadRequest *uploadRequest = [AWSS3TransferManagerUploadRequest new];
    uploadRequest.bucket = AWS_BUCKET_NAME;
    uploadRequest.key = name;
    uploadRequest.body = url;
    [[self.manager upload:uploadRequest] continueWithExecutor:[AWSExecutor mainThreadExecutor] withBlock:^id(AWSTask *task) {
       if (task.error) {
           if ([task.error.domain isEqualToString:AWSS3TransferManagerErrorDomain]) {
               switch (task.error.code) {
                   case AWSS3TransferManagerErrorCancelled:
                   case AWSS3TransferManagerErrorPaused: break;
                   default:
                       NSLog(@"Error: %@", task.error);
                       break;
               }
           }
           else NSLog(@"Error: %@", task.error);
       }
       
       if (task.result) {
           AWSS3TransferManagerUploadOutput *uploadOutput = task.result;
           completed(YES);
       }
       return nil;
    }];
}

@end
