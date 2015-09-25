//
//  WIKBaseObjectiveController.m
//  WIKCamViewController
//
//  Created by COFFEE on 2015/09/25.
//  Copyright © 2015年 COFFEE. All rights reserved.
//

#import "WIKBaseObjectiveController.h"

const float kOmomi = 1.0f;
const float kLongCloseOmomi = 0.2f;
const float kCloseOmomi = 0.1f;
const float kPoint = 0.05f;

@interface WIKBaseObjectiveController() {
    //    dispatch_semaphore_t semaphore;
}

@property(atomic) BOOL isWinkFlameIn;
@property(atomic) float leftProgressProgress;
@property(atomic) float rightProgressProgress;
@property(atomic) BOOL isDone;



@end

@implementation WIKBaseObjectiveController

-(void)WIKCamDelegateCaptureOutput:(NSArray*)features {
    
    //    NSLog(@"WIKCamDelegateCaptureOutput leftProgressProgress %f",self.leftProgressProgress);
    //    if (!semaphore) {
    //        semaphore = dispatch_semaphore_create(1);
    //    }
    //
    //    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    if (_isWinkFlameIn) {
        _isWinkFlameIn = NO;
        [_winkDelegate WinkFlameOut];
        
    }
    
    for (CIFaceFeature* face in features) {
        
        NSLog(@"WIKCamDelegateCaptureOutput leftProgressProgress %f",self.leftProgressProgress);
        NSLog(@"WIKCamDelegateCaptureOutput rightProgressProgress %f",self.rightProgressProgress);
        if(!_isWinkFlameIn) {
            _isWinkFlameIn = true;
            [_winkDelegate WinkFlameIn];
        }
        
        
        if (face.hasSmile) {
            //                println("hasSmile")
            //            self.leftProgressProgress = 0.0f;
            //            self.rightProgressProgress = 0.0f;
            [_winkDelegate WinkSmile];
            break;
        }
        
        if (face.leftEyeClosed && face.rightEyeClosed) {
            if (self.leftProgressProgress >= kLongCloseOmomi && self.rightProgressProgress >= kLongCloseOmomi) {
                NSLog(@"目長く閉じる検出leftProgressProgress %f",self.leftProgressProgress);
                NSLog(@"目長く閉じる検出rightProgressProgress %f",self.rightProgressProgress);
                
                //                self.closeFlg = true;
                self.leftProgressProgress = 0.0f;
                self.rightProgressProgress = 0.0f;
                [_winkDelegate WinkLongClose];
                break;
            } else {
                self.leftProgressProgress += kPoint;
                self.rightProgressProgress += kPoint;
                break;
            }
        }
        
        if (self.leftProgressProgress >= kCloseOmomi && self.rightProgressProgress >= kCloseOmomi) {
            //時間が過ぎているので、これはアクションを行いたいという認識とする
            
            if (!face.leftEyeClosed && !face.rightEyeClosed) {
                //どっちも閉じていない場合
                NSLog(@"目短く閉じる検出leftProgressProgress %f",self.leftProgressProgress);
                NSLog(@"目短く閉じる検出rightProgressProgress %f",self.rightProgressProgress);//                self.closeFlg = true
                self.leftProgressProgress = 0.0f;
                self.rightProgressProgress = 0.0f;
                [_winkDelegate WinkClose];
                break;
            }

            
        }
        
        if(!face.rightEyeClosed && self.leftProgressProgress >= kCloseOmomi && self.rightProgressProgress == 0.0f)
        {
            self.leftProgressProgress = 0.0f;
            self.rightProgressProgress = 0.0f;
            [_winkDelegate WinkRightClose];
            break;
            
        }
        else if(!face.leftEyeClosed && self.rightProgressProgress >= kCloseOmomi && self.leftProgressProgress == 0.0f) {
            self.leftProgressProgress = 0.0f;
            self.rightProgressProgress = 0.0f;
            [_winkDelegate WinkLeftClose];
            break;
            
            
        }
        
        
        if (!face.leftEyeClosed && !face.rightEyeClosed) {
            //両目が開いているのでリセット
            self.leftProgressProgress = 0.0f;
            self.rightProgressProgress = 0.0f;
            break;
        }
        
        
        if (face.leftEyeClosed)  {
            self.leftProgressProgress += kPoint;
            
        }
        
        if (face.rightEyeClosed)  {
            self.rightProgressProgress += kPoint;
            
        }
        
        
        
        break;
        //            winkDelegate?.WinkLeftCloseWithPoint!(self.leftProgressProgress)
        //            winkDelegate?.WinkRightCloseWithPoint!(self.rightProgressProgress)
        
    }
    //    dispatch_semaphore_signal(semaphore);
    
    
}

@end
