//
//  ServiceMainHeaderTableViewCell.swift
//  Partner
//
//  Created by Weslie on 23/02/2018.
//

import UIKit

typealias pushProvideVCType  = (Int , String) -> ()
class ServiceMainHeaderTableViewCell: UITableViewCell {
    @IBOutlet weak var onelab: UILabel!
    @IBOutlet weak var twolab: UILabel!
    @IBOutlet weak var threeLab: UILabel!
    @IBOutlet weak var fourLab: UILabel!
    @IBOutlet weak var fiveLab: UILabel!
    @IBOutlet weak var sixLab: UILabel!
    @IBOutlet weak var seven: UILabel!
    
    @IBOutlet weak var fiveButton: UIButton!
    
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var fourView: UIView!
    @IBOutlet weak var fiveView: UIView!
    @IBOutlet weak var sixView: UIView!
    @IBOutlet weak var sevenView: UIView!
    var modelArr = [ServiceProvideListModel]()
   
    var pushClouse : pushProvideVCType?
    
    override func awakeFromNib() {
        super.awakeFromNib()
            getListType()
    }
    
    
    func getListType(){
        NetWorkTool.shareInstance.getTypeList(typeCate: 2) { [weak self](info, error) in
            if error == nil {
                // MARK:- judge the return data from server
                if info?["code"] as? Int == 200 {
                    if  let  dictARR = info?["result"] as? [NSDictionary]{
                        for  dict in dictARR{
                            let   model = ServiceProvideListModel.mj_object(withKeyValues: dict)
                            self?.modelArr.append(model!)
                        }
                        if (self?.modelArr.count)! >= 1 {
                            self?.onelab.text = self?.modelArr[0].typeName
                        }
                        
                        if(self?.modelArr.count)! >= 2{
                            self?.twolab.text = self?.modelArr[1].typeName
                        }
                        if(self?.modelArr.count)! >= 3{
                            self?.threeLab.text = self?.modelArr[2].typeName
                        }
                        if(self?.modelArr.count)! >= 4{
                            self?.fourLab.text = self?.modelArr[3].typeName
                        }
                        if(self?.modelArr.count)! >= 5{
                            self?.fiveLab.text = self?.modelArr[4].typeName
                        }
                        if(self?.modelArr.count)! >= 6{
                            self?.sixLab.text = self?.modelArr[5].typeName
                        }
                        if(self?.modelArr.count)! >= 7{
                            self?.seven.text = self?.modelArr[6].typeName
                        }
                    }
                } else {
                    let  errorShow  =  info!["msg"] as! String
                }
            }
        }
    }

    @IBAction func getProvideVC(_ sender: UIButton) {
     
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
