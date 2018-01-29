//
//  MyProjectViewController.swift
//  Partner
//
//  Created by Weslie on 26/01/2018.
//

import UIKit

class MyProjectViewController: UIViewController {
    
    var isInvestor: Bool = true
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func popBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var createProjBtn: UIButton!
    @IBAction func createProjBtnClicked(_ sender: UIButton) {
    }
    
    @IBOutlet weak var intentionBtn: UIButton!
    @IBAction func intentionBtnClicked(_ sender: UIButton) {
    }
    
    @IBOutlet weak var investorsSelectViewHCons: NSLayoutConstraint!
    
    
    @IBOutlet weak var investorCreateProjBtn: ShadowButton!
    @IBAction func investorCreateProjBtnClicked(_ sender: ShadowButton) {
        investorCreateProjBtn.setSelected()
        investorInvestProjBtn.reverseSelected()
        
    }
    @IBOutlet weak var investorInvestProjBtn: ShadowButton!
    @IBAction func investorInvestProjBtnClicked(_ sender: ShadowButton) {
        investorCreateProjBtn.reverseSelected()
        investorInvestProjBtn.setSelected()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        if isInvestor == true {
            createProjBtn.isHidden = true
            intentionBtn.isHidden  = false
            investorsSelectViewHCons.constant = 70
        } else {
            createProjBtn.isHidden = false
            intentionBtn.isHidden  = true
            investorsSelectViewHCons.constant = 0
        }
    }

}

extension MyProjectViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SingleProjectTableViewCell") as! SingleProjectTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 248
    }
}
