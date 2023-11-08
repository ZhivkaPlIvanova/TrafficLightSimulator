//
//  CarInputRouter.swift
//  TrafficLightSimulator
//
//  Created by Zhivka on 7.11.23.
//

import Foundation
import UIKit

protocol CarInputRouting {
    func openTrafficLightScreen(text: String)
}

class CarInputRouter: CarInputRouting {
    var viewController: UIViewController?

    func openTrafficLightScreen(text: String) {
        let trafficLightView = ModuleBuilder.shared.buildTrafficLightModule(with: text)
        viewController?.navigationController?.pushViewController(trafficLightView, animated: true)
    }
}
