//
//  TrafficLightViewController.swift
//  TrafficLightSimulator
//
//  Created by Zhivka on 7.11.23.
//

import Foundation
import UIKit
import EasyPeasy

private enum Constants {
    static let LightSize: CGFloat = 100
    static let LabelSideSpacing: CGFloat = 20
    static let LabelBottomSpacing: CGFloat = 60
}

protocol TrafficLightViewControlling: UIViewController {
    var data: TrafficLightViewController.Data? { get set }
}

class TrafficLightViewController: UIViewController, TrafficLightViewControlling {
    struct Data {
        let carModel: String
        let trafficLightColors: [[UIColor]]
    }
    
    var data: Data? {
        didSet {
            update(with: data)
        }
    }
    
    private let carModelLabel = UILabel()
    private let trafficLightView = UIStackView()
    
    private var presenter: TrafficLightPresenting
    
    init(presenter: TrafficLightPresenting) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Driving"

        view.backgroundColor = .systemBackground
        
        carModelLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        carModelLabel.textAlignment = .center
        view.addSubview(carModelLabel)
        
        trafficLightView.axis = .vertical
        trafficLightView.alignment = .center
        trafficLightView.distribution = .fillEqually
        trafficLightView.spacing = 10
        
        view.addSubview(trafficLightView)
        for _ in 0..<3 {
            let gradientView = GradientView()
            configureView(gradientView)
        }
        
        trafficLightView.easy.layout([
            Center()
        ])
        
        carModelLabel.easy.layout([
            Leading(Constants.LabelSideSpacing),
            Trailing(Constants.LabelSideSpacing),
            Bottom(Constants.LabelBottomSpacing).to(trafficLightView, .top)
        ])
        
        presenter.viewDidLoad()
    }
    
    //MARK: - Private
    
    private func configureView(_ view: GradientView) {
        trafficLightView.addArrangedSubview(view)
        
        view.easy.layout([
            Size(CGSize(width: Constants.LightSize, height: Constants.LightSize))
        ])
        
        view.layer.cornerRadius = Constants.LightSize/2
        view.gradientLayer.type = CAGradientLayerType.radial
        
    }
    
    private func update(with data: Data?) {
        guard let data = data else { return }
        
        carModelLabel.text = data.carModel
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
            var i = 0
            self.trafficLightView.arrangedSubviews.forEach { arrangedSubview in
                guard let view = arrangedSubview as? GradientView, i <= data.trafficLightColors.count else { return }
                view.colors = data.trafficLightColors[i]
                i+=1
            }
        }
    }
}

extension TrafficLightViewController {
    static func build(with activation: TrafficLightActivation, trafficLight: TrafficLightManager) -> UIViewController {
        let interactor = TrafficLightInteractor(with: trafficLight)
        let presenter = TrafficLightPresenter(activation: activation, interactor: interactor)
        let view = TrafficLightViewController(presenter: presenter)
        
        presenter.view = view
        return view
    }
}
