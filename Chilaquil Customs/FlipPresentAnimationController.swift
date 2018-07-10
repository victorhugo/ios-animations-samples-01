/// Copyright (c) 2017 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class FlipPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
  
  private let originFrame: CGRect
    private let imageRef:UIImageView
  
    init(originFrame: CGRect, image:UIImageView) {
    self.originFrame = originFrame
        self.imageRef = image
  }
    
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 1.5
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    
    guard let fromVC = transitionContext.viewController(forKey: .from),
      let toVC = transitionContext.viewController(forKey: .to),
      let snapshot = toVC.view.snapshotView(afterScreenUpdates: true)
      else {
        print("No se pudo")
        return
    }
    
    let containerView = transitionContext.containerView
    let finalFrame = transitionContext.finalFrame(for: toVC)
    
//    snapshot.frame = originFrame
    print("frame ->\(toVC.view.frame)")
    snapshot.frame = toVC.view.frame
    
    //snapshot.layer.cornerRadius = CardViewController.cardCornerRadius
    snapshot.layer.masksToBounds = true
    snapshot.alpha = 0.0
    
    containerView.backgroundColor = UIColor.red
    containerView.addSubview(toVC.view)
    containerView.addSubview(snapshot)
    
    toVC.view.isHidden = true
    
    AnimationHelper.perspectiveTransform(for: containerView)
    
    //snapshot.layer.transform = AnimationHelper.yRotation(.pi / 2)
    
    let duration = transitionDuration(using: transitionContext)
    
    UIView.animateKeyframes(
      withDuration: duration,
      delay: 0,
      options: .calculationModeCubic,
      animations: {
        UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/3) {
            snapshot.alpha = 1.0
        }
        UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/3) {
            
            
        //  fromVC.view.layer.transform = AnimationHelper.yRotation(-.pi / 2)
            let thumb =  self.imageRef
            let scaleWidth =  CGFloat(thumb.frame.size.width / toVC.view.frame.width )
            let scaleHeight =  CGFloat(thumb.frame.size.height / toVC.view.frame.height)
            print("New scale width:\(scaleWidth)")
            print("New scale hegiht:\(scaleHeight)")

            self.imageRef.layer.transform =
            CATransform3DMakeScale(2.0, 2.0, 1.0)
            
            let end = CGPoint(x:187, y: 73)
            let difference = end - self.imageRef.center
            let translate = CATransform3DTranslate(CATransform3DIdentity, difference.x, difference.y, 0.0)
            self.imageRef.layer.transform =
                translate
            
//                CATransform3DMakeAffineTransform(CGAffineTransform.init(scaleX: 2.0, y: 2.0))
            
            
//            .view.layer.transform = CATransform3DMakeAffineTransform(CGAffineTransform.init(scaleX: <#T##CGFloat#>, y: <#T##CGFloat#>))
        }
        
//        UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 1/3) {
//          snapshot.layer.transform = AnimationHelper.yRotation(0.0)
//        }
//
//        UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3) {
//          snapshot.frame = finalFrame
//          snapshot.layer.cornerRadius = 0
//        }
    },
      completion: { _ in
        toVC.view.isHidden = false
        snapshot.removeFromSuperview()
        fromVC.view.layer.transform = CATransform3DIdentity
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        self.imageRef.frame = self.originFrame
    })
  }
}


import SpriteKit

public extension CGPoint {
    /**
     * Creates a new CGPoint given a CGVector.
     */
    public init(vector: CGVector) {
        self.init(x: vector.dx, y: vector.dy)
    }
    
    /**
     * Given an angle in radians, creates a vector of length 1.0 and returns the
     * result as a new CGPoint. An angle of 0 is assumed to point to the right.
     */
    public init(angle: CGFloat) {
        self.init(x: cos(angle), y: sin(angle))
    }
    
    /**
     * Adds (dx, dy) to the point.
     */
    public mutating func offset(dx: CGFloat, dy: CGFloat) -> CGPoint {
        x += dx
        y += dy
        return self
    }
    
    /**
     * Returns the length (magnitude) of the vector described by the CGPoint.
     */
    public func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    /**
     * Returns the squared length of the vector described by the CGPoint.
     */
    public func lengthSquared() -> CGFloat {
        return x*x + y*y
    }
    
