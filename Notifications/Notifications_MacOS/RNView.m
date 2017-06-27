//
//  RNView.m
//  Remote Notifications
//
//  Created by Chappy Asel on 6/27/17.
//  Copyright © 2017 CD. All rights reserved.
//

#import "RNView.h"

@implementation RNView

- (id) init {
    if (self = [super initWithFrame:NSMakeRect(0, 0, 500, 500)]) {
        NSNib *nib = [[NSNib alloc] initWithNibNamed:@"RNView" bundle:nil];
        NSArray *topLevelObjects;
        if (! [nib instantiateWithOwner:self topLevelObjects:&topLevelObjects]) // error
        self = nil;
        for (id topLevelObject in topLevelObjects) {
            if ([topLevelObject isKindOfClass:[RNView class]]) {
                self = topLevelObject;
                break;
            }
         }
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}

- (NSImage *)imageRepresentation {
    return [[NSImage alloc] initWithData:[self dataWithPDFInsideRect:self.bounds]];
}

@end
