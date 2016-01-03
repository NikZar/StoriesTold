//
//  CharactersQTVC.h
//  StoriesTold
//
//  Created by Niko Zarzani on 1/1/16.
//  Copyright © 2016 IndieZiOS. All rights reserved.
//

#import "PFQueryTableViewController.h"
#import "Dimension.h"
#import "NewCharacterTVC.h"

@interface CharactersQTVC : PFQueryTableViewController <NewCharacterDelegate>

@property (strong, nonatomic) Dimension *dimension;

- (void)editTapped;

@end
