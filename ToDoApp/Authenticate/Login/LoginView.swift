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
    @IBOutlet weak var emailField: UITextField!
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
        
        viewModel.onError = { [weak self] error in
            self?.dismissWaiting()
            self?.showAlert("Error", message: "\(error)", action: "OK")
        }
        
        viewModel.onSuccess = { [weak self] event in
            UserDefaults.standard.setValue(event.token, forKey: "accessToken")
            self?.dismissWaiting()
            print("go todo list")
            let todoVC = ToDoListView.createModule(with: ToDoListViewModel())
            self?.navigationController?.pushViewController(todoVC, animated: true)
        }
    }
    
    func setupRX(){
        registerButton?.rx.tap
            .bind { [weak self] in
                let registerVC = RegisterView.createModule(with: RegisterViewModel())
                self?.navigationController?.pushViewController(registerVC, animated: true)
            }.disposed(by: disposeBag)
        
        loginButton?.rx.tap
            .bind { [weak self] in
                UserDefaults.standard.setValue("", forKey: "accessToken")
                var loginBody = LoginModel()
                loginBody.email = self?.emailField.text
                loginBody.password = self?.passwordField.text
                self?.showWaiting()
                self?.viewModel.loginCall(loginBody)
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

extension LoginView {
    func validatePassword() -> Bool{
        guard let password = passwordField.text else {
            return false
        }
        if password.isEmpty {
            showAlert("Warning", message: "Please fill password", action: "OK")
            return false
        }
        
        if password.count < 7 {
            showAlert("Warning", message: "Password have to be 7 characters at least", action: "OK")
            return false
        }
        
        return true
    }
    
    func validateEmail() -> Bool {
        guard let email = emailField.text else { return false }
        let emailPred = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        let result = emailPred.evaluate(with: email)
        
        if email.isEmpty {
            showAlert("Warning", message: "Please fill email address", action: "OK")
        }
        
        if !result {
            showAlert("Warning", message: "Email has wrong format", action: "OK")
        }
        return result
    }
}
