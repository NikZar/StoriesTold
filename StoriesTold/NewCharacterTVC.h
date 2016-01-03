//
//  NewCharacterTVC.h
//  StoriesTold
//
//  Created by Niko Zarzani on 1/2/16.
//  Copyright © 2016 IndieZiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewCharacterDelegate.h"
#import "Dimension.h"
#import "Character.h"

@interface NewCharacterTVC : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) id<NewCharacterDelegate> createCharacterDelegate;
@property (strong, nonatomic) Character *character;
@property (strong, nonatomic) Dimension *dimension;

@end
