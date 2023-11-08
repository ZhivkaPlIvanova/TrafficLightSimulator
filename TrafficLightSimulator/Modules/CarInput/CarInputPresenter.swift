//
//  CarInputPresenter.swift
//  TrafficLightSimulator
//
//  Created by Zhivka on 7.11.23.
//

import Foundation
import UIKit

private enum Constants {
    static let MinimumCharacterLength: Int = 3
    static let HintText = "Entered text should be at least \(MinimumCharacterLength) characters"
    static let PlaceholderText = "Enter car model"
    static let ActionButtonTitle = "START DRIVING"
}

protocol CarInputPresenting {
    func viewDidLoad()
    func validate(text: String)
    func actionButtonTapped(text: String)
}

class CarInputPresenter: CarInputPresenting {
    weak var view: CarInputViewControlling?
    private var router: CarInputRouting
    
    init(router: CarInputRouting) {
        self.router = router
    }
    
    func viewDidLoad() {
        buildViewData()
    }
    
    func validate(text: String) {
        let valid = text.trimmingCharacters(in: .whitespacesAndNewlines).count >= Constants.MinimumCharacterLength
        buildViewData(validTextInput: valid)
    }
    
    func actionButtonTapped(text: String) {
        router.openTrafficLightScreen(text: text)
    }
    
    //MARK: - Private

    private func buildViewData(validTextInput: Bool = false) {
        let data = CarInputViewController.Data(textFieldPlaceholder: Constants.PlaceholderText, hintText: Constants.HintText, hintColor: validTextInput ? .darkGreen : .gray, buttonData: .init(buttonTitle: Constants.ActionButtonTitle, buttonEnabled: validTextInput))
        view?.data = data
    }

}
