//
//  TalkTableViewController.h
//  app
//
//  Created by MasanariKamoshita on 2014/06/30.
//  Copyright (c) 2014年 MasanariKamoshita. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TalkTableViewController : UITableViewController{
    int* _sessionID;
}
@property (nonatomic, strong) NSMutableArray *talks;
@property (nonatomic) int* sessionID;

@end
