//
//  MainController.swift
//  ToDoApp
//
//  Created by Bundid on 26/11/2565 BE.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        showLogin()
    }

    func showLogin() {
        let loginVC = LoginView.createModule(with: LoginViewModel())
        navigationController?.pushViewController(loginVC, animated: true)
    }
}

