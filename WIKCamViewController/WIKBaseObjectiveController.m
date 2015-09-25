//
//  WIKBaseObjectiveController.m
//  WIKCamViewController
//
//  Created by COFFEE on 2015/09/25.
//  Copyright © 2015年 COFFEE. All rights reserved.
//

#import "WIKBaseObjectiveController.h"

const float kOmomi = 1.0f;
const float kLongCloseOmomi = 0.9f;
const float kCloseOmomi = 0.2f;
const float kPoint = 0.05f;

@interface WIKBaseObjectiveController()

@property(atomic) BOOL isWinkFlameIn;
@property(atomic) float leftProgressProgress;
@property(atomic) float rightProgressProgress;



@end

@implementation WIKBaseObjectiveController

-(void)WIKCamDelegateCaptureOutput:(NSArray*)features {
    if (_isWinkFlameIn) {
        _isWinkFlameIn = NO;
        [_winkDelegate WinkFlameOut];
        
    }
    
    for (CIFaceFeature* face in features) {
        if(!_isWinkFlameIn) {
            _isWinkFlameIn = true;
            [_winkDelegate WinkFlameIn];
        }
        
        if (face.leftEyeClosed && face.rightEyeClosed) {
            if (self.leftProgressProgress >= kLongCloseOmomi && self.rightProgressProgress >= kLongCloseOmomi) {
                NSLog(@"目長く閉じる検出");
//                self.closeFlg = true;
                self.leftProgressProgress = 0;
                self.rightProgressProgress = 0;
                [_winkDelegate WinkLongClose];
                return;
            } else {
                self.leftProgressProgress += kPoint;
                self.rightProgressProgress += kPoint;
                return;
            }
        }
        
        if (self.leftProgressProgress >= kCloseOmomi && self.rightProgressProgress >= kCloseOmomi) {
            //時間が過ぎているので、これはアクションを行いたいという認識とする
            
            if (!face.leftEyeClosed && !face.rightEyeClosed) {
                //どっちも閉じていない場合
                NSLog(@"目短く閉じる検出");
//                self.closeFlg = true
                self.leftProgressProgress = 0;
                self.rightProgressProgress = 0;
                [_winkDelegate WinkClose];
                return;
            }
        }
        
        
        if (!face.leftEyeClosed && !face.rightEyeClosed) {
            //両目が開いているのでリセット
            self.leftProgressProgress = 0;
            self.rightProgressProgress = 0;
            return;
        }
        
        
        if (face.leftEyeClosed)  {
            self.leftProgressProgress += kPoint;
            //                if self.leftProgressProgress >= self.kOmomi {
            //                    self.leftProgressProgress = 0
            //                    self.rightProgressProgress = 0
            //
            //                    winkDelegate?.WinkRightClose!()
            //
            //                    return
            //                }
        }
        //            else {
        //                self.leftProgressProgress = 0
        //            }
        
        if (face.rightEyeClosed)  {
            self.rightProgressProgress += kPoint;
            //                if self.rightProgressProgress >= self.kOmomi {
            //                    self.rightProgressProgress = 0
            //                    self.leftProgressProgress = 0
            //                    winkDelegate?.WinkLeftClose!()
            //                    return
            //                }
        }
        //            else {
        //                self.rightProgressProgress = 0
        //            }
        
        if (face.hasSmile) {
            //                println("hasSmile")
            //                winkDelegate?.WinkSmile!()
        }
        
        //            winkDelegate?.WinkLeftCloseWithPoint!(self.leftProgressProgress)
        //            winkDelegate?.WinkRightCloseWithPoint!(self.rightProgressProgress)
        
    }

}

@end
