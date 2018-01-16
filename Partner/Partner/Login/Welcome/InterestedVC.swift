//
//  InterestedVC.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/1/15.
//

import UIKit
import MyLayout
class InterestedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

     
    }
    
    
    override func loadView() {
        super.loadView()
        
        
        let S = MyTableLayout.init(orientation: MyOrientation_Vert)
        S?.wrapContentWidth = true
        S?.subviewHSpace = 10
        S?.subviewVSpace = 10
        S?.addRow(MyLayoutSize.wrap, colSize:MyLayoutSize.wrap)
        
        let A = UIView.init()
        A.mySize = CGSize.init(width: 50, height: 40)
        S?.addSubview(A)
        
        let B = UIView.init()
        B.mySize = CGSize.init(width: 150, height: 40)
        S?.addSubview(B)
        
        S?.addRow(MyLayoutSize.wrap, colSize:MyLayoutSize.wrap)
        let C = UIView.init()
        C.mySize = CGSize.init(width: 250, height: 40)
        S?.addSubview(C)
        
        A.backgroundColor = UIColor.red
        B.backgroundColor = UIColor.blue
        C.backgroundColor = UIColor.brown
        
        self.view.addSubview(S!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
