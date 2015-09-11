//
//  WIKCamViewController.m
//  WIKCamViewController
//
//  Created by COFFEE on 2015/09/04.
//  Copyright (c) 2015年 COFFEE. All rights reserved.
//

#import "WIKCamViewController.h"

@interface WIKCamViewController ()
@property BOOL isClose;
@end

@implementation WIKCamViewController

- (void)viewDidLoad
{
    NSLog(@"%s%d",__FUNCTION__,__LINE__);
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"%s%d",__FUNCTION__,__LINE__);
    [super viewDidAppear:animated];
    
    //TODO:カメラをフロントにする
    if(!self->isUsingFrontFacingCamera){
        [self switchCameras:nil];
    }
    
    //認識開始する
    UISwitch* swit = [[UISwitch alloc] initWithFrame:CGRectZero];
    swit.on = YES;
    [self toggleFaceDetection:swit];
    
}



- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    // got an image
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    CIImage *ciImage = [[CIImage alloc] initWithCVPixelBuffer:pixelBuffer options:(__bridge NSDictionary *)attachments];
    if (attachments)
        CFRelease(attachments);
    
    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
    int exifOrientation;
    
    /* kCGImagePropertyOrientation values
     The intended display orientation of the image. If present, this key is a CFNumber value with the same value as defined
     by the TIFF and EXIF specifications -- see enumeration of integer constants.
     The value specified where the origin (0,0) of the image is located. If not present, a value of 1 is assumed.
     
     used when calling featuresInImage: options: The value for this key is an integer NSNumber from 1..8 as found in kCGImagePropertyOrientation.
     If present, the detection will be done based on that orientation but the coordinates in the returned features will still be based on those of the image. */
    
    enum {
        PHOTOS_EXIF_0ROW_TOP_0COL_LEFT			= 1, //   1  =  0th row is at the top, and 0th column is on the left (THE DEFAULT).
        PHOTOS_EXIF_0ROW_TOP_0COL_RIGHT			= 2, //   2  =  0th row is at the top, and 0th column is on the right.
        PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT      = 3, //   3  =  0th row is at the bottom, and 0th column is on the right.
        PHOTOS_EXIF_0ROW_BOTTOM_0COL_LEFT       = 4, //   4  =  0th row is at the bottom, and 0th column is on the left.
        PHOTOS_EXIF_0ROW_LEFT_0COL_TOP          = 5, //   5  =  0th row is on the left, and 0th column is the top.
        PHOTOS_EXIF_0ROW_RIGHT_0COL_TOP         = 6, //   6  =  0th row is on the right, and 0th column is the top.
        PHOTOS_EXIF_0ROW_RIGHT_0COL_BOTTOM      = 7, //   7  =  0th row is on the right, and 0th column is the bottom.
        PHOTOS_EXIF_0ROW_LEFT_0COL_BOTTOM       = 8  //   8  =  0th row is on the left, and 0th column is the bottom.
    };
    
    switch (curDeviceOrientation) {
        case UIDeviceOrientationPortraitUpsideDown:  // Device oriented vertically, home button on the top
            exifOrientation = PHOTOS_EXIF_0ROW_LEFT_0COL_BOTTOM;
            break;
        case UIDeviceOrientationLandscapeLeft:       // Device oriented horizontally, home button on the right
            if (isUsingFrontFacingCamera)
                exifOrientation = PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT;
            else
                exifOrientation = PHOTOS_EXIF_0ROW_TOP_0COL_LEFT;
            break;
        case UIDeviceOrientationLandscapeRight:      // Device oriented horizontally, home button on the left
            if (isUsingFrontFacingCamera)
                exifOrientation = PHOTOS_EXIF_0ROW_TOP_0COL_LEFT;
            else
                exifOrientation = PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT;
            break;
        case UIDeviceOrientationPortrait:            // Device oriented vertically, home button on the bottom
        default:
            exifOrientation = PHOTOS_EXIF_0ROW_RIGHT_0COL_TOP;
            break;
    }
    NSDictionary *imageOptions = @{ CIDetectorSmile:@YES,
                                    CIDetectorEyeBlink:@YES,
                                    CIDetectorImageOrientation:[NSNumber numberWithInt:exifOrientation]
                                    };
    
    //	imageOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:exifOrientation] forKey:CIDetectorImageOrientation];
    NSArray *features = [faceDetector featuresInImage:ciImage options:imageOptions];
    [_delegate WIKCamDelegateCaptureOutput:features];
////    [ciImage release];
//
//    // get the clean aperture
//    // the clean aperture is a rectangle that defines the portion of the encoded pixel dimensions
//    // that represents image data valid for faceDetectordisplay.
//    //	CMFormatDescriptionRef fdesc = CMSampleBufferGetFormatDescription(sampleBuffer);
//    //	CGRect clap = CMVideoFormatDescriptionGetCleanAperture(fdesc, false /*originIsTopLeft == false*/);
//    
//    for(CIFaceFeature* face in features){
//        // faceを使って何かする（矩形を描画する、など）
//        if ([face leftEyeClosed] || [face rightEyeClosed]) {
//            NSLog(@"eye closed");
//            //[self takePicture:nil];
//            _isClose = YES;
//            return;
//        }
//        
//    }
//    
//    //改めて全ての要素チェックして、全員の目が開いていたらシャッター
//    if(_isClose){
//        for(CIFaceFeature* face in features){
//            // faceを使って何かする（矩形を描画する、など）
//            if ([face leftEyeClosed] || [face rightEyeClosed]) {
//                NSLog(@"eye closed");
//                //[self takePicture:nil];
//                _isClose = YES;
//                return;
//            }
//            
//        }
//        //returnしていなかったら、シャッターを押す
//        [self takePicture:nil];
//        _isClose = NO;
//    }
    
    
    
    //	dispatch_async(dispatch_get_main_queue(), ^(void) {
    //		[self drawFaceBoxesForFeatures:features forVideoBox:clap orientation:curDeviceOrientation];
    //	});
}

#pragma mark -
#pragma mark UIViewController
- (BOOL)shouldAutorotate
// 回転を許可するかどうかを返す
{
    return YES; // NOなら回転させない
}


@end
