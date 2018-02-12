//
//  CircleChooseTableView.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/2/6.
//

import UIKit

class CircleChooseTableView: UITableView,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCell(withIdentifier: "CircleChooseTableViewCellID", for: indexPath) as! CircleChooseTableViewCell
        return cell
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate   = self
        self.dataSource = self
    }
}



class   CircleChooseTableViewCell : UITableViewCell{
    @IBOutlet weak var circleName: UILabel!
    @IBOutlet weak var chooseBtn: UIButton!
    
    
}
