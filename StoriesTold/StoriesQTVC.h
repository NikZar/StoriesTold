//
//  StoriesQTVC.h
//  StoriesTold
//
//  Created by Niko Zarzani on 12/27/15.
//  Copyright © 2015 IndieZiOS. All rights reserved.
//

#import "PFQueryTableViewController.h"
#import "Dimension.h"
#import "NewStoryDelegate.h"

@interface StoriesQTVC : PFQueryTableViewController <NewStoryDelegate>

@property (strong, nonatomic) Dimension *dimension;

@end
