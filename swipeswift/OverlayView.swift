//
//  OverlayView.swift
//  swipeswift
//
//  Created by Daniel Warner on 12/28/15.
//  Copyright © 2015 Daniel Warner. All rights reserved.
//

import Foundation
import UIKit

class OverlayView: UIView {
    
    enum CGOverlayViewMode: Int {
        case GGOverlayViewModeLeft, GGOverlayViewModeRight
    }

    private var _mode: CGOverlayViewMode!
    
    var mode: CGOverlayViewMode {
        get {
            return _mode
        }
        
        set {
            _mode = newValue
        }
    }
    
    
    
    override init(frame: CGRect) {
        _mode = CGOverlayViewMode.GGOverlayViewModeLeft
        super.init(frame: frame)
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}