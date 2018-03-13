//
//  ServiceMainHeaderTableViewCell.swift
//  Partner
//
//  Created by Weslie on 23/02/2018.
//

import UIKit

typealias pushProvideVCType  = (Int , String) -> ()
class ServiceMainHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var fourView: UIView!
    @IBOutlet weak var fiveView: UIView!
    @IBOutlet weak var sixView: UIView!
    @IBOutlet weak var sevenView: UIView!
    
    var modelArr : [ServiceProvideListModel]?
    var pushClouse : pushProvideVCType?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        for model in modelArr {
//
//        }
    }

    @IBAction func getProvideVC(_ sender: UIButton) {
        guard let modelArr = self.modelArr else {
            return
        }
        guard self.pushClouse != nil else {
            return
        }
     
        let ID = sender.inputTitleID
        switch ID {
        case "rzdj":
            let model = modelArr[0]
            self.pushClouse!((model.id as? Int)!, model.typeName!)
            break
        case "flzc":
            let model = modelArr[1]
            self.pushClouse!((model.id as? Int)!, model.typeName!)
            break
        case "jszc":
            let model = modelArr[2]
            self.pushClouse!((model.id as? Int)!, model.typeName!)
            break
        case "ppxc":
            let model = modelArr[3]
            self.pushClouse!((model.id as? Int)!, model.typeName!)
            break
        case "cskj":
            let model = modelArr[4]
            self.pushClouse!((model.id as? Int)!, model.typeName!)
            break
        case "rczy":
            let model = modelArr[5]
            self.pushClouse!((model.id as? Int)!, model.typeName!)
            break
        default:
            let model = modelArr[6]
            self.pushClouse!((model.id as? Int)!, model.typeName!)
            break
        }
     
    }
    
}
