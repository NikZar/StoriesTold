//
//  RecordVC.h
//  StoriesTold
//
//  Created by Niko Zarzani on 12/28/15.
//  Copyright © 2015 IndieZiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Story.h"
#import "RecordVCDelegate.h"

@interface RecordVC : UIViewController

@property (weak, nonatomic) Story *story;
@property (weak, nonatomic) id<RecordVCDelegate> recordDelegate;

@end
