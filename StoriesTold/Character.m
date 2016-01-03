//
//  Character.m
//  StoriesTold
//
//  Created by Niko Zarzani on 12/30/15.
//  Copyright © 2015 IndieZiOS. All rights reserved.
//

#import "Character.h"
#import <Parse/PFObject+Subclass.h>
#import "JDStatusBarNotification.h"
#import "Constants.h"

@implementation Character

@dynamic name;
@dynamic image;
@dynamic dimension;
@dynamic createdBy;
@dynamic audioDescription;
@dynamic gender;

+ (NSString *)parseClassName {
    return @"Character";
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
                [JDStatusBarNotification showWithStatus:@"Character deleted!" dismissAfter:2.0 styleName:kBlackNotification];
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [JDStatusBarNotification showWithStatus:@"Error deleting character!" dismissAfter:2.0 styleName:KRedNotification];
            });
        }
    }];
}

@end