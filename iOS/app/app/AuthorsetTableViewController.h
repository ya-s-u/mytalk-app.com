//
//  AuthorsetTableViewController.h
//  app
//
//  Created by MasanariKamoshita on 2014/08/19.
//  Copyright (c) 2014年 MasanariKamoshita. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthorsetTableViewController : UITableViewController{
    NSMutableArray * _data;
    NSIndexPath * _author;
}

@property NSMutableArray * data;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
