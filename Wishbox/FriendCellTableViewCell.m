//
//  FriendCellTableViewCell.m
//  Wishbox
//
//  Created by Albert Villanueva on 19/11/14.
//  Copyright (c) 2014 Albert Villanueva. All rights reserved.
//

#import "FriendCellTableViewCell.h"

@interface FriendCellTableViewCell ()

@property(nonatomic, weak) IBOutlet UIImageView *friendImageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *cityLabel;


@end

@implementation FriendCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.friendImageView.clipsToBounds = YES;
    self.friendImageView.layer.cornerRadius = 36;    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setPerson:(Person *)person {
    
    _person = person;
    
    self.nameLabel.text = person.name;
    self.cityLabel.text = person.city;
    UIImage *image = [UIImage imageWithData:person.image];
    self.friendImageView.image = image;
}



@end
