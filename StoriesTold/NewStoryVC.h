//
//  NewStoryVC.h
//  StoriesTold
//
//  Created by Niko Zarzani on 12/31/15.
//  Copyright © 2015 IndieZiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewStoryDelegate.h"
#import "Story.h"

@interface NewStoryVC : UIViewController

@property (strong, nonatomic) id<NewStoryDelegate> createStoryDelegate;
@property (strong, nonatomic) Story *story;
@property (strong, nonatomic) Dimension *dimension;

@end
