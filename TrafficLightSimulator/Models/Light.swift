//
//  Light.swift
//  TrafficLightSimulator
//
//  Created by Zhivka on 7.11.23.
//

import Foundation
import UIKit

enum LightType: CaseIterable {
    case green
    case orange
    case red
}

enum LightState {
    case on
    case off
}

class Light {
    let type: LightType
    let primaryColor: UIColor
    let duration: TimeInterval
    
    var state: LightState = .off
    
    init(type: LightType, primaryColor: UIColor, duration: TimeInterval) {
        self.type = type
        self.primaryColor = primaryColor
        self.duration = duration
    }
}
