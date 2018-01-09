//
//  ChooseIdentityVC.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/1/8.
//

import UIKit

class ChooseIdentityVC: UIViewController {
    @IBOutlet weak var investorBtnLab: UILabel!
    @IBOutlet weak var enterpreneurLab: UILabel!
    @IBOutlet weak var commonLab: UILabel!
    @IBOutlet weak var investorBtn: UIButton!
    @IBOutlet weak var entrepreneurBtn: UIButton!
    @IBOutlet weak var commonBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBorder(btn: investorBtn)
        setBorder(btn: entrepreneurBtn)
        setBorder(btn: commonBtn)

    }

    @IBAction func investorAction(_ sender: Any) {
        setSelected(btn: investorBtn, lab: investorBtnLab)
        setUnSelected(btn: entrepreneurBtn, lab: enterpreneurLab)
        setUnSelected(btn: commonBtn, lab: commonLab)
    }
    @IBAction func entrepreneurAction(_ sender: Any) {
       setSelected(btn: entrepreneurBtn, lab: enterpreneurLab)
       setUnSelected(btn: investorBtn, lab: investorBtnLab)
       setUnSelected(btn: commonBtn, lab: commonLab)
    }
    @IBAction func commonAction(_ sender: Any) {
       setSelected(btn: commonBtn, lab: commonLab)
       setUnSelected(btn: investorBtn, lab: investorBtnLab)
       setUnSelected(btn: entrepreneurBtn, lab: enterpreneurLab)
    }
    //设置边框
    func  setBorder(btn : UIButton){
        btn.layer.borderWidth = 1
        btn.layer.borderColor = #colorLiteral(red: 0.6047888398, green: 0.6928739548, blue: 0.7543881536, alpha: 1)
    }
    //设置选中状态
    func setSelected(btn : UIButton,lab : UILabel){
        btn.backgroundColor = #colorLiteral(red: 0.6047888398, green: 0.6928739548, blue: 0.7543881536, alpha: 1)
        lab.textColor = UIColor.white
    }
    //设置未选中状态
    func setUnSelected(btn : UIButton,lab : UILabel){
        btn.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        lab.textColor = #colorLiteral(red: 0.6047888398, green: 0.6928739548, blue: 0.7543881536, alpha: 1)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
