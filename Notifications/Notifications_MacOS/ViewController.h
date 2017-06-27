//
//  ViewController.h
//  Notifications_MacOS
//
//  Created by Chappy Asel on 6/24/17.
//  Copyright © 2017 CD. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RNPushNotificationManager.h"
#import "RNImageUploadManager.h"
#import "RNPayload.h"
#import "RNUser.h"

@interface ViewController : NSViewController <NSTableViewDelegate, NSTableViewDataSource>

@property (nonatomic) RNPushNotificationManager *notificaitonManager;
@property (nonatomic) RNImageUploadManager *uploadManager;

@property (nonatomic) __block NSMutableArray <RNUser *> *users;

@property (weak) IBOutlet NSButton *testButton;
@property (weak) IBOutlet NSTableView *tableView;

@end

