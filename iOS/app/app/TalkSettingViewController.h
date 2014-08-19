//
//  TalkSettingViewController.h
//  app
//
//  Created by MasanariKamoshita on 2014/08/18.
//  Copyright (c) 2014年 MasanariKamoshita. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TalkSettingViewController : UITableViewController{
    NSMutableArray* _talkSettings;
    NSArray* _sectionList;
    NSArray* _iconList;
    
}
@property NSMutableArray* talkSettings;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
