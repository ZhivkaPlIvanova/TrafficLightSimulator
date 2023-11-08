//
//  ModuleBuilder.swift
//  TrafficLightSimulator
//
//  Created by Zhivka on 7.11.23.
//

import Foundation
import UIKit

class ModuleBuilder {
    
    static let shared = ModuleBuilder()
    
    func buildcarInputModule() -> UIViewController {
        return CarInputViewController.build()
    }
    
    func buildTrafficLightModule(with text: String) -> UIViewController {
        let trafficLight = TrafficLightManager(with: .red)
        return TrafficLightViewController.build(with: .init(carModel: text), trafficLight: trafficLight)
    }
}
