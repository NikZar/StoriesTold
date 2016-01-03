//
//  UITextField+Utils.m
//  SilviaBiniCatalogue
//
//  Created by Nautes Spa on 10/6/15.
//  Copyright © 2015 Nautes Spa. All rights reserved.
//

#import "UITextField+Utils.h"

@implementation UITextField (Utils)

-(void) setLeftPadding:(int) paddingValue
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, paddingValue, self.frame.size.height)];
    self.leftView = paddingView;
    self.leftViewMode = UITextFieldViewModeAlways;
}

-(void) setRightPadding:(int) paddingValue
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, paddingValue, self.frame.size.height)];
    self.rightView = paddingView;
    self.rightViewMode = UITextFieldViewModeAlways;
}

@end
