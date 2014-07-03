//
//  TalkTableViewController.h
//  app
//
//  Created by MasanariKamoshita on 2014/06/30.
//  Copyright (c) 2014年 MasanariKamoshita. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TalkTableViewController : UITableViewController
<UITableViewDataSource, UITableViewDelegate>{
    NSInteger* _sessionID;
}
@property (nonatomic, strong) NSMutableArray *talks;
@property (nonatomic, assign) NSInteger* sessionID;

@end
