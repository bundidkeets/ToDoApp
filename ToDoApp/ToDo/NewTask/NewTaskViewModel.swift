//  
//  NewTaskViewModel.swift
//  ToDoApp
//
//  Created by Bundid on 26/11/2565 BE.
//

import Foundation

// MARK: View -> ViewModel
protocol NewTaskViewModelInput {
    func viewDidLoad()
}

// MARK: ViewModel -> View
protocol NewTaskViewModelOutput {
    
}

protocol NewTaskViewModelProtocol: NewTaskViewModelInput, NewTaskViewModelOutput { }

class NewTaskViewModel: NewTaskViewModelProtocol, NewTaskViewModelOutput {
    
    var dataModel = NewTaskModel()
}

extension NewTaskViewModel: NewTaskViewModelInput {
    func viewDidLoad() {
        
    }
}
