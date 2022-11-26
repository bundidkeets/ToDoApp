//  
//  ToDoListView.swift
//  ToDoApp
//
//  Created by Bundid on 26/11/2565 BE.
//

import UIKit

class ToDoListView: UIViewController {
    
    // OUTLETS HERE

    // VARIABLES HERE
    private var viewModel: ToDoListViewModelProtocol!
    
    static func createModule(with viewModel: ToDoListViewModel) -> UIViewController {
        guard let view = UIStoryboard(name: "\(Self.self)", bundle: nil).instantiateInitialViewController() as? ToDoListView else {
            fatalError("Cannot instantiate initial view controller \(Self.self) from storyboard with name \(Self.description())")
        }
        
        view.viewModel = viewModel
        return view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        viewModel.viewDidLoad()
        setupView()
    }
    
    func setupView() {

    }
    
    // MARK: Check view has destroy
    deinit {
        print("deinit: \(Self.self)")
    }
}

// MARK: Binding
extension ToDoListView {
    func setupViewModel() {
        
    }
}
