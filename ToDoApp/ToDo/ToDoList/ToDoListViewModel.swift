//  
//  ToDoListViewModel.swift
//  ToDoApp
//
//  Created by Bundid on 26/11/2565 BE.
//

import Foundation
import RxSwift
import Moya

// MARK: View -> ViewModel
protocol ToDoListViewModelInput {
    func viewDidLoad()
    
}

// MARK: ViewModel -> View
protocol ToDoListViewModelOutput {
    var onSuccess: (() -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }
}

protocol ToDoListViewModelProtocol: ToDoListViewModelInput, ToDoListViewModelOutput { }

class ToDoListViewModel: ToDoListViewModelProtocol, ToDoListViewModelOutput {
    
    var dataModel = ToDoListModel()
    private let disposeBag = DisposeBag()
    var onSuccess: (() -> Void)?
    var onError: ((String) -> Void)?
}

extension ToDoListViewModel: ToDoListViewModelInput {
    
    func viewDidLoad() {
        
    }
    
    
}
