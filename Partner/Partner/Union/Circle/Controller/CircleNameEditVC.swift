//
//  CircleNameEditVC.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/2/24.
//

import UIKit

class CircleNameEditVC: UIViewController {
    var circlenameSegue : UIStoryboardSegue?
    @IBOutlet weak var editTextField: UITextField!
    @IBAction func dismissVCAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func submitAction(_ sender: Any) {
        guard  editTextField.text != nil  else {
            
            return
        }
        let  sourceVC = circlenameSegue?.source as! CircleManageVC
        
        
    }
    
}
