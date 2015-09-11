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

@end

@interface WIKCamViewController : SquareCamViewController

@property(weak) id<WIKCamDelegate> delegate;

@end
