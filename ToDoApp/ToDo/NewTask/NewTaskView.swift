//  
//  NewTaskView.swift
//  ToDoApp
//
//  Created by Bundid on 26/11/2565 BE.
//

import UIKit

class NewTaskView: UIViewController {
    
    // OUTLETS HERE

    // VARIABLES HERE
    private var viewModel: NewTaskViewModelProtocol!
    
    static func createModule(with viewModel: NewTaskViewModel) -> UIViewController {
        guard let view = UIStoryboard(name: "\(Self.self)", bundle: nil).instantiateInitialViewController() as? NewTaskView else {
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
extension NewTaskView {
    func setupViewModel() {
        
    }
}
