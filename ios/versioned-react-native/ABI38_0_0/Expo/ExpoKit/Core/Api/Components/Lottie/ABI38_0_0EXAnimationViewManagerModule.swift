#if canImport(ABI38_0_0React)
import ABI38_0_0React
#endif

import Lottie

@objc(ABI38_0_0LottieAnimationView)
class AnimationViewManagerModule: ABI38_0_0RCTViewManager {
    override func view() -> UIView! {
        return ContainerView()
    }
    
    @objc override func constantsToExport() -> [AnyHashable : Any]! {
        return ["VERSION": 1]
    }
    
    
    @objc(play:fromFrame:toFrame:)
    public func play(_ reactTag: NSNumber, startFrame: NSNumber, endFrame: NSNumber) {
        
        self.bridge.uiManager.addUIBlock { (uiManager, viewRegistry) in
            guard let view = viewRegistry?[reactTag] as? ContainerView else {
              #if RCT_DEV
                print("Invalid view returned from registry, expecting ContainerView")
              #endif
              return
            }

            let callback: LottieCompletionBlock = { animationFinished in
                if let onFinish = view.onAnimationFinish {
                    onFinish(["isCancelled": !animationFinished])
                }
            }

            if (startFrame.intValue != -1 && endFrame.intValue != -1) {
                view.play(fromFrame: AnimationFrameTime(truncating: startFrame), toFrame: AnimationFrameTime(truncating: endFrame), completion: callback)
            } else {
                view.play(completion: callback)
            }
        }
    }
    
    @objc(reset:)
    public func reset(_ reactTag: NSNumber) {
        self.bridge.uiManager.addUIBlock { uiManager, viewRegistry in
            guard let view = viewRegistry?[reactTag] as? ContainerView else {
                #if RCT_DEV
                  print("Invalid view returned from registry, expecting ContainerView")
                #endif
                return
            }

            view.reset()
        }
    }
    
    @objc(pause:)
    public func pause(_ reactTag: NSNumber) {
        self.bridge.uiManager.addUIBlock { uiManager, viewRegistry in
            guard let view = viewRegistry?[reactTag] as? ContainerView else {
              #if RCT_DEV
                print("Invalid view returned from registry, expecting ContainerView")
              #endif
              return
            }

            view.pause()
        }
    }

    @objc(resume:)
    public func resume(_ reactTag: NSNumber) {
        self.bridge.uiManager.addUIBlock { uiManager, viewRegistry in
            guard let view = viewRegistry?[reactTag] as? ContainerView else {
              #if RCT_DEV
                print("Invalid view returned from registry, expecting ContainerView")
              #endif
              return
            }

            view.resume()
        }
    }
    
    override static func requiresMainQueueSetup() -> Bool {
        return true
    }
    
}
