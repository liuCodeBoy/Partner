
//
//  AspectImageViewController.swift
//  Partner
//
//  Created by Weslie on 02/02/2018.
//

import UIKit

class AspectImageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var imageHCons: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }

        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = "\(indexPath.row)"
        tableView.dequeueReusableCell(withIdentifier: "cell")
        return cell
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let point = scrollView.contentOffset
        
        print(point)
        
        if point.y < 0 {
//            var rect = image.frame
            
            imageHCons.constant = -point.y + 200
//            image.frame = rect
        } else {
            imageHCons.constant = 200
        }
       
    }
    

}
