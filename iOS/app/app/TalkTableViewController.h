//
//  TalkTableViewController.h
//  app
//
//  Created by MasanariKamoshita on 2014/06/30.
//  Copyright (c) 2014年 MasanariKamoshita. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TalkTableViewController : UITableViewController
<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *talks;


@end
