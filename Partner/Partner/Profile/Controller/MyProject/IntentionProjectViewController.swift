//
//  IntentionProjectViewController.swift
//  Partner
//
//  Created by Weslie on 26/01/2018.
//

import UIKit

class IntentionProjectViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IntentionProjectTableViewCell") as! IntentionProjectTableViewCell
        return cell
    }
}
