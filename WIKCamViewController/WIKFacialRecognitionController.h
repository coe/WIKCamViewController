//
//  WIKFacialRecognitionController.h
//  WIKCamViewController
//
//  Created by COFFEE on 2015/09/25.
//  Copyright © 2015年 COFFEE. All rights reserved.
//

#import "WIKCamViewController.h"

@protocol WIKFacialRecognitionControllerDelegate <NSObject>

/**
 * fire when eyes closed.
 */
-(void)WinkClose;

/**
 * fire when eyes long closed.
 */
-(void)WinkLongClose;

/**
 * fire when flame in.
 */
-(void)WinkFlameIn;

/**
 * fire when flame out.
 */
-(void)WinkFlameOut;

/**
 * fire when left eyes closed.
 */
-(void)WinkLeftClose;

/**
 * fire when right eyes closed.
 */
-(void)WinkRightClose;

/**
 * fire when smiled.
 */
-(void)WinkSmile;

@end

@interface WIKFacialRecognitionController : WIKCamViewController<WIKCamDelegate>

/**
 * reset State.
 */
-(void)reset;

/**
 * WIKFacialRecognitionControllerDelegate delegate.
 */
@property(weak)id<WIKFacialRecognitionControllerDelegate> winkDelegate;

@end
