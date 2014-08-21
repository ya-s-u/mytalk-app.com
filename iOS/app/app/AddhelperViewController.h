//
//  AddhelperViewController.h
//  app
//
//  Created by MasanariKamoshita on 2014/08/20.
//  Copyright (c) 2014年 MasanariKamoshita. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddhelperViewController : UIViewController{
    NSArray * _summaryText;
    NSArray * _summaryTitle;
}
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControll;

@end
