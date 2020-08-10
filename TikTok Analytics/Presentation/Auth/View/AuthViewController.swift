//
//  AuthViewController.swift
//  TikTok Analytics
//
//  Created by Aleksander Logozinsky on 05.08.2020.
//

import UIKit
import RxSwift
import RxKeyboard

class AuthViewController: ViewController {
    
    let scrollView = UIScrollView()
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "logo"))
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    lazy var loginTextFieldConstraintY = loginTextField.centerYAnchor.constraint(equalTo: view.topAnchor)
    let loginTextField = UsernameField(withPlaceholder: "TikTok Username")
    let nextButton = GradientButton(withText: "Show Analytics")
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = .white
        
        return activityIndicatorView
    }()
    
    private var viewModel: AuthViewModel!
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        
        bindViewModel()
        bindView()
        setupLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.addTarget(self, action: #selector(onNextButtonTapped), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        animateAppearing()
        configureAuthScreen()
    }
    
}

extension AuthViewController: AuthScreenDelegate {
    func configureAuthScreen() {
        navigationController?.isNavigationBarHidden = true
    }
    
    private func setupLayout() {
        view.backgroundColor = .theme
        
        view.addSubview(scrollView)
        scrollView.addSubviews(logoImageView, loginTextField, nextButton, activityIndicatorView)
        
        let contentSize = viewModel.contentProportionalSize(screenWidth: view.frame.width)
        
        scrollView.fillSuperview()
        
        logoImageView.anchor(bottom: loginTextField.topAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: UIScreen.main.bounds.height < 667 ? 15 : 55, right: 0), size: CGSize(width: contentSize.width, height: contentSize.height))
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        loginTextField.anchor(centerX: view.centerXAnchor, size: CGSize(width: contentSize.width, height: 36))
        loginTextFieldConstraintY.isActive = true
        loginTextFieldConstraintY.constant = view.center.y + 24
        
        nextButton.anchor(top: loginTextField.bottomAnchor, padding: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0), size: CGSize(width: contentSize.width, height: 36))
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        activityIndicatorView.anchor(centerY: nextButton.centerYAnchor, centerX: nextButton.centerXAnchor, size: CGSize(width: 36, height: 36))
        
        view.layoutIfNeeded()
    }
    
    private func animateAppearing() {
        self.loginTextField.layer.opacity = 1
        self.nextButton.layer.opacity = 1
    }
    
    private func bindViewModel() {
        viewModel = AuthViewModel(input: loginTextField.rx.text.asObservable())
        
        viewModel.output
            .isLoading
            .subscribe { [weak self] event in
                guard let `self` = self else { return }
                guard let isLoading = event.element else { return }
                self.setActivityIndicatorLoading(isLoading)
            }
            .disposed(by: disposeBag)

        viewModel.output
            .buttonTitle
            .subscribe { [weak self] event in
                guard let `self` = self else { return }
                guard let title = event.element else { return }
                self.setButtonTitle(title)
            }
            .disposed(by: disposeBag)
        
        viewModel.output
            .onSuccess
            .subscribe {
                [weak self] event in
                guard let `self` = self else { return }
                guard let viewModel = event.element?.viewModel else { return }
                
                self.onSuccess(viewModel)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindView() {
        RxKeyboard
            .instance
            .visibleHeight
            .drive(onNext: { [weak self] value in
                guard let `self` = self else { return }
                if value > 100 {
                    self.loginTextFieldConstraintY.constant = self.view.frame.height - value - 89
                } else {
                    self.loginTextFieldConstraintY.constant = self.view.center.y + 24
                }
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                    self.view.layoutIfNeeded()
                })
            })
            .disposed(by: disposeBag)
    }
    
    private func setButtonTitle(_ value: String) {
        nextButton.setAttributedTitle(value)
    }
    
    private func setActivityIndicatorLoading(_ value: Bool) {
        if value {
            activityIndicatorView.startAnimating()
        } else {
            activityIndicatorView.stopAnimating()
        }
        
        nextButton.isEnabled = !value
    }
    
    private func onSuccess(_ value: UserViewModel) {
        let vc = UserViewController(viewModel: value)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func onNextButtonTapped(_ sender: UIButton!) {
        viewModel.fetch()
    }
    
}
