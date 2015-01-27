//
//  EmptyTable.h
//  Wishbox
//
//  Created by Albert Villanueva on 23/1/15.
//  Copyright (c) 2015 Albert Villanueva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmptyTable : UIView
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@property (weak, nonatomic) IBOutlet UIButton *plusButton;

@end
