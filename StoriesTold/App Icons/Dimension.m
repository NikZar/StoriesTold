//
//  Dimension.m
//  StoriesTold
//
//  Created by Niko Zarzani on 12/26/15.
//  Copyright © 2015 IndieZiOS. All rights reserved.
//

#import "Dimension.h"
#import <Parse/PFObject+Subclass.h>

@implementation Dimension

@dynamic name;
@dynamic image;
@dynamic order;

+ (NSString *)parseClassName {
    return @"Dimension";
}

+ (void)load {
    [self registerSubclass];
}


@end
