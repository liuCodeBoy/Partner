//
//  KeyboardBackgroundCoverView.swift
//  Partner
//
//  Created by Weslie on 31/01/2018.
//

import UIKit

class KeyboardBackgroundCoverView: UIView {

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        super.hitTest(point, with: event)
        return self
    }

}
