//
//  Extension+UIView.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/1/16.
//

import UIKit

extension UIView{
    var x :  CGFloat {
        set{
            self.frame.origin.x = newValue
        }
        get{
           return self.frame.origin.x
        }
    }
    
    var y :  CGFloat {
        set{
            self.frame.origin.y = newValue
        }
        get{
           return self.frame.origin.y;
        }
    }
    
    
    var centerX :  CGFloat {
        set{
             self.center.x = newValue
        }
        get{
            return  self.center.x;
        }
    }
    
    
    
    var centerY :  CGFloat {
        set{
          self.center.x = newValue
        }
        get{
            return self.center.y;
        }
    }
    
    
    var width :  CGFloat {
        set{
            self.frame.size.width = newValue
        }
        get{
           return self.frame.size.width;
        }
    }
   
    var height :  CGFloat {
        set{
            self.frame.size.height = newValue
        }
        get{
           return self.frame.size.height;
        }
    }
    
    var size :  CGSize {
        set{
            self.frame.size = newValue
        }
        get{
            return self.frame.size;
        }
    }
    
    var origin :  CGPoint {
        set{
            self.frame.origin = newValue
        }
        get{
           return self.frame.origin;
        }
    }

}

extension UILabel {
    //获取高度
    func getLabHeight(labelStr: String, font: UIFont, width: CGFloat) -> CGFloat {
        let statusLabelText = labelStr
        let size = CGSize(width: width, height: 900)
        let dic = NSDictionary(object: font, forKey: NSAttributedStringKey.font as NSCopying)
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as! [NSAttributedStringKey : Any] , context: nil).size
        return strSize.height
    }
}

extension UIButton {
    //计算文字大小
    class func getTextRectSize(text: NSString,font: UIFont,size: CGSize) -> CGRect {
        let attributes = [NSAttributedStringKey.font: font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect:CGRect = text.boundingRect(with: size, options: option, attributes: attributes, context: nil)
        return rect;
    }
}
