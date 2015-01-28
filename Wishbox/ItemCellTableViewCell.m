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
    self.itemImageView.layer.cornerRadius = 37;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setWish:(Wish *)wish {
    
    _wish = wish;
    
    self.wishName.text = wish.name;
    self.wishPrice.text = [NSString stringWithFormat:@"%@ €", wish.price];
    
    if (wish.localImageData) {
       
       
            UIImage *image = [UIImage imageWithData:wish.localImageData];
            self.itemImageView.image = image;
        
    }
    else if (wish.image){
        
        [wish.image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            
            if (data) {
                
                UIImage *image = [UIImage imageWithData:data];
                self.itemImageView.image = image;
            }
            else if (error){
                NSLog(@"Error downloading imageWish: %@", error);
            }
        }];

        
    }
    else{
        
        self.itemImageView.image = [UIImage imageNamed:@"defaultImage"];
        
        
    }
    
    
    if (wish.isBooked == YES) {
  
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
    
    if (self.wish.isBooked == YES) {
        self.wish.isBooked = NO;
        [self.delegate didSelectWish:self.wish wishBooked:NO];
        [self.statusView setBackgroundImage:[UIImage imageNamed:@"gift-box-icon"] forState:UIControlStateNormal];
    }
    else {
        self.wish.isBooked = YES;
        [self.delegate didSelectWish:self.wish wishBooked:YES];
        [self.statusView setBackgroundImage:[UIImage imageNamed:@"gift-box-icon2"] forState:UIControlStateNormal];

    }
}
@end
