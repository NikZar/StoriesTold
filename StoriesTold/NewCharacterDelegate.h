//
//  NewCharacterDelegate.h
//  StoriesTold
//
//  Created by Niko Zarzani on 1/2/16.
//  Copyright © 2016 IndieZiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NewCharacterDelegate <NSObject>

- (void)cancelTapped;
- (void)doneTapped;

@end
