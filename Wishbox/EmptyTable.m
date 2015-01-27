//
//  EmptyTable.m
//  Wishbox
//
//  Created by Albert Villanueva on 23/1/15.
//  Copyright (c) 2015 Albert Villanueva. All rights reserved.
//

#import "EmptyTable.h"

@implementation EmptyTable

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 1. Load .xib
        [[NSBundle mainBundle] loadNibNamed:@"EmptyTable" owner:self options:nil];
        
        
        // 2. Adjust bounds
        self.bounds = self.view.bounds;
        
        self.view.backgroundColor = [UIColor clearColor];
        
        // 3. add as a subview
        [self addSubview:self.view];
    }
    return self;
}


@end
