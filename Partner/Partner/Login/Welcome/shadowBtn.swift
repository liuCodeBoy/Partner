//
//  shadowBtn.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/1/4.
//

import UIKit

class shadowBtn: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        let  layer   = CALayer.init(layer: self)
//        layer.frame  =  frame
//        layer.shadowOffset = CGSize.init(width: 5, height: 5)
//        layer.shadowOpacity = 0.8;
//        layer.backgroundColor = UIColor.gray.cgColor
//        layer.cornerRadius = 20
//        
//        self.view.layer.addSublayer(layer)
//        
//        aa.layer.shadowOffset = CGSize.init(width: 5, height: 5)
//        aa.layer.shadowOpacity = 0.8;
//        aa.layer.shadowColor =  UIColor.gray.cgColor
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
