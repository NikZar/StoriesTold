//
//  Story.h
//  StoriesTold
//
//  Created by Niko Zarzani on 12/26/15.
//  Copyright © 2015 IndieZiOS. All rights reserved.
//

#import <Parse/Parse.h>
#import "Dimension.h"


@interface Story : PFObject <PFSubclassing>

@property (retain) NSString *title;
@property (retain) Dimension *dimension;
@property (retain) PFUser *createdBy;
@property (retain) PFFile *abstract;
@property (retain) NSNumber *loveCount;

@end
