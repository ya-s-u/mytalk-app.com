//
//  TalkTableViewCell.h
//  app
//
//  Created by MasanariKamoshita on 2014/07/15.
//  Copyright (c) 2014年 MasanariKamoshita. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TalkTableViewCell : UITableViewCell
@property (nonatomic,strong) IBOutlet UIImageView *icon;
@property (nonatomic,strong) IBOutlet UILabel *titleLabel;
@property (nonatomic,strong) IBOutlet UILabel *postLabel;
@property (nonatomic,strong) IBOutlet UILabel *memberLabel;
@property (nonatomic,strong) IBOutlet UILabel *periodLabel;

@end
