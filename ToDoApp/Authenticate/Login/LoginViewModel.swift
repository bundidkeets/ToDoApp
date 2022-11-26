//  
//  LoginViewModel.swift
//  ToDoApp
//
//  Created by Bundid on 26/11/2565 BE.
//

import Foundation

// MARK: View -> ViewModel
protocol LoginViewModelInput {
    func viewDidLoad()
}

// MARK: ViewModel -> View
protocol LoginViewModelOutput {
    
}

protocol LoginViewModelProtocol: LoginViewModelInput, LoginViewModelOutput { }

class LoginViewModel: LoginViewModelProtocol, LoginViewModelOutput {
    
    var dataModel = LoginModel()
}

extension LoginViewModel: LoginViewModelInput {
    func viewDidLoad() {
        
    }
}
