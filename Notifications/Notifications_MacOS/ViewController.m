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

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [AWSLogger defaultLogger].logLevel = AWSLogLevelWarn;
    //COGNITO HANDLING
    AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc]
                                                          initWithRegionType:AWSRegionUSEast1
                                                          identityPoolId:AWS_POOL_ID];
    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUSEast1 credentialsProvider:credentialsProvider];
    [AWSServiceManager defaultServiceManager].defaultServiceConfiguration = configuration;
    //ACCESS DATABASE
    self.users = [[NSMutableArray alloc] init];
    AWSDynamoDBObjectMapper *dynamoDBObjectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
    AWSDynamoDBScanExpression *scanExpression = [AWSDynamoDBScanExpression new];
    scanExpression.limit = @10;
    [[dynamoDBObjectMapper scan:[RemoteNotificationsUser class] expression:scanExpression] continueWithBlock:^id(AWSTask *task) {
         if (task.error) NSLog(@"The request failed. Error: [%@]", task.error);
         else {
             AWSDynamoDBPaginatedOutput *paginatedOutput = task.result;
             //for (RemoteNotificationsUser *user in paginatedOutput.items)
             self.users = [[NSMutableArray alloc] initWithArray: paginatedOutput.items];
             [self sendNotifications];
         }
         return nil;
     }];
    
}

- (void)sendNotifications {
    self.notificaitonManager = [[PushNotificationManager alloc] init];
    PayloadModel *payload = [[PayloadModel alloc] init];
    payload.title = @"Hi!";
    for (RemoteNotificationsUser *user in self.users) {
        payload.body = [NSString stringWithFormat:@"You are: %@",user.pushToken];
        [self.notificaitonManager pushNotificationWithToken:user.pushToken Payload:[payload toString]];
    }
}

- (void)setRepresentedObject: (id)representedObject {
    [super setRepresentedObject:representedObject];
    // Update the view, if already loaded.
}

@end
