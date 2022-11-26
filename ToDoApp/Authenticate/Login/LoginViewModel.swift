//  
//  LoginViewModel.swift
//  ToDoApp
//
//  Created by Bundid on 26/11/2565 BE.
//

import Foundation
import RxSwift
import Moya

// MARK: View -> ViewModel
protocol LoginViewModelInput {
    func viewDidLoad()
    func loginCall(_ loginBody: LoginModel)
}

// MARK: ViewModel -> View
protocol LoginViewModelOutput {
    var onSuccess: ((LoginResponse) -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }
}

protocol LoginViewModelProtocol: LoginViewModelInput, LoginViewModelOutput { }

class LoginViewModel: LoginViewModelProtocol, LoginViewModelOutput {
    
    var dataModel = LoginModel()
    private let disposeBag = DisposeBag()
    var onSuccess: ((LoginResponse) -> Void)?
    var onError: ((String) -> Void)?
    
    func loginCall(_ loginObject: LoginModel) {
        let authenContext = ConnectivityContext()
        authenContext.login(loginObject: loginObject)
            .subscribe { [weak self] event in
                switch event {
                case .next:
                    self?.onSuccess?(event.element!)
                    
                case .error(let error):
                    if let json = try? JSONSerialization.jsonObject(with: (error as! MoyaError).response!.data, options: .mutableContainers),
                       let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                        print(jsonData)
                        self?.onError?("Have error occurred")
                    } else {
                        let response = String(data: (error as! MoyaError).response!.data, encoding: .utf8)!
                        self?.onError?(response)
                    }
                    
                case .completed:
                    break
                }
            }.disposed(by: disposeBag)
    }
}

extension LoginViewModel: LoginViewModelInput {
    func viewDidLoad() {
        
    }
}
