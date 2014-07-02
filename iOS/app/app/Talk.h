//
//  Talk.h
//  app
//
//  Created by MasanariKamoshita on 2014/06/30.
//  Copyright (c) 2014年 MasanariKamoshita. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Talk : NSObject
// インスタンス変数
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int periodStart;
@property (nonatomic, assign) int periodEnd;
@property (nonatomic, assign) int member;
@property (nonatomic, assign) int icon;
@property (nonatomic, assign) int posts;

@end