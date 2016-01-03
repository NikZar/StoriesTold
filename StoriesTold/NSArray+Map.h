//
//  NSArray+Map.h
//  SilviaBiniCatalogue
//
//  Created by Nautes Spa on 10/14/15.
//  Copyright © 2015 Nautes Spa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Map)

- (NSArray *)mapObjectsUsingBlock:(id (^)(id obj, NSUInteger idx))block;

@end