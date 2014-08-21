//
//  AppDelegate.h
//  app
//
//  Created by MasanariKamoshita on 2014/06/25.
//  Copyright (c) 2014年 MasanariKamoshita. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface AppDelegate : NSObject

extern UIColor* textColor;
extern UIFont* textFont;
extern UIFont* textTitleFont;
extern NSString* const SEGUE_A_TO_B;
@property (strong, nonatomic) UIWindow *window;
@end
