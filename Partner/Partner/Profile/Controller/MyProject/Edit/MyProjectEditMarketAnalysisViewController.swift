//
//  MyProjectEditMarketAnalysisViewController.swift
//  Partner
//
//  Created by Weslie on 29/01/2018.
//

import UIKit

class MyProjectEditMarketAnalysisViewController: UIViewController, UITextViewDelegate, UIScrollViewDelegate {

    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        textView.resignFirstResponder()
    }
    
    

}
