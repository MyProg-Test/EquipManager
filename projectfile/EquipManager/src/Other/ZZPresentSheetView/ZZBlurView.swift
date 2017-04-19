//
//  ZZBlurView.swift
//  TransitionDemo
//
//  Created by duzhe on 16/7/18.
//  Copyright © 2016年 dz. All rights reserved.
//

import UIKit

class ZZBlurView: UIVisualEffectView {

    
    internal init() {
        super.init(effect: UIBlurEffect(style: .light))
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    fileprivate func commonInit() {
        backgroundColor = UIColor(white: 0.9, alpha: 0.5)
        layer.cornerRadius = 9.0
        layer.masksToBounds = true
        
        contentView.addSubview(self.content)
        
        let offset = 10.0
        
        let motionEffectsX = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        motionEffectsX.maximumRelativeValue = offset
        motionEffectsX.minimumRelativeValue = -offset
        
        let motionEffectsY = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        motionEffectsY.maximumRelativeValue = offset
        motionEffectsY.minimumRelativeValue = -offset
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [motionEffectsX, motionEffectsY]
        
        addMotionEffect(group)
    }
    
    fileprivate var _content = UIView()
    internal var content: UIView {
        get {
            return _content
        }
        set {
            _content.removeFromSuperview()
            _content = newValue
            _content.alpha = 0.85
            _content.clipsToBounds = true
            _content.contentMode = .center
            frame.size = _content.bounds.size
            addSubview(_content)
        }
    }
    
}
