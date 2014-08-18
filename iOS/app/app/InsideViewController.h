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
    NSMutableArray * messages;
    NSArray * prevmessages;
    NSArray * nextmessages;
    NSString * _talkID;
    NSDictionary * _talkData;
    NSString * _authour;
    NSMutableArray * _tableViewArray;
    NSMutableArray * _timeLabelArray;
}

@property (nonatomic) NSMutableArray * messages;
@property (nonatomic) NSArray * prevmessages;
@property (nonatomic) NSArray * nextmessages;
@property (nonatomic) NSString* talkID;
@property (nonatomic) NSDictionary* talkData;
@end
