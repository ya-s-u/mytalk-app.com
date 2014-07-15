//
//  TalkTableViewCell.m
//  app
//
//  Created by MasanariKamoshita on 2014/07/15.
//  Copyright (c) 2014年 MasanariKamoshita. All rights reserved.
//

#import "TalkTableViewCell.h"

@implementation TalkTableViewCell
@synthesize icon;
@synthesize titleLabel;
@synthesize postLabel;
@synthesize memberLabel;
@synthesize periodLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
