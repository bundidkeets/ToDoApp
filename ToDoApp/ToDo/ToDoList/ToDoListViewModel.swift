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
    func getTask()
}

// MARK: ViewModel -> View
protocol ToDoListViewModelOutput {
    var onSuccessGetTask: (([TaskResponse]) -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }
}

protocol ToDoListViewModelProtocol: ToDoListViewModelInput, ToDoListViewModelOutput { }

class ToDoListViewModel: ToDoListViewModelProtocol, ToDoListViewModelOutput {
    
    var dataModel = ToDoListModel()
    private let disposeBag = DisposeBag()
    var onSuccessGetTask: (([TaskResponse]) -> Void)?
    var onError: ((String) -> Void)?
}

extension ToDoListViewModel: ToDoListViewModelInput {
    
    func viewDidLoad() {
        
    }
    
    func getTask(){
        let taskContext = ConnectivityContext()
        taskContext.getTask()
            .subscribe { [weak self] event in
                switch event {
                case .next:
                    self?.onSuccessGetTask?(event.element?.data ?? [])
                    
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
