//
//  TrafficLightInteractor.swift
//  TrafficLightSimulator
//
//  Created by Zhivka on 7.11.23.
//

import Foundation

protocol TrafficLightInteracting {
    var trafficLights: [Light] { get }
   
    func startTrafficLight()
    
    func observe(action: @escaping () -> Void) -> NSObject
    func removeObserver(_ observer: NSObject)
}

class TrafficLightInteractor: TrafficLightInteracting {
    let trafficLight: TrafficLightManager
    
    init(with trafficLight: TrafficLightManager) {
        self.trafficLight = trafficLight
    }
    
    var trafficLights: [Light] {
        return trafficLight.trafficLights
    }
    
    func startTrafficLight() {
        trafficLight.start()
    }
    
    func observe(action: @escaping () -> Void) -> NSObject {
        trafficLight.observe(action: action)
    }
    
    func removeObserver(_ observer: NSObject) {
        trafficLight.removeObserver(observer)
    }
    
}
