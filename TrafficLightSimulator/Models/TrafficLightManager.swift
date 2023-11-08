//
//  TrafficLight.swift
//  TrafficLightSimulator
//
//  Created by Zhivka on 7.11.23.
//

import Foundation
import UIKit

private enum Constants {
    static let PrimaryColorDuration: TimeInterval = 4
    static let SecondaryColorDuration: TimeInterval = 1
}

class TrafficLightManager {
    
    let trafficLights: [Light]
    let initialLightType: LightType

    private var observers = [NSObject: () -> Void]()

    init(with initialLightIndicator: LightType = .red, primaryColorDuration: TimeInterval = Constants.PrimaryColorDuration, secondaryColorDuration: TimeInterval = Constants.SecondaryColorDuration, red: UIColor = .red, green: UIColor = .green, orange: UIColor = .yellow) {
        
        self.initialLightType = initialLightIndicator
        
        trafficLights = [Light(type: .red, primaryColor: red, duration: primaryColorDuration), Light(type: .orange, primaryColor: orange, duration: secondaryColorDuration), Light(type: .green, primaryColor: green, duration: primaryColorDuration)]
    }

    func start() {
        start(with: initialLightType)
    }
    
    func observe(action: @escaping () -> Void) -> NSObject {
        let observer = NSObject()
        observers.updateValue(action, forKey: observer)
        return observer
    }
    
    func removeObserver(_ observer: NSObject) {
        observers.removeValue(forKey: observer)
    }
    
    //MARK: - Private
    
    private func start(with lightType: LightType) {
        guard let currentLight = trafficLights.first(where: { $0.type == lightType }) else { return }
        currentLight.state = .on
        notifyObservers()
     
        _ = Timer.scheduledTimer(withTimeInterval: currentLight.duration, repeats: false) {[weak self] timer in
            timer.invalidate()
            currentLight.state = .off
            self?.start(with: lightType.next())
        }
    }
    
    private func notifyObservers() {
        observers.values.forEach { $0() }
    }
}

