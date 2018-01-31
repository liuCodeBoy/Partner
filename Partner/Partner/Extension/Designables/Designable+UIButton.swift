//
//  Designable+UIButton.swift
//  Partner
//
//  Created by Weslie on 29/01/2018.
//

import UIKit

@IBDesignable
open class ShadowButton: UIButton {
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
    
    public func reverseSelected() {
        // add shadow
        self.cornerRadius    = 4
        self.shadowColor     = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 0.6708583048)
        self.shadowOpacity   = 0.6
        self.shadowOffset    = CGSize(width: 0, height: 4)
        self.shadowRadius    = 4
        // set color
        self.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.setTitleColor(#colorLiteral(red: 0.5411764979, green: 0.631372571, blue: 0.6980392337, alpha: 1), for: .normal)
    }
    public func setSelected() {
        // remove shadow
        self.shadowColor     = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.shadowOpacity   = 0
        self.shadowOffset    = CGSize(width: 0, height: 0)
        self.shadowRadius    = 0
        // set color
        self.backgroundColor = #colorLiteral(red: 0.5411764979, green: 0.631372571, blue: 0.6980392337, alpha: 1)
        self.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
    }
}
