//
//  MomentMainVC.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/1/31.
//

import UIKit
import SDWebImage

class MomentMainVC: UIViewController , UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var momentTableView: UITableView!
    var  modelView : [StatusViewModel]?

    
    override func viewDidLoad() {
        super.viewDidLoad()
          loadStatuses()
    
        
        momentTableView.rowHeight = UITableViewAutomaticDimension
        momentTableView.estimatedRowHeight = 200
        
        momentTableView.separatorStyle = .none
    }
}





extension MomentMainVC {
    fileprivate func loadStatuses() {
//        NetworkTools.shareInstance.loadStatuses { (result, error) in
//            if error != nil {
//                print(error ?? "homeViewController loadStatuses error")
//                return
//            }
//
//            guard let resultArray = result else {
//                return
//            }
//
//            for resultItems in resultArray {
//                let status = Status(dict: resultItems)
//                let viewModel = StatusViewModel(status: status)
//                self.modelView.append(viewModel)
//            }
//
//            self.cacheImages(self.modelView)
//
//        }
    }
    
    fileprivate func cacheImages(_ viewModels: [StatusViewModel]) {
        let group = DispatchGroup()
        
        for viewModel in viewModels {
            for picURL in viewModel.picURLs! {
                group.enter()
                SDWebImageManager.shared().imageDownloader?.downloadImage(with: picURL, options: [], progress: nil, completed: { (_, _, _, _) in
                group.leave()
                })
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            self.momentTableView.reloadData()
        }
        
    }
}

extension MomentMainVC {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return modelView.count
//    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "StatusViewCell") as!  StatusViewCell

       // cell.viewModel = modelView[indexPath.row]

        return cell
    }
//
}

