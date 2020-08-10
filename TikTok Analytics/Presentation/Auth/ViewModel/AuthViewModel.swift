//
//  AuthViewModel.swift
//  TikTok Analytics
//
//  Created by Aleksander Loghozinsky on 06.08.2020.
//

import Foundation
import CoreGraphics
import RxSwift
import RxCocoa

class AuthViewModel {
    
    private let buttonTitleAssets = (default: "Show Analytics", empty: "")
    private var inputText: String?
    
    private var isLoading: BehaviorRelay<Bool>
    private var buttonTitle: BehaviorRelay<String>
    private var onSuccess: BehaviorRelay<(isSuccess: Bool, viewModel: UserViewModel?)>
    private var onError: BehaviorRelay<String?>
    
    private var input: Driver<String?>
    lazy var output = (isLoading: isLoading, buttonTitle: buttonTitle, onSuccess: onSuccess, onError: onError)
    
    private let disposeBag = DisposeBag()
    
    init(input: Observable<String?>) {
        self.input = input.asDriver(onErrorJustReturn: "")
        
        self.isLoading = BehaviorRelay(value: false)
        self.buttonTitle = BehaviorRelay(value: buttonTitleAssets.default)
        self.onSuccess = BehaviorRelay(value: (isSuccess: false, viewModel: nil))
        self.onError = BehaviorRelay(value: nil)
        
        process()
    }
    
    func fetch() {
        isLoading.accept(true)
        buttonTitle.accept(buttonTitleAssets.empty)
        guard let inputText = inputText, inputText.count > 0 else {
            handleError(withMessage: "Please, fill the username field")
            
            return
        }
        
        APIService.shared.getUser(username: inputText) { (response, error) in
            DispatchQueue.main.async {
                if let response = response {
                    if response.success, let data = response.data {
                        self.isLoading.accept(false)
                        self.buttonTitle.accept(self.buttonTitleAssets.default)
                        
                        let viewModel = UserViewModel(userData: data)
                        self.onSuccess.accept((response.success, viewModel: viewModel))
                    } else {
                        self.handleError(withMessage: "Incorrect Username")
                    }
                } else if let error = error {
                    self.handleError(withMessage: error.localizedDescription)
                }
            }
        }
    }
    
    func contentProportionalSize(screenWidth width: CGFloat) -> CGSize {
        let proportionalWidth = width >= 1024 ? width * 0.3 : width * 0.4
        let proportionalHeight = proportionalWidth * 1.23
        return CGSize(width: proportionalWidth, height: proportionalHeight)
    }
    
    private func process() {
        input
            .drive(onNext: { value in
                self.inputText = value
            })
            .disposed(by: disposeBag)
    }
    
    private func handleError(withMessage message: String) {
        isLoading.accept(false)
        buttonTitle.accept(self.buttonTitleAssets.default)
        onSuccess.accept((isSuccess: false, viewModel: nil))
        onError.accept(message == "The data couldn’t be read because it is missing." ? "please, try another username, something were incorrect" : message)
    }
    
}
