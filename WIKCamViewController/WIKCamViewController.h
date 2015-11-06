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

/**
 * get CIFaceFeature Array
 * @param features CIFaceFeature Array
 */
-(void)WIKCamDelegateCaptureOutput:(NSArray<CIFaceFeature *>*)features;

@end

@interface WIKCamViewController : SquareCamViewController

/**
 * WIKCamDelegate delegate
 */
@property(weak) id<WIKCamDelegate> delegate;

@end
