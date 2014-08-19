//
//  IconsetViewController.h
//  app
//
//  Created by MasanariKamoshita on 2014/08/19.
//  Copyright (c) 2014年 MasanariKamoshita. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IconsetViewController : UICollectionViewController{
    NSMutableArray * _data;
    NSMutableArray *_icons;
}
@property NSMutableArray * data;
@property (nonatomic, strong) NSIndexPath *selectedItemIndexPath;

@end
