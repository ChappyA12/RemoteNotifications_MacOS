//
//  ViewController.m
//  Notifications_MacOS
//
//  Created by Chappy Asel on 6/24/17.
//  Copyright © 2017 CD. All rights reserved.
//

#import "ViewController.h"
#import <AWSCore/AWSCore.h>
#import <AWSCognito/AWSCognito.h>
#import <AWSDynamoDB/AWSDynamoDB.h>
#import "NotificationKeys.h"
#import "RNView.h"

@interface ViewController ()

@property AWSDynamoDBObjectMapper *mapper;
@property NSTimer *updateTimer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [AWSLogger defaultLogger].logLevel = AWSLogLevelWarn;
    [self loadServiceConfiguration];
    self.notificaitonManager = [[RNPushNotificationManager alloc] init];
    self.uploadManager = [[RNImageUploadManager alloc] init];
    [self update];
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(update) userInfo:nil repeats:YES];
}

- (void)update {
    [self updateUserListWithCompletionBlock:^(BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (IBAction)testButtonPressed:(NSButton *)sender {
    if (self.tableView.selectedRow == -1) [self sendNotificationToAllUsers];
    else [self sendNotificationToUser:self.users[self.tableView.selectedRow]];
}

- (void)loadServiceConfiguration {
    AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc]
                                                          initWithRegionType:AWSRegionUSEast1
                                                          identityPoolId:AWS_POOL_ID];
    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUSEast1 credentialsProvider:credentialsProvider];
    [AWSServiceManager defaultServiceManager].defaultServiceConfiguration = configuration;
}

- (void)updateUserListWithCompletionBlock:(void (^)(BOOL success))completed {
    self.users = [[NSMutableArray alloc] init];
    self.mapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
    AWSDynamoDBScanExpression *scanExpression = [AWSDynamoDBScanExpression new];
    scanExpression.limit = @10;
    [[self.mapper scan:[RNUser class] expression:scanExpression] continueWithBlock:^id(AWSTask *task) {
        if (task.error) {
            NSLog(@"The request failed. Error: [%@]", task.error);
            completed(NO);
        }
        else {
            AWSDynamoDBPaginatedOutput *paginatedOutput = task.result;
            //for (RemoteNotificationsUser *user in paginatedOutput.items)
            self.users = [[NSMutableArray alloc] initWithArray: paginatedOutput.items];
            completed(YES);
        }
        return nil;
    }];
}

- (void)sendNotificationToAllUsers {
    for (RNUser *user in self.users) [self sendNotificationToUser:user];
}

- (void)sendNotificationToUser: (RNUser *)user {
    NSImage *image = [[[RNView alloc] init] imageRepresentation];
    [self.uploadManager uploadImage:image withCompletionBlock:^(BOOL success, NSString *fileName) {
        RNPayload *payload = [[RNPayload alloc] init];
        payload.title = [NSString stringWithFormat:@"Update for %@...", [user.pushToken substringToIndex:6]];
        payload.body = [NSString stringWithFormat:@"Your Data: %@",[self formattedArray:user.data]];
        payload.sound = @".";
        payload.S3Link = fileName;
        payload.category = @"addRemove";
        [self.notificaitonManager pushNotificationWithToken:user.pushToken Payload:[payload toString]];
    }];
}

- (void)setRepresentedObject: (id)representedObject {
    [super setRepresentedObject:representedObject];
    // Update the view, if already loaded.
}

#pragma mark - tableView dataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.users.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    RNUser *user = self.users[row];
    if ([tableColumn.title isEqualToString:@"Push Token"]) return user.pushToken;
    else if ([tableColumn.title isEqualToString:@"Data"])  return [self formattedArray:user.data];
    else                                                   return [NSNumber numberWithBool:user.update];
}

- (NSString *)formattedArray: (NSArray *)array {
    NSString *arrString = @"";
    for (NSString *str in array) arrString = [NSString stringWithFormat:@"%@, %@",arrString,str];
    return [NSString stringWithFormat:@"[ %@ ]",[arrString substringFromIndex:2]];
}

#pragma mark - tableView delegate

#pragma mark - keyboard handling

- (void)keyUp:(NSEvent *)event {
    unichar key = [[event charactersIgnoringModifiers] characterAtIndex:0];
    if(key == NSDeleteCharacter) {
        if([self.tableView selectedRow] == -1) NSBeep();
        else {
            RNUser *delete = [RNUser new];
            delete.pushToken = self.users[self.tableView.selectedRow].pushToken;
            [[self.mapper remove:delete] continueWithBlock:^id(AWSTask *task) {
                 if (task.error) NSLog(@"The request failed. Error: [%@]", task.error);
                 else {
                     [self.users removeObjectAtIndex:self.tableView.selectedRow];
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self.tableView reloadData];
                     });
                 }
                 return nil;
            }];
            return;
        }
    }
    [super keyDown:event];
}

@end
