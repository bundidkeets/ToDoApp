//  
//  LoginView.swift
//  ToDoApp
//
//  Created by Bundid on 26/11/2565 BE.
//

import UIKit
import RxSwift
import RxCocoa

class LoginView: UIViewController {
    
    // OUTLETS HERE
    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    // VARIABLES HERE
    private var viewModel: LoginViewModelProtocol!
    private let disposeBag = DisposeBag()
    
    static func createModule(with viewModel: LoginViewModel) -> UIViewController {
        guard let view = UIStoryboard(name: "\(Self.self)", bundle: nil).instantiateInitialViewController() as? LoginView else {
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
        setupRX()
    }
    
    func setupView() {
        navigationItem.hidesBackButton = true
        loginButton?.layer.cornerRadius = 8
    }
    
    func setupRX(){
        registerButton?.rx.tap
            .bind { [weak self] in
                let registerVC = RegisterView.createModule(with: RegisterViewModel())
                self?.navigationController?.pushViewController(registerVC, animated: true)
            }.disposed(by: disposeBag)
        
        loginButton?.rx.tap
            .bind { [weak self] in
                
            }.disposed(by: disposeBag)
    }
    
    // MARK: Check view has destroy
    deinit {
        print("deinit: \(Self.self)")
    }
}

// MARK: Binding
extension LoginView {
    func setupViewModel() {
        
    }
}
