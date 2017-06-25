//
//  ViewController.m
//  Notifications_MacOS
//
//  Created by Chappy Asel on 6/24/17.
//  Copyright © 2017 CD. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.notificaitonManager = [[PushNotificationManager alloc] init];
    PayloadModel *payload = [[PayloadModel alloc] init];
    payload.title = @"Title";
    payload.body = @"Body";
    [self.notificaitonManager pushNotificationWithPayload:[payload toString]];
}

- (void)setRepresentedObject: (id)representedObject {
    [super setRepresentedObject:representedObject];
    // Update the view, if already loaded.
}

@end
