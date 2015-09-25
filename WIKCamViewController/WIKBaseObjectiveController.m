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

const NSTimeInterval kLongCloseSecond = 2.0f;
const NSTimeInterval kCloseSecond = 0.3f;
const NSTimeInterval kWinkSecond = 0.1f;

@interface WIKBaseObjectiveController() {
    //    dispatch_semaphore_t semaphore;
}

@property(atomic) BOOL isWinkFlameIn;
//@property(atomic) float leftProgressProgress;
//@property(atomic) float rightProgressProgress;
@property(atomic) NSDate* leftClosingDate;
@property(atomic) NSDate* rightClosingDate;

@property(atomic) BOOL isDone;



@end

@implementation WIKBaseObjectiveController

-(void)WIKCamDelegateCaptureOutput:(NSArray*)features {
    
    if (_isWinkFlameIn) {
        _isWinkFlameIn = NO;
        [_winkDelegate WinkFlameOut];
        
    }
    
    for (CIFaceFeature* face in features) {
        
        NSLog(@"%s%d",__func__,__LINE__);
        
        if(!_isWinkFlameIn) {
            _isWinkFlameIn = true;
            [_winkDelegate WinkFlameIn];
        }
        
        //笑ったら即時実行
        if (face.hasSmile) {
            [_winkDelegate WinkSmile];
            break;
        }
        
        //目を初めて閉じた場合の時間取得
        if (!_leftClosingDate && face.leftEyeClosed) {
            self.leftClosingDate = [NSDate date];
        }
        
        if (!_rightClosingDate && face.rightEyeClosed) {
            self.rightClosingDate = [NSDate date];
        }
        
        //長めに目を閉じた場合
        if (face.leftEyeClosed && face.rightEyeClosed) {
            if (([self.leftClosingDate compare:[NSDate dateWithTimeIntervalSinceNow:-kLongCloseSecond]] == NSOrderedAscending ) && ([self.rightClosingDate compare:[NSDate dateWithTimeIntervalSinceNow:-kLongCloseSecond]] == NSOrderedAscending )) {
                NSLog(@"%s%d",__func__,__LINE__);

//                NSLog(@"目長く閉じる検出leftProgressProgress %f",self.leftProgressProgress);
//                NSLog(@"目長く閉じる検出rightProgressProgress %f",self.rightProgressProgress);
                
                [self reset];
                [_winkDelegate WinkLongClose];
                break;
            }
        }
        
        //短めに目を閉じた場合
        if (([self.leftClosingDate compare:[NSDate dateWithTimeIntervalSinceNow:-kCloseSecond]] == NSOrderedAscending ) && ([self.rightClosingDate compare:[NSDate dateWithTimeIntervalSinceNow:-kCloseSecond]] == NSOrderedAscending )) {
            //時間が過ぎているので、これはアクションを行いたいという認識とする
            NSLog(@"%s%d",__func__,__LINE__);

            if (!face.leftEyeClosed && !face.rightEyeClosed) {
                //どっちも閉じていない場合
//                NSLog(@"目短く閉じる検出leftProgressProgress %f",self.leftProgressProgress);
                [self reset];
                [_winkDelegate WinkClose];
                break;
            }

            
        }
        
        //片目を閉じた場合
        
        //右目閉じ&左目オープン&右目閉じ時間が閾値を超えている場合
        if(face.rightEyeClosed && !face.leftEyeClosed && ([self.rightClosingDate compare:[NSDate dateWithTimeIntervalSinceNow:-kWinkSecond]] == NSOrderedAscending ))
        {
            NSLog(@"%s%d",__func__,__LINE__);

            if ([_winkDelegate respondsToSelector:@selector(WinkLeftClose)]) {
                [_winkDelegate WinkLeftClose];
                break;
            }
            
            
        }
        //左目閉じ&右目オープン&左目閉じ時間が閾値を超えている場合
        else if(face.leftEyeClosed && !face.rightEyeClosed && ([self.rightClosingDate compare:[NSDate dateWithTimeIntervalSinceNow:-kWinkSecond]] == NSOrderedAscending )) {
            //メソッドが存在する場合のみ
            NSLog(@"%s%d",__func__,__LINE__);

            if ([_winkDelegate respondsToSelector:@selector(WinkRightClose)]) {
                [_winkDelegate WinkRightClose];
                break;
            }
            
        }
        
        
        if (!face.leftEyeClosed && !face.rightEyeClosed) {
            //両目が開いているのでリセット
            [self reset];
            break;
        }

        
        break;
        
    }
    
    
}

-(void)reset {
    self.leftClosingDate = nil;
    self.rightClosingDate = nil;
}

@end
