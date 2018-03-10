//
//  ServiceFindProjectViewController.swift
//  Partner
//
//  Created by Weslie on 23/02/2018.
//

import UIKit

class ServiceFindProjectViewController: UIViewController {
    
    @IBAction func popBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var hotBtn: ShadowButton!
    @IBOutlet weak var newBtn: ShadowButton!
    @IBAction func hotClicked(_ sender: ShadowButton) {
        hotBtn.setSelected()
        newBtn.reverseSelected()
        // TODO:- reload data
        
    }
    @IBAction func newClicked(_ sender: ShadowButton) {
        hotBtn.reverseSelected()
        newBtn.setSelected()
        // TODO:- reload data
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

extension ServiceFindProjectViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceProjectBriefTableViewCell") as! ServiceProjectBriefTableViewCell
        return cell
    }
}
