//
//  ViewController.h
//  Notifications_MacOS
//
//  Created by Chappy Asel on 6/24/17.
//  Copyright © 2017 CD. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PushNotificationManager.h"
#import "PayloadModel.h"
#import "RNUser.h"

@interface ViewController : NSViewController <NSTableViewDelegate, NSTableViewDataSource>

@property (nonatomic) PushNotificationManager *notificaitonManager;

@property (nonatomic) __block NSMutableArray <RNUser *> *users;

@property (weak) IBOutlet NSButton *testButton;
@property (weak) IBOutlet NSTableView *tableView;

@end

