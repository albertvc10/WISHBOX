#import "ItemCellTableViewCell.h"

@interface ItemCellTableViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *wishName;
@property (weak, nonatomic) IBOutlet UILabel *wishPrice;
@property (weak, nonatomic) IBOutlet UIButton *statusView;



@end

@implementation ItemCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.itemImageView.clipsToBounds = YES;
    self.itemImageView.layer.cornerRadius = 40;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setWish:(Wish *)wish {
    
    _wish = wish;
    
    self.wishName.text = wish.name;
    self.wishPrice.text = [NSString stringWithFormat:@"%@ €", wish.price];
    
    UIImage *image = [UIImage imageWithData:wish.image];
    
    if (wish.image == nil) {
        self.itemImageView.image = [UIImage imageNamed:@"defaultImage"];
    }
    else{
        self.itemImageView.image = image;
    }
    
    
    if (wish.isBookedValue) {
  
        [self.statusView setBackgroundImage:[UIImage imageNamed:@"gift-box-icon2"] forState:UIControlStateNormal];

    }
    else{
        [self.statusView setBackgroundImage:[UIImage imageNamed:@"gift-box-icon"] forState:UIControlStateNormal];
    }

    
}

- (void)setIsFromUser:(BOOL)isFromUser {
    
    if (isFromUser == YES) {
        [self.statusView setHidden:YES];
    }
    else{
        
        [self.statusView setHidden:NO];
    }
    
}
- (IBAction)statusButtonPressed:(id)sender {
    
    if (self.wish.isBookedValue) {
        self.wish.isBookedValue = NO;
        [self.delegate didSelectWish:self.wish wishBooked:NO];
        [self.statusView setBackgroundImage:[UIImage imageNamed:@"gift-box-icon"] forState:UIControlStateNormal];
    }
    else {
        self.wish.isBookedValue = YES;
        [self.delegate didSelectWish:self.wish wishBooked:YES];
        [self.statusView setBackgroundImage:[UIImage imageNamed:@"gift-box-icon2"] forState:UIControlStateNormal];


    }


    
}
@end
