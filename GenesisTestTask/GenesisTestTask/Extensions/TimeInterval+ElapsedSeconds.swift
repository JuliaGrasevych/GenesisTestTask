//
//  TimeInterval+ElapsedSeconds.swift
//  GenesisTestTask
//
//  Created by Julia on 9/15/18.
//  Copyright © 2018 Julia. All rights reserved.
//

import Foundation

extension TimeInterval {
    static let elapsedTimeFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    func elapsedFormat() -> String? {
        return TimeInterval.elapsedTimeFormatter.string(from: self)
    }
}
