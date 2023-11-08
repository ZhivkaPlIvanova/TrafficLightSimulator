//
//  UIColor+Utilities.swift
//  TrafficLightSimulator
//
//  Created by Zhivka on 7.11.23.
//

import Foundation
import UIKit

extension UIColor {
    
    func lighter(_ coefficient: CGFloat = 0.1) -> UIColor {
        return makeColor(componentDelta: coefficient)
    }
    
    func darker(_ coefficient: CGFloat = 0.1) -> UIColor {
        return makeColor(componentDelta: -1*coefficient)
    }
    
    private func makeColor(componentDelta: CGFloat) -> UIColor {
        var red: CGFloat = 0
        var blue: CGFloat = 0
        var green: CGFloat = 0
        var alpha: CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return UIColor(red: add(componentDelta, toComponent: red), green: add(componentDelta, toComponent: green), blue: add(componentDelta, toComponent: blue), alpha: alpha)
    }
    
    private func add(_ value: CGFloat, toComponent: CGFloat) -> CGFloat {
        return max(0, min(1, toComponent + value))
    }
}

//MARK: - Custom colors

extension UIColor {
    class var darkGreen: UIColor {
        return UIColor(red: 1/255, green: 100/255, blue: 30/255, alpha: 1)
    }
}
