//
//  Story.m
//  StoriesTold
//
//  Created by Niko Zarzani on 12/26/15.
//  Copyright © 2015 IndieZiOS. All rights reserved.
//

#import "Story.h"
#import <Parse/PFObject+Subclass.h>
#import "JDStatusBarNotification.h"
#import "Constants.h"

@implementation Story

@dynamic title;
@dynamic dimension;
@dynamic createdBy;
@dynamic abstract;
@dynamic loveCount;

+ (NSString *)parseClassName {
    return @"Story";
}

+ (void)load {
    [self registerSubclass];
}

-(void)deleteInBackgroundWithBlock:(PFBooleanResultBlock)block
{
    [super deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        
        if(block){
            block(succeeded, error);
        }
        
        if(succeeded){
            dispatch_async(dispatch_get_main_queue(), ^{
                [JDStatusBarNotification showWithStatus:@"Story deleted!" dismissAfter:2.0 styleName:kBlackNotification];
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [JDStatusBarNotification showWithStatus:@"Error deleting story!" dismissAfter:2.0 styleName:KRedNotification];
            });
        }
    }];
}

@end
