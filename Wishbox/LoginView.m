//
//  LoginView.m
//  Wishbox
//
//  Created by Albert Villanueva on 12/12/14.
//  Copyright (c) 2014 Albert Villanueva. All rights reserved.
//

#import "LoginView.h"

@interface LoginView ()


@end

@implementation LoginView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//    
//
//}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 1. Load .xib
        [[NSBundle mainBundle] loadNibNamed:@"loginView" owner:self options:nil];
        
        
        // 2. Adjust bounds
        self.bounds = self.view.bounds;
        
        // 3. add as a subview
        [self addSubview:self.view];
    }
    return self;
}


- (IBAction)buttonLoginPressed:(UIButton *)sender {
    
    [self.delegate buttonTapped];
}

@end
