//
//  Dimension.h
//  StoriesTold
//
//  Created by Niko Zarzani on 12/26/15.
//  Copyright © 2015 IndieZiOS. All rights reserved.
//

#import <Parse/Parse.h>

@interface Dimension : PFObject <PFSubclassing>

@property (retain) NSString *name;
@property (retain) PFFile *image;
@property (retain) NSNumber *order;

@end
