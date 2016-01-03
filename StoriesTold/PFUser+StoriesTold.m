//
//  PFUser+StoriesTold.m
//  StoriesTold
//
//  Created by Niko Zarzani on 1/3/16.
//  Copyright © 2016 IndieZiOS. All rights reserved.
//

#import "PFUser+StoriesTold.h"

@implementation PFUser (StoriesTold)

- (void)likesStory:(Story *)story inBackgroundWithBlock:(void (^)(BOOL, NSError *))completionBlock
{
    PFRelation *relation = [self relationForKey:@"loves"];
    PFQuery *query = [relation query];
    [query whereKey:@"objectId" equalTo:story.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        completionBlock(objects.count > 0, error);
    }];
}

@end
