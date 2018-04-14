//
//  PartnerPickerView.swift
//  Partner
//
//  Created by Weslie on 18/01/2018.
//

import UIKit

enum SecondaryPickerType: String {
    case enterpriseType = "enterpriseType"
    case enterpriseLocation = "enterpriseLocation"
    case projLocation = "projLocation"
    case community = "community"
}

class PartnerPickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var type: SecondaryPickerType?
    
    var projModel: ProjectModel?
    var authModel: AuthModel?
    var profileModel: ProfileInfoModel?
    
    var twoDimensionArray = [[String : AnyObject]]()
    
    var firstComponentRows: Int = 0
    var secondaryComponentRows: Int = 0
    var firstComponentArray = [String]()
    var secondaryComponentArray = [String]()
    var secondaryComponentDictArray = [[String : AnyObject]]()
    
    var inputLbl: UILabel?

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var pickerTitle: UILabel!
    @IBOutlet weak var pickerContainerView: UIView!
    @IBOutlet weak var partnerPicker: UIPickerView!
    
    @IBAction func closeBtnClicked(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.backgroundView.alpha = 0
            self.pickerContainerView.transform = CGAffineTransform(translationX: 0, y: 266)
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        partnerPicker.delegate = self
        partnerPicker.dataSource = self
        
        // appear animation
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.backgroundView.alpha = 0.3
            self.pickerContainerView.transform = CGAffineTransform(translationX: 0, y: -266)
            
        }, completion: nil)
        
        // tap back view to dismiss
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeBtnClicked(_:)))
        backgroundView.addGestureRecognizer(tap)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // judge the component
        if component == 0 {
            if firstComponentArray.count == 0 {
                for dict in twoDimensionArray {
                    let province = dict["name"] as! String
                    firstComponentArray.append(province)
                }
            }
            return firstComponentArray.count
        } else {
            // reload array
            secondaryComponentArray.removeAll()
            secondaryComponentDictArray.removeAll()
            
            guard twoDimensionArray.count != 0 else { return 0 }
            
            switch type! {
            case .enterpriseType:
                // save secondary component data source
                secondaryComponentDictArray = twoDimensionArray[firstComponentRows]["children"] as! [[String: AnyObject]]
                for dict in secondaryComponentDictArray {
                    let name = dict["typeName"] as! String
                    secondaryComponentArray.append(name)
                }
                // save the default id
                /////
                if let id = secondaryComponentDictArray[0]["id"] as? NSNumber {
                    authModel?.typeIds = "\(id)"
                }
                inputLbl?.text = secondaryComponentDictArray[0]["typeName"] as? String
            case .enterpriseLocation:
                // save secondary component data source
                secondaryComponentDictArray = twoDimensionArray[firstComponentRows]["cityList"] as! [[String: AnyObject]]
                for dict in secondaryComponentDictArray {
                    let city = dict["name"] as! String
                    secondaryComponentArray.append(city)
                }
                // save the default id
                authModel?.areaId = secondaryComponentDictArray[0]["id"] as? NSNumber
                inputLbl?.text = secondaryComponentDictArray[0]["name"] as? String
            case .projLocation:
                // save secondary component data source
                secondaryComponentDictArray = twoDimensionArray[firstComponentRows]["cityList"] as! [[String: AnyObject]]
                for dict in secondaryComponentDictArray {
                    let city = dict["name"] as! String
                    secondaryComponentArray.append(city)
                }
                // save the default id
                projModel?.areaId = secondaryComponentDictArray[0]["id"] as? NSNumber
                inputLbl?.text = secondaryComponentDictArray[0]["name"] as? String

            case .community:
                // save secondary component data source
                secondaryComponentDictArray = twoDimensionArray[firstComponentRows]["commList"] as! [[String: AnyObject]]
                for dict in secondaryComponentDictArray {
                    let city = dict["name"] as! String
                    secondaryComponentArray.append(city)
                }
                // save the default id
                profileModel?.communityId = secondaryComponentDictArray[0]["id"] as? NSNumber
                inputLbl?.text = secondaryComponentDictArray[0]["name"] as? String
            }
            
            return secondaryComponentArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 38
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        // set seperate line's color
        for singleLine in pickerView.subviews {
            if singleLine.frame.size.height < 2 {
                singleLine.backgroundColor = #colorLiteral(red: 0.8432456255, green: 0.8734833598, blue: 0.8959761262, alpha: 1)
            }
        }
        
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.2313725501, green: 0.2941176593, blue: 0.3411764801, alpha: 1)
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = NSTextAlignment.center

        if component == 0 {
            label.text = firstComponentArray[row]
        } else {
            label.text = secondaryComponentArray[row]
        }
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            firstComponentRows = pickerView.selectedRow(inComponent: 0)
            pickerView.reloadComponent(1)
        } else {
            // save city id
            switch type! {
            case .enterpriseType:
                authModel?.areaId = secondaryComponentDictArray[row]["id"] as? NSNumber
                inputLbl?.text = secondaryComponentDictArray[row]["typeName"] as? String
            case .projLocation:
                projModel?.areaId = secondaryComponentDictArray[row]["id"] as? NSNumber
                inputLbl?.text = secondaryComponentDictArray[row]["name"] as? String
            case .enterpriseLocation:
                if let id = secondaryComponentDictArray[row]["id"] as? NSNumber {
                    authModel?.typeIds = "\(id)"
                }
                inputLbl?.text = secondaryComponentDictArray[row]["typeName"] as? String
            case .community:
                profileModel?.communityId = secondaryComponentDictArray[row]["id"] as? NSNumber
                inputLbl?.text = secondaryComponentDictArray[row]["name"] as? String
            }
        }
    }
    

}
