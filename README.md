# Remote Notifications - MacOS

## Intro
This project is intended to be a means of testing the capabilities of [Apple Push Notification Services](https://developer.apple.com/library/content/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/APNSOverview.html#//apple_ref/doc/uid/TP40008194-CH8-SW1) and [Amazon Web Services](https://aws.amazon.com). To do this, I have written a client [iOS app](https://github.com/ChappyA12/RemoteNotifications_iOS) and a server [MacOS app](https://github.com/ChappyA12/RemoteNotifications_MacOS) that interface with both services to monitor various online triggers and send push notifications to numerous clients.

## MacOS as a data mining server
The MacOS side of this project pulls data from multiple websites, processes it, and sends rich notifications to clients based on their preferences. To do this, it is recommended that this MacOS app is left running on a computer so that remote notifications can be sent at any time.

## Installation
#### AWS Servers
This backend app uses Amazon Web Services to store user data as well as temporary images for use in rich notifications. The DynamoDB pool and S3 bucket are authenticated using a [Cognito](https://aws.amazon.com/cognito/) unauth identity.

[Amazon DynamoDB](https://aws.amazon.com/dynamodb/) is used as a database solution that stores the keys ```pushToken``` (indexed), ```data``` in the form of a string array, and an ```update``` tag. The MacOS app checks the database regularly for the purpose of updating its online triggers and removing triggers for deleted users.

[Amazon S3](https://aws.amazon.com/s3/) is used as a temporary storage solution for images created at runtime and uploaded by the app. Public read permissions to the bucket must be [enabled](https://stackoverflow.com/questions/2547046/make-a-bucket-public-in-amazon-s3) to receive the image client-side.

#### NotifcationKeys.h
In order to get the MacOS app to fully function correctly, the file 'NotificationKeys.h' must be created and put in the 'Notifications_MacOS' folder. The file should look something like this:
```obj-c
#ifndef NotificationKeys_h
#define NotificationKeys_h

#define P12_FILENAME    @"Notifications.p12"
#define P12_PASSWORD    @"Pa$$word"

#define PUSH_TOKEN      @"5bcd2545 1ad11aeb 598276c7 e316e09a a1dfe50b 8679184a c78e391b bdb1ba25"

#define AWS_POOL_NAME   @"pool-name"
#define AWS_POOL_ID     @"us-east-1:POOLID"

#define AWS_BUCKET_NAME @"bucket-name"

#endif
```

#### Cocoapods
[Cocoapods](https://cocoapods.org) is a dependency manager for Swift and ObjC projects. This app does not require additional setup to enable the pods to be used. the following pods are used:
* [AWS iOS SDK](https://github.com/aws/aws-sdk-ios) - a custom iteration that is MacOS-friendly
* [NWPusher](https://github.com/noodlewerk/NWPusher) - used to interface with the APS system

## Images
<img src="./Screenshots/image1.png" alt="Drawing" width="600 px"/>
