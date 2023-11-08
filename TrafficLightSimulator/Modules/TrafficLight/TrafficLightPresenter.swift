//
//  TrafficLightPresenter.swift
//  TrafficLightSimulator
//
//  Created by Zhivka on 7.11.23.
//

import Foundation
import UIKit

protocol TrafficLightPresenting {
    func viewDidLoad()
}

class TrafficLightPresenter: TrafficLightPresenting {
    weak var view: TrafficLightViewControlling?
    private var activation: TrafficLightActivation
    private var interactor: TrafficLightInteracting
    
    private var observer: NSObject?
    
    init(activation: TrafficLightActivation, interactor: TrafficLightInteracting) {
        self.activation = activation
        self.interactor = interactor
    }
    
    deinit {
        guard let lightsObserver = observer else { return }
        interactor.removeObserver(lightsObserver)
        observer = nil
    }
    
    func viewDidLoad() {
        buildViewData()
        observer = interactor.observe { [weak self] in
            self?.buildViewData()
        }
        
        interactor.startTrafficLight()
    }
    
    //MARK: - Private
    private func buildViewData() {
        var colors = [[UIColor]]()
        
        interactor.trafficLights.forEach { light in
            let currentLightColors = buildColors(for: light.primaryColor, on: light.state == .on)
            colors.append(currentLightColors)
        }
        
        view?.data = .init(carModel: activation.carModel, trafficLightColors: colors)
    }
    
    private func buildColors(for color: UIColor, on: Bool)  -> [UIColor] {
        guard on else {
            return [color.darker(0.5), color.darker(0.3), color.darker(0.15)]
        }
        
        return [color.lighter(0.6), color.lighter(0.4), color.lighter()]
    }
}

