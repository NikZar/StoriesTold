//
//  StoryQTVC.h
//  StoriesTold
//
//  Created by Niko Zarzani on 12/2/15.
//  Copyright © 2015 IndieZiOS. All rights reserved.
//

#import "PFQueryTableViewController.h"
#import "Story.h"
#import "RecordVCDelegate.h"

@interface StoryQTVC : PFQueryTableViewController <RecordVCDelegate>

@property (strong, nonatomic) Story *story;

@end
