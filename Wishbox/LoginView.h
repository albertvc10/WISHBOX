//
//  LoginView.h
//  Wishbox
//
//  Created by Albert Villanueva on 12/12/14.
//  Copyright (c) 2014 Albert Villanueva. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LoginViewDelegate <NSObject>

- (void)buttonTapped;
@end

@interface LoginView : UIView

@property (strong, nonatomic) IBOutlet UIView *view;

@property (weak, nonatomic) IBOutlet UILabel *label;

@property (nonatomic, weak) id<LoginViewDelegate> delegate;

@end
