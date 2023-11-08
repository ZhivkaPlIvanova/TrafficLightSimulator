//
//  UIButton+Utilities.swift
//  TrafficLightSimulator
//
//  Created by Zhivka on 7.11.23.
//

import Foundation
import UIKit

extension UIButton {
    func setBackgroundColor(_ backgroundColor: UIColor, for state: UIControl.State) {
        self.setBackgroundImage(.pixel(ofColor: backgroundColor), for: state)
    }
}
