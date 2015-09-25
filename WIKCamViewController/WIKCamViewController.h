//
//  WIKCamViewController.h
//  WIKCamViewController
//
//  Created by COFFEE on 2015/09/04.
//  Copyright (c) 2015年 COFFEE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SquareCamViewController.h"

@protocol WIKCamDelegate <NSObject>

/*
 @param features CIFaceFeature Array
 */
-(void)WIKCamDelegateCaptureOutput:(NSArray*)features;
-(void)WinkClose;
-(void)WinkLongClose;
-(void)WinkFlameIn;
-(void)WinkFlameOut;
-(void)WinkLeftClose;
-(void)WinkRightClose;
-(void)WinkSmile;
-(void)WinkLeftCloseWithPoint:(float)point;
-(void)WinkRightCloseWithPoint:(float)point;


@end

@interface WIKCamViewController : SquareCamViewController

@property(weak) id<WIKCamDelegate> delegate;

@end
