//
//  InsideViewController.h
//  app
//
//  Created by MasanariKamoshita on 2014/07/16.
//  Copyright (c) 2014年 MasanariKamoshita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTSMessagingCell.h"

@interface InsideViewController : UIViewController <UIScrollViewDelegate,UITableViewDelegate, UITableViewDataSource> {
    UITableView * tableView;
    NSArray * messages;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic) NSArray * messages;
@end
