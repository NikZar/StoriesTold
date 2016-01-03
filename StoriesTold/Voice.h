//
//  Voice.h
//  StoriesTold
//
//  Created by Niko Zarzani on 12/28/15.
//  Copyright © 2015 IndieZiOS. All rights reserved.
//

#import <Parse/Parse.h>
#import "Story.h"
#import "Character.h"

@interface Voice : PFObject <PFSubclassing>

@property (retain) PFFile *audio;
@property (retain) Story *story;
@property (retain) PFUser *createdBy;
@property (retain) Character *character;

@end
