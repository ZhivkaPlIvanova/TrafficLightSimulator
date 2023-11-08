//
//  CarInputViewController.swift
//  TrafficLightSimulator
//
//  Created by Zhivka on 7.11.23.
//

import Foundation
import UIKit
import EasyPeasy

private enum Constants {
    static let TextFieldOffset: CGFloat = 60
    static let BottomOffset: CGFloat = 80
    static let ActionButtonHeight: CGFloat = 48
    static let Paddings: CGFloat = 20
}

protocol CarInputViewControlling: UIViewController {
    var data: CarInputViewController.Data? { get set }
}

class CarInputViewController: UIViewController, CarInputViewControlling {
    
    struct ButtonData {
        let buttonTitle: String
        let buttonEnabled: Bool
    }

    struct Data {
        let textFieldPlaceholder: String
        let hintText: String?
        let hintColor: UIColor
        let buttonData: ButtonData
    }
    
    private let textFieldView = UITextField()
    private let hintLabel = UILabel()
    private let actionButton = UIButton(type: .system)
    
    private var presenter: CarInputPresenting
   
    var data: Data? {
        didSet {
            update(with: data)
        }
    }

    init(presenter: CarInputPresenting) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
      
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapBackgroundView))
        view.addGestureRecognizer(tapGesture)
        
        addKeyboardListeners()
       
        title = "My car"
        
        view.addSubview(textFieldView)
        textFieldView.delegate = self
        textFieldView.borderStyle = .none
        textFieldView.font = .systemFont(ofSize: 17, weight: .medium)
        
        view.addSubview(hintLabel)
        hintLabel.font = .systemFont(ofSize: 12, weight: .light)
        hintLabel.textColor = .darkGray
        
        actionButton.setBackgroundColor(.systemBlue, for: .normal)
        
        view.addSubview(actionButton)
        actionButton.tintColor = .white
        actionButton.layer.cornerRadius = 8
        actionButton.layer.masksToBounds = true
        actionButton.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
        addConstraints()
        presenter.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textFieldView.addBottomBorder()
    }
    
    //MARK: - Private
    
    private func update(with data: Data?) {
        guard let data = data else { return }
        
        textFieldView.placeholder = data.textFieldPlaceholder
       
        hintLabel.text = data.hintText
        hintLabel.textColor = data.hintColor
        actionButton.isEnabled = data.buttonData.buttonEnabled
        actionButton.setTitle(data.buttonData.buttonTitle, for: .normal)

    }
    
    private func addConstraints() {
        textFieldView.easy.layout([
            Leading(Constants.Paddings),
            Trailing(Constants.Paddings)
        ])
        
        hintLabel.easy.layout([
            Top(Constants.Paddings/2).to(textFieldView),
            Leading().to(textFieldView, .leading),
            Trailing().to(textFieldView, .trailing),
            Bottom(Constants.TextFieldOffset).to(actionButton, .top)
        ])
        
        actionButton.easy.layout([
            Leading(Constants.Paddings),
            Trailing(Constants.Paddings),
            Height(Constants.ActionButtonHeight),
            Bottom(Constants.BottomOffset).to(self.view.safeAreaLayoutGuide, .bottom)
        ])
    }
    
    //MARK: - Keyboard
    
    private func addKeyboardListeners() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
   
    private func moveViewWithKeyboard(notification: NSNotification, willHide: Bool = false) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, let keyboardCurve = UIView.AnimationCurve(rawValue: notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as? Int ?? 0),  let keyboardDuration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        let keyboardHeight = keyboardSize.height
        
        let bottomConsraint = Constants.BottomOffset + (willHide ? 0 : keyboardHeight)
        self.actionButton.easy.layout(Bottom(bottomConsraint).to(self.view.safeAreaLayoutGuide, .bottom))
        
        let animator = UIViewPropertyAnimator(duration: keyboardDuration, curve: keyboardCurve) { [weak self] in
            self?.view.layoutIfNeeded()
        }
        
        animator.startAnimation()
    }
    
    //MARK: - Actions
    @objc func didTapBackgroundView() {
        view.endEditing(true)
    }
    
    @objc func didTapActionButton() {
        textFieldView.resignFirstResponder()
        
        guard let text = textFieldView.text else { return }
        presenter.actionButtonTapped(text: text)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        guard textFieldView.isEditing else { return }
        moveViewWithKeyboard(notification: notification)
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        moveViewWithKeyboard(notification: notification, willHide: true)
    }
}

extension CarInputViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text as NSString? else {
            return false
        }
        
        let newText = text.replacingCharacters(in: range, with: string)
        presenter.validate(text: newText)
        return true
    }
}

extension CarInputViewController {
    static func build() -> UIViewController {
        let router = CarInputRouter()
        let presenter = CarInputPresenter(router: router)
        let view = CarInputViewController(presenter: presenter)
        
        presenter.view = view
        router.viewController = view
        
        return view
    }
}

