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
    func getTaskById(_ id: String)
    func getDoneList()
    func logout()
    func deleteTaskById(_ id: [String])
    func finishedTaskById(_ id: [String])
}

// MARK: ViewModel -> View
protocol ToDoListViewModelOutput {
    var onSuccessGetTask: (([TaskResponse]) -> Void)? { get set }
    var onSuccessGetTaskById: ((TaskResponse) -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }
    var loggedOut: (() -> Void)? { get set }
    var afterDelete: (() -> Void)? { get set }
    var afterComplete: (() -> Void)? { get set }
}

protocol ToDoListViewModelProtocol: ToDoListViewModelInput, ToDoListViewModelOutput { }

class ToDoListViewModel: ToDoListViewModelProtocol, ToDoListViewModelOutput {
    
    var dataModel = ToDoListModel()
    private let disposeBag = DisposeBag()
    var onSuccessGetTask: (([TaskResponse]) -> Void)?
    var onError: ((String) -> Void)?
    var loggedOut: (() -> Void)?
    var onSuccessGetTaskById: ((TaskResponse) -> Void)?
    var afterDelete: (() -> Void)?
    var afterComplete: (() -> Void)?
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
    
    func getTaskById(_ id: String){
        let taskContext = ConnectivityContext()
        taskContext.getTaskById(id: id)
            .subscribe { [weak self] event in
                switch event {
                case .next:
                    self?.onSuccessGetTaskById?((event.element?.data)!)
                    
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
    
    func deleteTaskById(_ id: [String]){
        for (index, delId) in id.enumerated() {
            let taskContext = ConnectivityContext()
            taskContext.deleteTaskById(id: delId)
                .subscribe { [weak self] event in
                    switch event {
                    case .next:
                        if index == id.count - 1 {
                            self?.afterDelete?()
                        }
                        
                    case .error(let error):
                        if let json = try? JSONSerialization.jsonObject(with: (error as! MoyaError).response!.data, options: .mutableContainers),
                           let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                            print(jsonData)
                            self?.onError?("Have error occurred")
                            break
                        } else {
                            let response = String(data: (error as! MoyaError).response!.data, encoding: .utf8)!
                            self?.onError?(response)
                            break
                        }
                        
                    case .completed:
                        break
                    }
                }.disposed(by: disposeBag)
        }
    }
    
    func finishedTaskById(_ id: [String]){
        for (index, finId) in id.enumerated() {
            let taskContext = ConnectivityContext()
            taskContext.finishedTaskById(id: finId)
                .subscribe { [weak self] event in
                    switch event {
                    case .next:
                        if index == id.count - 1 {
                            self?.afterComplete?()
                        }
                        
                    case .error(let error):
                        if let json = try? JSONSerialization.jsonObject(with: (error as! MoyaError).response!.data, options: .mutableContainers),
                           let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                            print(jsonData)
                            self?.onError?("Have error occurred")
                            break
                        } else {
                            let response = String(data: (error as! MoyaError).response!.data, encoding: .utf8)!
                            self?.onError?(response)
                            break
                        }
                        
                    case .completed:
                        break
                    }
                }.disposed(by: disposeBag)
        }
    }
    
    func getDoneList() {
        let taskContext = ConnectivityContext()
        taskContext.getDone()
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
    
    func logout(){
        let authenContext = ConnectivityContext()
        authenContext.logout()
            .subscribe { [weak self] event in
                switch event {
                case .next:
                    self?.loggedOut?()
                    
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
