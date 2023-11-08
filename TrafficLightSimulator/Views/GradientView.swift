//
//  GradientView.swift
//  TrafficLightSimulator
//
//  Created by Zhivka on 7.11.23.
//

import Foundation
import UIKit

open class GradientView: UIView {
    public var colors: [UIColor] = [.black, .white] {
        didSet {
            updateColors()
        }
    }
    
    public var locations: [Double] = [0, 0.5] {
        didSet {
            updateLocations()
        }
    }
    
    
    override public class var layerClass: AnyClass { return CAGradientLayer.self }
    
    var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }
    
    func updatePoints() {
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
            gradientLayer.endPoint  = CGPoint(x: 0, y: 1)
    }
    
    func updateLocations() {
        gradientLayer.locations = locations.map({ $0 as NSNumber })
    }
    
    func updateColors() {
        gradientLayer.colors = colors.map({ $0.cgColor })
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        updatePoints()
        updateLocations()
        updateColors()
    }
}

