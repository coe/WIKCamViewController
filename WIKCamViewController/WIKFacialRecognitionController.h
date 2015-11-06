//
//  WIKFacialRecognitionController.h
//  WIKCamViewController
//
//  Created by COFFEE on 2015/09/25.
//  Copyright © 2015年 COFFEE. All rights reserved.
//

#import "WIKCamViewController.h"

@protocol WIKFacialRecognitionControllerDelegate <NSObject>

-(void)WinkClose;
-(void)WinkLongClose;
-(void)WinkFlameIn;
-(void)WinkFlameOut;

-(void)WinkLeftClose;
-(void)WinkRightClose;
-(void)WinkSmile;


@end

@interface WIKFacialRecognitionController : WIKCamViewController<WIKCamDelegate>

-(void)reset;

@property(weak)id<WIKFacialRecognitionControllerDelegate> winkDelegate;

@end
