//  
//  ToDoListView.swift
//  ToDoApp
//
//  Created by Bundid on 26/11/2565 BE.
//

import UIKit
import RxSwift
import RxCocoa

enum listMode: Int {
    case defaultMode
    case calendarMode
}

class ToDoListView: UIViewController {
    
    // OUTLETS HERE
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var modeButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    
    // VARIABLES HERE
    private var viewModel: ToDoListViewModelProtocol!
    private let disposeBag = DisposeBag()
    private var rightButton: UIButton?
    var listMode: listMode? = .defaultMode {
        didSet {
            if listMode == .defaultMode {
                defaultButton()
            } else if listMode == .calendarMode {
                checkModeButton()
            }
        }
    }
    var numberOfSection = 1
    
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
        setupRX()
    }
    
    func setupView() {
        listMode = .defaultMode
        navigationItem.hidesBackButton = true
        navigationItem.title = "TODO"
        rightButton = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 40.0, height: .greatestFiniteMagnitude))
        rightButton?.backgroundColor = .clear
        rightButton?.setTitle("Done", for: .normal)
        rightButton?.setTitleColor(.darkGray, for: .normal)
        rightButton?.contentHorizontalAlignment = .right
        if let rightButton = rightButton {
            navigationItem.rightBarButtonItem = .init(customView: rightButton)
        }
    }
    
    func setupRX(){
        rightButton?.rx.tap
            .bind { [weak self] in
                print("Go Done Page")
            }.disposed(by: disposeBag)
        
        addButton?.rx.tap
            .bind { [weak self] in
                print("Show task view")
                let newTaskVC = NewTaskView.createModule(with: NewTaskViewModel())
                newTaskVC.modalPresentationStyle = .custom
                newTaskVC.modalTransitionStyle = .crossDissolve
                self?.navigationController?.present(newTaskVC, animated: false)
            }.disposed(by: disposeBag)
        
        
    }
    
    func defaultButton(){
        checkButton.isHidden = false
        modeButton.isHidden = false
        addButton.isHidden = false
        cancelButton.isHidden = true
        doneButton.isHidden = true
    }
    
    func checkModeButton(){
        checkButton.isHidden = true
        modeButton.isHidden = true
        addButton.isHidden = true
        cancelButton.isHidden = false
        doneButton.isHidden = false
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

extension ToDoListView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "todo", for: indexPath) as? ToDoTableViewCell else {
            return UITableViewCell()
        }
        return cell
    }
}
