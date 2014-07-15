//
//  TalkViewController.h
//  app
//
//  Created by MasanariKamoshita on 2014/07/13.
//  Copyright (c) 2014年 MasanariKamoshita. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TalkViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong,nonatomic) NSMutableArray *talks;

- (IBAction)swiching:(UISegmentedControl *)sender;
@end