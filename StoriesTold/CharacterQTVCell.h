//
//  CharacterQTVCell.h
//  StoriesTold
//
//  Created by Niko Zarzani on 1/1/16.
//  Copyright © 2016 IndieZiOS. All rights reserved.
//

#import "PFTableViewCell.h"
#import <Parse/Parse.h>
#import <ParseUI.h>

@interface CharacterQTVCell : PFTableViewCell

- (void)updateFromObject:(nullable PFObject *)object;

@end
