//  
//  RegisterViewModel.swift
//  ToDoApp
//
//  Created by Bundid on 26/11/2565 BE.
//

import Foundation
import RxSwift
import Moya

// MARK: View -> ViewModel
protocol RegisterViewModelInput {
    func viewDidLoad()
    func registerCall(_ registBody: RegisterModel)
}

// MARK: ViewModel -> View
protocol RegisterViewModelOutput {
    var onSuccess: (() -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }
}

protocol RegisterViewModelProtocol: RegisterViewModelInput, RegisterViewModelOutput { }

class RegisterViewModel: RegisterViewModelProtocol, RegisterViewModelOutput {
    var dataModel = RegisterModel()
    private let disposeBag = DisposeBag()
    var onSuccess: (() -> Void)?
    var onError: ((String) -> Void)?
    
    func registerCall(_ registObject: RegisterModel) {
        let authenContext = ConnectivityContext()
        authenContext.register(registObject: registObject)
            .subscribe { [weak self] event in
                switch event {
                case .next:
                    self?.onSuccess?()
                    
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

extension RegisterViewModel: RegisterViewModelInput {
    func viewDidLoad() {
    }
}
