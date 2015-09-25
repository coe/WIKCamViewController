//
//  WIKBaseObjectiveController.h
//  WIKCamViewController
//
//  Created by COFFEE on 2015/09/25.
//  Copyright © 2015年 COFFEE. All rights reserved.
//

#import "WIKCamViewController.h"

@protocol WinkObjectiveDelegate <NSObject>

-(void)WinkClose;
-(void)WinkLongClose;
-(void)WinkFlameIn;
-(void)WinkFlameOut;

-(void)WinkLeftClose;
-(void)WinkRightClose;
-(void)WinkSmile;

//-(void)WinkLeftCloseWithPoint:(float)point;
//-(void)WinkRightCloseWithPoint:(float)point;

@end

@interface WIKBaseObjectiveController : WIKCamViewController<WIKCamDelegate>

-(void)reset;

@property(weak)id<WinkObjectiveDelegate> winkDelegate;

@end
