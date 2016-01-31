//
//  QuoteTextView.swift
//  QuotesToGo
//
//  Created by matsuosh on 1/31/16.
//  Copyright © 2016 Daniel Autenrieth. All rights reserved.
//

import UIKit

class QuoteTextView: UITextView {

    var heightConstraint: NSLayoutConstraint?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsUpdateConstraints()
    }

    override func updateConstraints() {
        let size = sizeThatFits(CGSize(width: bounds.width, height: CGFloat(FLT_MAX)))
        if heightConstraint == nil {
            heightConstraint = NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: size.height)
            addConstraint(heightConstraint!)
        }
        heightConstraint!.constant = size.height
        super.updateConstraints()
    }
}
