//
//  VoiceQTVCell.h
//  StoriesTold
//
//  Created by Niko Zarzani on 12/28/15.
//  Copyright © 2015 IndieZiOS. All rights reserved.
//

#import "PFTableViewCell.h"
#import <Parse/Parse.h>
#import <ParseUI.h>

@interface VoiceQTVCell : PFTableViewCell

- (void)updateFromObject:(nullable PFObject *)object;

@end
