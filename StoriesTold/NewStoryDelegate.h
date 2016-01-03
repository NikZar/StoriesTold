//
//  NewStoryDelegate.h
//  StoriesTold
//
//  Created by Niko Zarzani on 12/31/15.
//  Copyright © 2015 IndieZiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NewStoryDelegate <NSObject>

- (void)cancelTapped;
- (void)doneTapped;

@end
