//
//  MyCustomSegue.swift
//  Partner
//
//  Created by Weslie on 19/01/2018.
//

import UIKit

class MyCustomSegue: UIStoryboardSegue {

    override func perform() {
        let sourceView = self.source.view as UIView
        let destView = self.destination.view as UIView
        
        let window = UIApplication.shared.delegate?.window!
        
        destView.center = CGPoint(x: sourceView.center.x, y: sourceView.center.y)
        
        window?.insertSubview(destView, aboveSubview: sourceView)
        
        UIView.animate(withDuration: 0.4, animations: {
            destView.center = CGPoint(x: sourceView.center.x, y: sourceView.center.y)
            sourceView.center = CGPoint(x: sourceView.center.x, y: 2 * sourceView.center.y)
        }) { (_) in
            self.source.navigationController?.pushViewController(self.destination, animated: true)
        }
    }
}