    /**
     * Normalizes the vector described by the CGPoint to length 1.0 and returns
     * the result as a new CGPoint.
     */
    func normalized() -> CGPoint {
        let len = length()
        return len>0 ? self / len : CGPoint.zero
    }
    
    /**
     * Normalizes the vector described by the CGPoint to length 1.0.
     */
    public mutating func normalize() -> CGPoint {
        self = normalized()
        return self
    }
    
    /**
     * Calculates the distance between two CGPoints. Pythagoras!
     */
    public func distanceTo(_ point: CGPoint) -> CGFloat {
        return (self - point).length()
    }
    
    /**
     * Returns the angle in radians of the vector described by the CGPoint.
     * The range of the angle is -π to π; an angle of 0 points to the right.
     */
    public var angle: CGFloat {
        return atan2(y, x)
    }
}

/**
 * Adds two CGPoint values and returns the result as a new CGPoint.
 */
public func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

/**
 * Increments a CGPoint with the value of another.
 */
public func += (left: inout CGPoint, right: CGPoint) {
    left = left + right
}

/**
 * Adds a CGVector to this CGPoint and returns the result as a new CGPoint.
 */
public func + (left: CGPoint, right: CGVector) -> CGPoint {
    return CGPoint(x: left.x + right.dx, y: left.y + right.dy)
}

/**
 * Increments a CGPoint with the value of a CGVector.
 */
public func += (left: inout CGPoint, right: CGVector) {
    left = left + right
}

/**
 * Subtracts two CGPoint values and returns the result as a new CGPoint.
 */
public func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

/**
 * Decrements a CGPoint with the value of another.
 */
public func -= (left: inout CGPoint, right: CGPoint) {
    left = left - right
}

/**
 * Subtracts a CGVector from a CGPoint and returns the result as a new CGPoint.
 */
public func - (left: CGPoint, right: CGVector) -> CGPoint {
    return CGPoint(x: left.x - right.dx, y: left.y - right.dy)
}

/**
 * Decrements a CGPoint with the value of a CGVector.
 */
public func -= (left: inout CGPoint, right: CGVector) {
    left = left - right
}

/**
 * Multiplies two CGPoint values and returns the result as a new CGPoint.
 */
public func * (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x * right.x, y: left.y * right.y)
}

/**
 * Multiplies a CGPoint with another.
 */
public func *= (left: inout CGPoint, right: CGPoint) {
    left = left * right
}

/**
 * Multiplies the x and y fields of a CGPoint with the same scalar value and
 * returns the result as a new CGPoint.
 */
public func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

/**
 * Multiplies the x and y fields of a CGPoint with the same scalar value.
 */
public func *= (point: inout CGPoint, scalar: CGFloat) {
    point = point * scalar
}

/**
 * Multiplies a CGPoint with a CGVector and returns the result as a new CGPoint.
 */
public func * (left: CGPoint, right: CGVector) -> CGPoint {
    return CGPoint(x: left.x * right.dx, y: left.y * right.dy)
}

/**
 * Multiplies a CGPoint with a CGVector.
 */
public func *= (left: inout CGPoint, right: CGVector) {
    left = left * right
}

/**
 * Divides two CGPoint values and returns the result as a new CGPoint.
 */
public func / (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x / right.x, y: left.y / right.y)
}

/**
 * Divides a CGPoint by another.
 */
public func /= (left: inout CGPoint, right: CGPoint) {
    left = left / right
}

/**
 * Divides the x and y fields of a CGPoint by the same scalar value and returns
 * the result as a new CGPoint.
 */
public func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

/**
 * Divides the x and y fields of a CGPoint by the same scalar value.
 */
public func /= (point: inout CGPoint, scalar: CGFloat) {
    point = point / scalar
}

/**
 * Divides a CGPoint by a CGVector and returns the result as a new CGPoint.
 */
public func / (left: CGPoint, right: CGVector) -> CGPoint {
    return CGPoint(x: left.x / right.dx, y: left.y / right.dy)
}

/**
 * Divides a CGPoint by a CGVector.
 */
public func /= (left: inout CGPoint, right: CGVector) {
    left = left / right
}

/**
 * Performs a linear interpolation between two CGPoint values.
 */
public func lerp(start: CGPoint, end: CGPoint, t: CGFloat) -> CGPoint {
    return start + (end - start) * t
}
