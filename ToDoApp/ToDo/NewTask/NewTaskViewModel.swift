//  
//  NewTaskViewModel.swift
//  ToDoApp
//
//  Created by Bundid on 26/11/2565 BE.
//

import Foundation
import RxSwift

// MARK: View -> ViewModel
protocol NewTaskViewModelInput {
    func viewDidLoad()
    func addTask(_ todo: NewTaskModel)
}

// MARK: ViewModel -> View
protocol NewTaskViewModelOutput {
    var onSuccess: (() -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }
}

protocol NewTaskViewModelProtocol: NewTaskViewModelInput, NewTaskViewModelOutput { }

class NewTaskViewModel: NewTaskViewModelProtocol, NewTaskViewModelOutput {
    
    var dataModel = NewTaskModel()
    private let disposeBag = DisposeBag()
    var onSuccess: (() -> Void)?
    var onError: ((String) -> Void)?
}

extension NewTaskViewModel: NewTaskViewModelInput {
    func viewDidLoad() {
        
    }
    
    func addTask(_ todo: NewTaskModel) {
        let taskContext = ConnectivityContext()
        print(todo.toString())
        taskContext.addTask(task: todo.toString())
            .subscribe { [weak self] event in
                switch event {
                case .next:
                    self?.onSuccess?()

                case .error(_):
                    self?.onError?("Have error occurred")

                case .completed:
                    break
                }
            }.disposed(by: disposeBag)
    }
}
