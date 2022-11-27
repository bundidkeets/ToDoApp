//  
//  ToDoListView.swift
//  ToDoApp
//
//  Created by Bundid on 26/11/2565 BE.
//

import UIKit
import RxSwift
import RxCocoa
import ObjectMapper

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
    @IBOutlet weak var checkView: UIView!
    @IBOutlet weak var modeView: UIView!
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var doneView: UIView!
    @IBOutlet weak var menuView: UIView!
    
    
    // VARIABLES HERE
    private var viewModel: ToDoListViewModelProtocol!
    private let disposeBag = DisposeBag()
    private var rightButton: UIButton?
    private var leftButton: UIButton?
    private var taskList: [NewTaskModel] = []
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
    var checkMode = false
    var isDoneMode = false
    
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
        tableView.register(UINib(nibName: "ToDoTableViewCell", bundle: nil), forCellReuseIdentifier: "todo")
        listMode = .defaultMode
        navigationItem.hidesBackButton = true
        
        if isDoneMode {
            navigationItem.title = "DONE TASKS"
            
            leftButton = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 40.0, height: .greatestFiniteMagnitude))
            leftButton?.backgroundColor = .clear
            leftButton?.setTitle("", for: .normal)
            leftButton?.setTitleColor(.darkGray, for: .normal)
            leftButton?.setImage(UIImage(named: "back"), for: .normal)
            leftButton?.contentHorizontalAlignment = .left
            
            if let leftButton = leftButton {
                navigationItem.leftBarButtonItem = .init(customView: leftButton)
            }
            menuView.isHidden = true
        } else {
            navigationItem.title = "TODO"
            
            rightButton = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 40.0, height: .greatestFiniteMagnitude))
            rightButton?.backgroundColor = .clear
            rightButton?.setTitle("", for: .normal)
            rightButton?.setTitleColor(.darkGray, for: .normal)
            rightButton?.setImage(UIImage(named: "checkbox"), for: .normal)
            rightButton?.contentHorizontalAlignment = .right
            if let rightButton = rightButton {
                navigationItem.rightBarButtonItem = .init(customView: rightButton)
            }
            
            menuView.isHidden = false
        }
        
        
        
        checkView.setCircle()
        modeView.setCircle()
        addView.setCircle()
        cancelView.setCircle()
        doneView.setCircle()
        
        viewModel.onError = { [weak self] error in
            self?.dismissWaiting()
            self?.showAlert("Error", message: "\(error)", action: "OK")
        }
        
        viewModel.onSuccessGetTask = { [weak self] event in
            self?.dismissWaiting()
            self?.convertToTaskObject(event)
        }
        
        reloadContent()
    }
    
    func reloadContent() {
        if isDoneMode {
            loadDoneList()
        } else {
            loadTaskList()
        }
    }
    
    func setupRX(){
        rightButton?.rx.tap
            .bind { [weak self] in
                print("Go Done Page")
                guard let todoVC = ToDoListView.createModule(with: ToDoListViewModel()) as? ToDoListView else { return }
                todoVC.isDoneMode = true
                self?.navigationController?.pushViewController(todoVC, animated: true)
            }.disposed(by: disposeBag)
        
        leftButton?.rx.tap
            .bind { [weak self] in
                print("Go Done Page")
                self?.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)
        
        addButton?.rx.tap
            .bind { [weak self] in
                print("Show task view")
                guard let newTaskVC = NewTaskView.createModule(with: NewTaskViewModel()) as? NewTaskView else { return }
                newTaskVC.modalPresentationStyle = .custom
                newTaskVC.modalTransitionStyle = .crossDissolve
                self?.navigationController?.present(newTaskVC, animated: false)
                
                newTaskVC.afterDismiss = {
                    self?.reloadContent()
                }
            }.disposed(by: disposeBag)
        
        
    }
    
    func loadTaskList(){
        showWaiting()
        viewModel.getTask()
    }
    
    func loadDoneList(){
        showWaiting()
        viewModel.getDoneList()
    }
    
    func convertToTaskObject(_ descriptions: [TaskResponse]){
        taskList = []
        for data in descriptions {
            guard let desc = data.description else { return }
            if let data = desc.data(using: .utf8) {
                guard let newTaskObj = try? JSONDecoder().decode(NewTaskModel.self, from: data) else { return }
                taskList.append(newTaskObj)
            }
        }
        tableView.reloadData()
    }
    
    func defaultButton(){
        checkView.isHidden = false
        modeView.isHidden = false
        addView.isHidden = false
        cancelView.isHidden = true
        doneView.isHidden = true
    }
    
    func checkModeButton(){
        checkView.isHidden = true
        modeView.isHidden = true
        addView.isHidden = true
        cancelView.isHidden = false
        doneView.isHidden = false
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
        return taskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "todo", for: indexPath) as? ToDoTableViewCell else {
            return UITableViewCell()
        }
        
        let taskObj = taskList[indexPath.row]
        cell.bullet.backgroundColor = getTaskIcon(taskObj.icon ?? "").backgroundColor
        cell.iconView.backgroundColor = getTaskIcon(taskObj.icon ?? "").backgroundColor
        cell.iconImage.image = UIImage(named: getTaskIcon(taskObj.icon ?? "").imageName)
        cell.taskLabel.text = taskObj.name ?? ""
        cell.dateLabel.text = taskObj.date ?? ""
        cell.timeLabel.text = taskObj.time ?? ""
        
        if !checkMode || isDoneMode {
            cell.checkImage.isHidden = true
            cell.dateLabel.isHidden = false
            cell.timeLabel.isHidden = false
        } else {
            cell.checkImage.isHidden = false
            cell.dateLabel.isHidden = true
            cell.timeLabel.isHidden = true
        }
        
        return cell
    }
}
