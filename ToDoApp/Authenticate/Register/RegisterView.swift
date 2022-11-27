//  
//  RegisterView.swift
//  ToDoApp
//
//  Created by Bundid on 26/11/2565 BE.
//

import UIKit
import RxSwift

class RegisterView: UIViewController {
    
    // OUTLETS HERE
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var cfPasswordField: UITextField!

    // VARIABLES HERE
    private var viewModel: RegisterViewModelProtocol!
    private let disposeBag = DisposeBag()
    
    static func createModule(with viewModel: RegisterViewModel) -> UIViewController {
        guard let view = UIStoryboard(name: "\(Self.self)", bundle: nil).instantiateInitialViewController() as? RegisterView else {
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
        viewModel.onError = { [weak self] error in
            self?.dismissWaiting()
            self?.showAlert("Error", message: "\(error)", action: "OK")
        }
        
        viewModel.onSuccess = { [weak self] in
            self?.dismissWaiting()
            self?.showAlert("Done", message: "Your registration is success.", action: "OK", completion: { _ in
                self?.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    func setupRX(){
        registerButton?.rx.tap
            .bind { [weak self] in
                if self?.validateName() == true &&
                    self?.validateEmail() == true &&
                    self?.validateAge() == true &&
                    self?.validatePassword() == true {
                    var registModel = RegisterModel()
                    registModel.name = self?.nameField.text
                    registModel.email = self?.emailField.text
                    registModel.password = self?.passwordField.text
                    
                    if let age = self?.ageField.text {
                        registModel.age = Int(age)
                    } else {
                        registModel.age = 0
                    }
                    self?.showWaiting()
                    self?.viewModel.registerCall(registModel)
                    
                }
            }.disposed(by: disposeBag)
        
        resetButton?.rx.tap
            .bind { [weak self] in
                self?.clearInput()
            }.disposed(by: disposeBag)
    }
    
    // MARK: Check view has destroy
    deinit {
        print("deinit: \(Self.self)")
    }
}

// MARK: Binding
extension RegisterView {
    func setupViewModel() {
        
    }
}

extension RegisterView {
    
    func clearInput(){
        nameField.text = ""
        emailField.text = ""
        ageField.text = ""
        passwordField.text = ""
        cfPasswordField.text = ""
    }
    
    func validateName() -> Bool {
        guard let name = nameField.text else { return false }
        if name.isEmpty {
            return false
        }
        
        return true
    }
    
    func validatePassword() -> Bool{
        guard let password = passwordField.text,
              let confirmPassword = cfPasswordField.text else {
            return false
        }
        if password.isEmpty || confirmPassword.isEmpty {
            showAlert("Warning", message: "Please fill password", action: "OK")
            return false
        }
        
        if password.count < 7 || confirmPassword.count < 7 {
            showAlert("Warning", message: "Password have to be 7 characters at least", action: "OK")
            return false
        }
        
        if password != confirmPassword {
            showAlert("Warning", message: "Password not match", action: "OK")
            return false
        }
        
        if password == confirmPassword {
            return true
        }
        
        return false
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
    
    func validateAge() -> Bool {
        guard let age = ageField.text else { return false }
        let agePred = NSPredicate(format:"SELF MATCHES %@", "[0-9]{1,2}")
        let result = agePred.evaluate(with: age)
        if !result {
            showAlert("Warning", message: "Age has wrong format", action: "OK")
        }
        return result
    }
}
