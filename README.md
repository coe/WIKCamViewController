# WIKCamViewController
Facial recognition Controller for iOS

## description
このライブラリは、顔の状態を認識してコールバックするライブラリです。

## 取得できる動作
* 目を閉じる
* 目を長く閉じる
* 左目を閉じる
* 右目を閉じる
* 顔のフレームイン
* 顔のフレームアウト
* 笑顔

## How to Build
- WIKCamViewController.xcodeprojをあなたのプロジェクトに追加
- (for swift) Bridging-Header.hに`#import <WIKCamViewController/WIKFacialRecognition.h>`を追加
- 以下のフレームワークを導入する

    ImageIO.framework
    QuartzCore.framework
    CoreMedia.framework
    CoreGraphics.framework
    AssetsLibrary.framework
    CoreImage.framework
    AVFoundation.framework
    CoreVideo.framework
    UIKit.framework
    Foundation.framework


## How to use
- `WIKFacialRecognitionController` を顔認識を行いたいUIViewControllerで継承
- `self.winkDelegate = self` を行う
- `WIKFacialRecognitionControllerDelegate`のメソッドを実装
