//
//  Phase.swift
//  GenesisTestTask
//
//  Created by Julia on 9/14/18.
//  Copyright © 2018 Julia. All rights reserved.
//

import UIKit

enum PhaseType: String, CustomStringConvertible, Decodable {
    case inhale, exhale, hold
    
    var description: String {
        return self.rawValue.uppercased()
    }
}

extension PhaseType {
    var scaleFactor: CGFloat? {
        switch self {
        case .inhale: return 1
        case .exhale: return 0.5
        case .hold:   return nil
        }
    }
}

struct Phase: Decodable {
    enum CodingKeys: String, CodingKey {
        case type
        case duration
        case color
    }
    
    var type: PhaseType
    var duration: TimeInterval
    var color: UIColor
    
    // MARK: - Initializers
    init(from decoder: Decoder) throws {
        // Using custom decoding to convert hex string to UIColor
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type: PhaseType = try container.decode(PhaseType.self, forKey: .type)
        let duration: TimeInterval = try container.decode(TimeInterval.self, forKey: .duration)
        let stringColor: String = try container.decode(String.self, forKey: .color)
        guard let color = UIColor(hexString: stringColor) else {
            throw DecodingError.dataCorruptedError(forKey: CodingKeys.color, in: container, debugDescription: "Cannot initialize UIColor from given string value")
        }
        self.init(type: type, duration: duration, color: color)
    }
    // MARK: - Private initializer
    private init(type: PhaseType, duration: TimeInterval, color: UIColor) {
        self.type = type
        self.duration = duration
        self.color = color
    }
}

extension Phase {
    func displayTitle(at time: TimeInterval) -> String {
        var displayTitle = type.description
        if let formattedTime = time.elapsedFormat() {
            displayTitle += "\n\(formattedTime)"
        }
        return displayTitle
    }
}
