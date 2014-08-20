//
//  TalkSettingViewController.h
//  app
//
//  Created by MasanariKamoshita on 2014/08/18.
//  Copyright (c) 2014年 MasanariKamoshita. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SettingViewDelegate
- (void)finishView:(NSString*)returnValue;
@end
@interface TalkSettingViewController : UITableViewController{
    NSMutableArray* _talkSettings;
    NSArray* _sectionList;
    NSArray* _iconList;
    id<SettingViewDelegate> _delegate;
}
@property NSMutableArray* talkSettings;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) id<SettingViewDelegate> delegate;
@end
