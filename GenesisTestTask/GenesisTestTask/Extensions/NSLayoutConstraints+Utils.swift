//
//  NSLayoutConstraints+Utils.swift
//  GenesisTestTask
//
//  Created by Julia on 9/14/18.
//  Copyright © 2018 Julia. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    class func scaleToFillParent(childView: UIView) {
        guard let parentView = childView.superview else {
            print("View \(String(describing: type(of: childView))) doesn't have superview")
            return
        }
        childView.translatesAutoresizingMaskIntoConstraints = false
        childView.topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
        childView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor).isActive = true
        childView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor).isActive = true
        childView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor).isActive = true
    }
}
