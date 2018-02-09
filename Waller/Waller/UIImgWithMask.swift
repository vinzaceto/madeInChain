//
//  UIImgWithMask.swift
//  Waller
//
//  Created by Pasquale Mauriello on 06/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit
@IBDesignable
class UIImaggeViewWithMask: UIImageView {
    var imageToMaskView = UIImageView()
    var maskingImageView = UIImageView()
    
    @IBInspectable
    var shadowColor: UIColor = UIColor.clear {
        didSet {
            layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat = 0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize = CGSize(width: 0, height: 0) {
        didSet {
            layer.shadowOffset = shadowOffset
        }
    }
    
    
    @IBInspectable
    var shadowOpacity: Float = 0.0 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    
    @IBInspectable
    var imageToMask: UIImage? {
        didSet {
            imageToMaskView.image = imageToMask
            updateView()
        }
    }
    
    func updateView() {
        if imageToMaskView.image != nil {
            imageToMaskView.frame = bounds
            imageToMaskView.contentMode = .scaleAspectFit
            
            maskingImageView.image = image
            maskingImageView.frame = bounds
            maskingImageView.contentMode = .center
            
            imageToMaskView.layer.mask = maskingImageView.layer
            
            addSubview(imageToMaskView)
            
        }
    }
}

