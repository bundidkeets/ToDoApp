//
//  MainController.swift
//  ToDoApp
//
//  Created by Bundid on 26/11/2565 BE.
//

import UIKit
import PKHUD
import RxSwift

class MainViewController: UIViewController {

    private let disposeBag = DisposeBag()
    var onSuccess: (() -> Void)?
    var onError: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if myToken().isEmpty {
            showLogin()
        } else {
            autoLogin()
        }
        
        onError = { [weak self] _ in
            self?.dismissWaiting()
            UserDefaults.standard.setValue("", forKey: "accessToken")
            self?.showLogin()
        }
        
        onSuccess = { [weak self] in
            self?.dismissWaiting()
            print("go todo list")
            let todoVC = ToDoListView.createModule(with: ToDoListViewModel())
            self?.navigationController?.pushViewController(todoVC, animated: true)
        }
    }

    func showLogin() {
        let loginVC = LoginView.createModule(with: LoginViewModel())
        navigationController?.pushViewController(loginVC, animated: true)
    }
    
    func autoLogin() {
        showWaiting()
        let authenContext = ConnectivityContext()
        authenContext.me()
            .subscribe { [weak self] event in
                switch event {
                case .next:
                    self?.onSuccess?()

                case .error(_):
                    self?.onError?("")

                case .completed:
                    break
                }
            }.disposed(by: disposeBag)
    }
}

extension NSObject {
    public func myToken() -> String {
        guard let currentToken = UserDefaults.standard.string(forKey: "accessToken") else { return ""}
        return currentToken
    }
}

extension UIViewController {
    public func showAlert(_ title: String, message: String?, action: String, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let ok = UIAlertAction(title: action, style: .default, handler: { _ in
                completion?()
            })
            alertController.addAction(ok)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    public func showWaiting(){
        HUD.show(.progress)
    }
    
    public func dismissWaiting(){
        HUD.hide()
    }
}

extension UIView {
    func setCircle(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.layer.cornerRadius = self.frame.size.width / 2.0
        }
    }
    
    func setRectangle(){
        layer.cornerRadius = 8.0
    }
    
    func setBorder(_ width: CGFloat,color: UIColor) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
    
    public func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
        
        let borderLayer = CAShapeLayer()
        borderLayer.path = maskPath.cgPath
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = UIColor.clear.cgColor
        borderLayer.lineWidth = 4
        borderLayer.frame = bounds
        layer.addSublayer(borderLayer)
    }
}

// For UITextField Handlers
private var tfMaxLengths = [UITextField: Int]()
private var isAgeField = [UITextField: Bool]()
private var ageField = [UITextField: String]()
extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let len = tfMaxLengths[self] else {
               return 150
            }
            return len
        }
        set {
            tfMaxLengths[self] = newValue
            addTarget(self, action: #selector(fixLength), for: .editingChanged)
        }
    }
    
    @IBInspectable var isAge: Bool {
        get {
            guard let val = isAgeField[self] else {
               return false
            }
            return val
        }
        set {
            isAgeField[self] = newValue
            addTarget(self, action: #selector(ageFill), for: .editingChanged)
        }
    }
    
    @objc func fixLength(textField: UITextField) {
        if let tf = textField.text {
            textField.text = String(tf.prefix(maxLength))
        }
    }
    
    @objc func ageFill(textField: UITextField) {
        if isAgeField[self] == true {
            if let tf = textField.text {
                if tf.isEmpty {
                    ageField[self] = tf
                    return
                }
                
                let agePred = NSPredicate(format:"SELF MATCHES %@", "[0-9]{0,2}")
                let result = agePred.evaluate(with: tf)
                if result {
                    guard let ageNumber = Int(tf) else { return }
                    if ageNumber > 0 {
                        ageField[self] = tf
                    } else {
                        textField.text = ageField[self]
                    }
                } else {
                    textField.text = ageField[self]
                }
            }
        }
    }
}

