//
//  RoadRaceAnim.swift
//
//  Code generated using QuartzCode 1.65.0 on 08/07/18.
//  www.quartzcodeapp.com
//

import UIKit

@IBDesignable
class RoadRaceAnim: UIView, CAAnimationDelegate {
	
	var updateLayerValueForCompletedAnimation : Bool = false
	var completionBlocks = [CAAnimation: (Bool) -> Void]()
	var layers = [String: CALayer]()
	
	var pista : UIColor!
	
	//MARK: - Life Cycle
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupProperties()
		setupLayers()
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		super.init(coder: aDecoder)
		setupProperties()
		setupLayers()
	}
	
	override var frame: CGRect{
		didSet{
			setupLayerFrames()
		}
	}
	
	override var bounds: CGRect{
		didSet{
			setupLayerFrames()
		}
	}
	
	func setupProperties(){
		self.pista = UIColor(red:0, green: 0, blue:0, alpha:0)
	}
	
	func setupLayers(){
		self.backgroundColor = UIColor(red:1.00, green: 1.00, blue:1.00, alpha:0.0)
		
		let roudroundalpha = CALayer()
		self.layer.addSublayer(roudroundalpha)
		layers["roudroundalpha"] = roudroundalpha
		
		let Elcamino = CAShapeLayer()
		self.layer.addSublayer(Elcamino)
		layers["Elcamino"] = Elcamino
		
		let yellowcar300x = CALayer()
		self.layer.addSublayer(yellowcar300x)
		layers["yellowcar300x"] = yellowcar300x
		
		resetLayerProperties(forLayerIdentifiers: nil)
		setupLayerFrames()
	}
	
	func resetLayerProperties(forLayerIdentifiers layerIds: [String]!){
		CATransaction.begin()
		CATransaction.setDisableActions(true)
		
		if layerIds == nil || layerIds.contains("roudroundalpha"){
			let roudroundalpha = layers["roudroundalpha"] as! CALayer
			roudroundalpha.shadowColor   = UIColor.black.cgColor
			roudroundalpha.shadowOpacity = 0.33
			roudroundalpha.shadowOffset  = CGSize(width: 7, height: 6)
			roudroundalpha.shadowRadius  = 4
			roudroundalpha.contents      = UIImage(named:"roud-round-alpha")?.cgImage
		}
		if layerIds == nil || layerIds.contains("Elcamino"){
			let Elcamino = layers["Elcamino"] as! CAShapeLayer
			Elcamino.fillColor   = nil
			Elcamino.strokeColor = self.pista.cgColor
		}
		if layerIds == nil || layerIds.contains("yellowcar300x"){
			let yellowcar300x = layers["yellowcar300x"] as! CALayer
			yellowcar300x.setValue(90 * CGFloat.pi/180, forKeyPath:"transform.rotation")
			yellowcar300x.shadowColor   = UIColor(red:1.00, green: 1.00, blue:1.00, alpha:1.0).cgColor
			yellowcar300x.shadowOpacity = 0.33
			yellowcar300x.shadowOffset  = CGSize(width: 2, height: 2)
			yellowcar300x.contents      = UIImage(named:"yellow  car 300x400")?.cgImage
		}
		
		CATransaction.commit()
	}
	
	func setupLayerFrames(){
		CATransaction.begin()
		CATransaction.setDisableActions(true)
		
		if let roudroundalpha = layers["roudroundalpha"]{
			roudroundalpha.frame = CGRect(x: 0.0129 * roudroundalpha.superlayer!.bounds.width, y: 0.02426 * roudroundalpha.superlayer!.bounds.height, width: 0.94838 * roudroundalpha.superlayer!.bounds.width, height: 0.93481 * roudroundalpha.superlayer!.bounds.height)
		}
		
		if let Elcamino = layers["Elcamino"] as? CAShapeLayer{
			Elcamino.frame = CGRect(x: 0.05193 * Elcamino.superlayer!.bounds.width, y: 0.07961 * Elcamino.superlayer!.bounds.height, width: 0.84569 * Elcamino.superlayer!.bounds.width, height: 0.79093 * Elcamino.superlayer!.bounds.height)
			Elcamino.path  = ElcaminoPath(bounds: layers["Elcamino"]!.bounds).cgPath
		}
		
		if let yellowcar300x = layers["yellowcar300x"]{
			yellowcar300x.transform = CATransform3DIdentity
			yellowcar300x.frame     = CGRect(x: 0.04387 * yellowcar300x.superlayer!.bounds.width, y: 0.88106 * yellowcar300x.superlayer!.bounds.height, width: 0.09677 * yellowcar300x.superlayer!.bounds.width, height: 0.16667 * yellowcar300x.superlayer!.bounds.height)
			yellowcar300x.setValue(90 * CGFloat.pi/180, forKeyPath:"transform.rotation")
		}
		
		CATransaction.commit()
	}
	
	//MARK: - Animation Setup
	
	func addCar(){
		let fillMode : String = kCAFillModeForwards
		
		////An infinity animation
		
		let yellowcar300x = layers["yellowcar300x"] as! CALayer
		
		////Yellowcar300x animation
		let yellowcar300xPositionAnim          = CAKeyframeAnimation(keyPath:"position")
        yellowcar300xPositionAnim.path         = ElcaminoPath(bounds: (layers["Elcamino"]?.superlayer?.convert((layers["Elcamino"] as! CAShapeLayer).frame, to:layers["yellowcar300x"]?.superlayer))!).cgPath
		yellowcar300xPositionAnim.rotationMode = kCAAnimationRotateAuto
		yellowcar300xPositionAnim.duration     = 4.59
		yellowcar300xPositionAnim.repeatCount  = Float.infinity
		
		let yellowcar300xCar_runingAnim : CAAnimationGroup = QCMethod.group(animations: [yellowcar300xPositionAnim], fillMode:fillMode)
		yellowcar300x.add(yellowcar300xCar_runingAnim, forKey:"yellowcar300xCar_runingAnim")
	}
	
	//MARK: - Animation Cleanup
	
	func animationDidStop(_ anim: CAAnimation, finished flag: Bool){
		if let completionBlock = completionBlocks[anim]{
			completionBlocks.removeValue(forKey: anim)
			if (flag && updateLayerValueForCompletedAnimation) || anim.value(forKey: "needEndAnim") as! Bool{
				updateLayerValues(forAnimationId: anim.value(forKey: "animId") as! String)
				removeAnimations(forAnimationId: anim.value(forKey: "animId") as! String)
			}
			completionBlock(flag)
		}
	}
	
	func updateLayerValues(forAnimationId identifier: String){
		if identifier == "car_runing"{
			QCMethod.updateValueFromPresentationLayer(forAnimation: layers["yellowcar300x"]!.animation(forKey: "yellowcar300xCar_runingAnim"), theLayer:layers["yellowcar300x"]!)
		}
	}
	
	func removeAnimations(forAnimationId identifier: String){
		if identifier == "car_runing"{
			layers["yellowcar300x"]?.removeAnimation(forKey: "yellowcar300xCar_runingAnim")
		}
	}
	
	func removeAllAnimations(){
		for layer in layers.values{
			layer.removeAllAnimations()
		}
	}
	
	//MARK: - Bezier Path
	
	func ElcaminoPath(bounds: CGRect) -> UIBezierPath{
		let ElcaminoPath = UIBezierPath()
		let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
		
		ElcaminoPath.move(to: CGPoint(x:minX + 0.09135 * w, y: minY + 0.92443 * h))
		ElcaminoPath.addCurve(to: CGPoint(x:minX + 0.92389 * w, y: minY + 0.93638 * h), controlPoint1:CGPoint(x:minX + 0.17289 * w, y: minY + 1.06037 * h), controlPoint2:CGPoint(x:minX + 0.82776 * w, y: minY + 0.98 * h))
		ElcaminoPath.addCurve(to: CGPoint(x:minX + 0.9988 * w, y: minY + 0.49456 * h), controlPoint1:CGPoint(x:minX + 1.02001 * w, y: minY + 0.89277 * h), controlPoint2:CGPoint(x:minX + 0.99702 * w, y: minY + 0.66638 * h))
		ElcaminoPath.addCurve(to: CGPoint(x:minX + 0.92389 * w, y: minY + 0.06476 * h), controlPoint1:CGPoint(x:minX + 1.0005 * w, y: minY + 0.32997 * h), controlPoint2:CGPoint(x:minX + 0.99617 * w, y: minY + 0.11365 * h))
		ElcaminoPath.addCurve(to: CGPoint(x:minX + 0.16348 * w, y: minY + 0.05926 * h), controlPoint1:CGPoint(x:minX + 0.77613 * w, y: minY + -0.03515 * h), controlPoint2:CGPoint(x:minX + 0.31086 * w, y: minY + -0.0053 * h))
		ElcaminoPath.addCurve(to: CGPoint(x:minX + 0.00265 * w, y: minY + 0.49717 * h), controlPoint1:CGPoint(x:minX + 0.01611 * w, y: minY + 0.12382 * h), controlPoint2:CGPoint(x:minX + -0.00949 * w, y: minY + 0.30655 * h))
		ElcaminoPath.addCurve(to: CGPoint(x:minX + 0.09135 * w, y: minY + 0.92443 * h), controlPoint1:CGPoint(x:minX + 0.0148 * w, y: minY + 0.68779 * h), controlPoint2:CGPoint(x:minX + 0.00981 * w, y: minY + 0.78849 * h))
		
		return ElcaminoPath
	}
	
    func pause() {
        let pausedTime: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }
    
    func resume() {
        let pausedTime: CFTimeInterval = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }
	
}
