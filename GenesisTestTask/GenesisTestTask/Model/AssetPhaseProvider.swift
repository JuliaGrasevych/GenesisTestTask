//
//  AssetPhaseProvider.swift
//  GenesisTestTask
//
//  Created by Julia on 9/14/18.
//  Copyright © 2018 Julia. All rights reserved.
//

import Foundation
import UIKit

class AssetPhaseProvider: PhaseProvider {
    private let fileName: String
    private let data: Data?
    
    // MARK: - Initializers
    init(fileName: String) {
        self.fileName = fileName
        // load json file from Assets catalog
        let dataAsset = NSDataAsset(name: fileName)
        self.data = dataAsset?.data
    }
    // MARK: - Public methods
    func phases() -> [Phase]? {
        guard let data = data else {
            return nil
        }
        let phases: [Phase]? = {
            do {
                return try [Phase].decode(data: data)
            } catch let exception {
                print(exception)
                return nil
            }
        }()
        return phases
    }
    
    
}
