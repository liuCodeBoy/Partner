//
//  Designable+UIImage.swift
//  Partner
//
//  Created by Weslie on 31/01/2018.
//

import UIKit

@IBDesignable
open class RoundRectImage: UIImageView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBInspectable
    public var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = self.cornerRadius
        }
    }
}
