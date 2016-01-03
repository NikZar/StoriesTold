//
//  PFUser+StoriesTold.h
//  StoriesTold
//
//  Created by Niko Zarzani on 1/3/16.
//  Copyright © 2016 IndieZiOS. All rights reserved.
//

#import "PFUser.h"
#import "Story.h"

@interface PFUser (StoriesTold)

- (void)likesStory:(Story *)story inBackgroundWithBlock:(void (^)(BOOL lovesStory, NSError *error))completionBlock;

@end
