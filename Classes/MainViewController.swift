//
//  MainViewController.swift
//  Animations Showcase
//
//  Created by Victor Hugo Pérez Alvarado on 07/07/18.
//  Copyright © 2018 Chilaquil. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var thumbnailReference: UIImageView!
    
    var isRuning = false
    
    @IBOutlet weak var theRoad: RoadRaceAnim!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         theRoad.addCar()
        theRoad.pause()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func tapHeader(_ sender: Any) {
        if isRuning{
            theRoad.pause()
            isRuning = false
        }else{
            theRoad.resume()
            isRuning = true
        }
        
        
    }
    
    @IBAction func clickOnTag(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func tabThumbButton(_ sender: Any) {
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier ==  "showThumbnailSegue" {
            let controller = segue.destination
            controller.transitioningDelegate = self
        }
        
    }
    
    

}


extension MainViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        return FlipPresentAnimationController(originFrame: thumbnailReference.frame, image: self.thumbnailReference)
    }
    
//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//
//        guard let revealVC = dismissed as? ContentDetailViewController else {
//            return nil
//        }
//
//        return FlipDismissAnimationController(destinationFrame: cardView.frame, interactionController: revealVC.swipeInteractionController)
//    }
    
//    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        
//        guard let animator = animator as? FlipDismissAnimationController,
//            let interactionController = animator.interactionController,
//            interactionController.interactionInProgress
//            else {
//                return nil
//        }
//        return interactionController
//    }
}
