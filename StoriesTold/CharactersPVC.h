//
//  CharactersPVC.h
//  StoriesTold
//
//  Created by Niko Zarzani on 1/1/16.
//  Copyright © 2016 IndieZiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewCharacterDelegate.h"

@interface CharactersPVC : UIPageViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate, NewCharacterDelegate>

@end
