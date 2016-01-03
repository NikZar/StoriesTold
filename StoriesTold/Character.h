//
//  Character.h
//  StoriesTold
//
//  Created by Niko Zarzani on 12/30/15.
//  Copyright © 2015 IndieZiOS. All rights reserved.
//

#import "PFObject.h"
#import "Dimension.h"

@interface Character : PFObject <PFSubclassing>

@property (retain) PFFile *image;
@property (retain) NSString *name;
@property (retain) Dimension *dimension;
@property (retain) PFUser *createdBy;
@property (retain) PFFile *audioDescription;
@property (retain) NSNumber *gender;

@end
