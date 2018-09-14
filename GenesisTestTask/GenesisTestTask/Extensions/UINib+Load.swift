//
//  UINib+Load.swift
//  GenesisTestTask
//
//  Created by Julia on 9/14/18.
//  Copyright © 2018 Julia. All rights reserved.
//

import UIKit

extension UINib {
    class func load<T>(class theClass: AnyClass, viewType: T.Type, bundle: Bundle? = Bundle.main, owner: Any? = nil) -> T? {
        let identifier = String(describing: theClass)
        let nib = UINib(nibName: identifier, bundle: bundle)
        let objects = nib.instantiate(withOwner: owner, options: nil)
        
        for case let object as T in objects {
            return object
        }
        return nil
    }
}
