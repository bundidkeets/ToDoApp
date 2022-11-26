//  
//  ToDoListViewModel.swift
//  ToDoApp
//
//  Created by Bundid on 26/11/2565 BE.
//

import Foundation

// MARK: View -> ViewModel
protocol ToDoListViewModelInput {
    func viewDidLoad()
}

// MARK: ViewModel -> View
protocol ToDoListViewModelOutput {
    
}

protocol ToDoListViewModelProtocol: ToDoListViewModelInput, ToDoListViewModelOutput { }

class ToDoListViewModel: ToDoListViewModelProtocol, ToDoListViewModelOutput {
    
    var dataModel = ToDoListModel()
}

extension ToDoListViewModel: ToDoListViewModelInput {
    func viewDidLoad() {
        
    }
}
