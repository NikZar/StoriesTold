//
//  StoryQTVCell.h
//  StoriesTold
//
//  Created by Niko Zarzani on 12/2/15.
//  Copyright © 2015 IndieZiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI.h>

@interface StoryQTVCell : PFTableViewCell

- (void)updateFromObject:(nullable PFObject *)object;

@end
