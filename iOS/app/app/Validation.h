//
//  Validation.h
//  app
//
//  Created by MasanariKamoshita on 2014/07/06.
//  Copyright (c) 2014年 MasanariKamoshita. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Validation : NSObject
-(NSString*)mailaddressValid:(NSString*) tg;
-(NSString*)passwordValid:(NSString*) tg;
@property NSString *returnMessage;
@end
