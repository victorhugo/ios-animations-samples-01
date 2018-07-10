//
//  AnimatedButton.swift
//  Animations Showcase
//
//  Created by Victor Hugo Pérez Alvarado on 08/07/18.
//  Copyright © 2018 Chilaquil. All rights reserved.
//

import UIKit

class AnimatedButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var originalBGColor:UIColor?
    
    override var isSelected: Bool {
        willSet {
//            print("changing from \(isSelected) to \(newValue)")
        }
        
        didSet {
            print("changed from \(oldValue) to \(isSelected)")
            isSelected ?  transitionToSelected() : transitionToUnselected()
        }
    }

    func transitionToSelected(){
        if  originalBGColor == nil {
            originalBGColor = self.backgroundColor
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundColor = UIColor(red:0.99, green:0.86, blue:0.54, alpha:1.00)
            self.setTitleColor(UIColor.black, for: .normal)
        }) { (flag) in
            print("\(flag) transitionToSelected")
        }
    }
    
    
    
    func transitionToUnselected(){
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundColor = self.originalBGColor
            self.setTitleColor(UIColor.white, for: .normal)
        }) { (flag) in
            print("\(flag) transitionToUnselected")
        }
    }
    
    override var isHighlighted: Bool{
        willSet {
            print("changing from \(isSelected) to \(newValue)")
        }
        
        didSet {
            print("changed isHighlighted from \(oldValue) to \(isHighlighted)")
        }
    }
}
