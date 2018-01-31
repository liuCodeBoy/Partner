//
//  Designable+UIView.swift
//  Partner
//
//  Created by Weslie on 29/01/2018.
//

import UIKit

@IBDesignable
open class ShadowView: UIView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBInspectable
    public var cornerRadius: CGFloat = 2.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }
    
    @IBInspectable
    public var shadowOpacity: Float = 0.5 {
        didSet {
            layer.shadowOpacity = self.shadowOpacity
        }
    }
    
    @IBInspectable
    public var shadowOffset: CGSize = CGSize(width: 10, height: 10) {
        didSet {
            layer.shadowOffset = self.shadowOffset
        }
    }
    
    @IBInspectable
    public var shadowColor: UIColor = UIColor.gray {
        didSet {
            layer.shadowColor = self.shadowColor.cgColor
        }
    }
    
    @IBInspectable
    public var shadowRadius: CGFloat = 0 {
        didSet {
            layer.shadowRadius = self.shadowRadius
        }
    }
    
    @IBInspectable
    public var borderColor: UIColor = UIColor.white {
        didSet {
            layer.borderColor = self.borderColor.cgColor
        }
    }
    
    @IBInspectable
    public var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = self.borderWidth
        }
    }
}
