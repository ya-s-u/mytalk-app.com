//
//  TalkViewController.h
//  app
//
//  Created by MasanariKamoshita on 2014/07/13.
//  Copyright (c) 2014年 MasanariKamoshita. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TalkViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *_talkIDs;
    NSString * _tempTalkID;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong,nonatomic) NSMutableArray *talks;
@property (nonatomic) NSMutableArray *talkIDs;
- (IBAction)swiching:(UISegmentedControl *)sender;
@end
