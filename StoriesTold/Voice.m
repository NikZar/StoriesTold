//
//  Voice.m
//  StoriesTold
//
//  Created by Niko Zarzani on 12/28/15.
//  Copyright © 2015 IndieZiOS. All rights reserved.
//

#import "Voice.h"
#import <Parse/PFObject+Subclass.h>
#import "JDStatusBarNotification.h"
#import "Constants.h"

@implementation Voice

@dynamic audio;
@dynamic story;
@dynamic createdBy;
@dynamic character;

+ (NSString *)parseClassName {
    return @"Voice";
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
                [JDStatusBarNotification showWithStatus:@"Voice deleted!" dismissAfter:2.0 styleName:kBlackNotification];
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [JDStatusBarNotification showWithStatus:@"Error deleting voice!" dismissAfter:2.0 styleName:KRedNotification];
            });
        }
    }];
}


@end
