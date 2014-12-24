//
//  FilterBarVirew.m
//  Github Search
//
//  Created by Eric Chee on 12/23/14.
//  Copyright (c) 2014 Eric Chee. All rights reserved.
//

#import "FilterBarView.h"

@implementation FilterBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        
        UIButton *filterButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [filterButton setTitle:@"Add Language Filter" forState:UIControlStateNormal];
        [filterButton setFrame:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height)];
        
        self.filterButton = filterButton;
        
        [self addSubview:self.filterButton];
        
        // UITextField *filterField = [UITextField alloc] initWithFrame:
    }
    
    return self;
}

@end
