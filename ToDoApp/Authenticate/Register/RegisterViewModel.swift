//  
//  RegisterViewModel.swift
//  ToDoApp
//
//  Created by Bundid on 26/11/2565 BE.
//

import Foundation

// MARK: View -> ViewModel
protocol RegisterViewModelInput {
    func viewDidLoad()
}

// MARK: ViewModel -> View
protocol RegisterViewModelOutput {
    
}

protocol RegisterViewModelProtocol: RegisterViewModelInput, RegisterViewModelOutput { }

class RegisterViewModel: RegisterViewModelProtocol, RegisterViewModelOutput {
    
    var dataModel = RegisterModel()
}

extension RegisterViewModel: RegisterViewModelInput {
    func viewDidLoad() {
        
    }
}
