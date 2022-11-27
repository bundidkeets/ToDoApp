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
    @IBOutlet weak var binButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var checkView: UIView!
    @IBOutlet weak var binView: UIView!
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var doneView: UIView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var popupName: UILabel!
    @IBOutlet weak var popupDate: UILabel!
    @IBOutlet weak var popupTime: UILabel!
    @IBOutlet weak var popupIconView: UIView!
    @IBOutlet weak var popupIconImage: UIImageView!
    @IBOutlet weak var popupDescriptionLabel: UILabel!
    @IBOutlet weak var popupDoneButton: UIButton!
    
    
    // VARIABLES HERE
    private var viewModel: ToDoListViewModelProtocol!
    private let disposeBag = DisposeBag()
    private var rightButton: UIButton?
    private var leftButton: UIButton?
    private var taskList: [NewTaskModel] = []
    var listMode: listMode? = .defaultMode
    var numberOfSection = 1
    var checkMode = false {
        didSet {
            if checkMode {
                checkModeButton()
            } else {
                defaultButton()
            }
            tableView.reloadData()
        }
    }
    var isDoneMode = false
    var afterLogout: (() -> Void)?
    var checkList:[Bool] = []
    
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
        checkMode = false
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
            
            leftButton = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 40.0, height: .greatestFiniteMagnitude))
            leftButton?.backgroundColor = .clear
            leftButton?.setTitle("", for: .normal)
            leftButton?.setTitleColor(.darkGray, for: .normal)
            leftButton?.setImage(UIImage(named: "logout"), for: .normal)
            leftButton?.contentHorizontalAlignment = .left
            
            if let leftButton = leftButton {
                navigationItem.leftBarButtonItem = .init(customView: leftButton)
            }
            
            menuView.isHidden = false
        }
        
        checkView.setCircle()
        binView.setCircle()
        addView.setCircle()
        cancelView.setCircle()
        doneView.setCircle()
        popupDoneButton.setRectangle()
        dismissPopup()
        
        viewModel.onError = { [weak self] error in
            self?.dismissWaiting()
            self?.showAlert("Error", message: "\(error)", action: "OK")
        }
        
        viewModel.onSuccessGetTask = { [weak self] event in
            self?.dismissWaiting()
            self?.convertToTaskObject(event)
        }
        
        viewModel.loggedOut = { [weak self]  in
            self?.dismissWaiting()
            self?.afterLogout?()
        }
        
        viewModel.onSuccessGetTaskById = { [weak self] taskObject in
            self?.dismissWaiting()
            guard let taskModel = self?.convertTaskRespToNewTaskModel(taskObject) else { return }
            self?.showPopup(taskModel)
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
                if self?.isDoneMode == true {
                    self?.navigationController?.popViewController(animated: true)
                } else {
                    self?.showAlert("Logout", message: "Are you sure to logout?", action: "Logout", cancelMessage: "Later" , completion: { selection in
                        if selection == true {
                            self?.showWaiting()
                            self?.viewModel.logout()
                        }
                    })
                }
                
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
        
        popupDoneButton?.rx.tap
            .bind { [weak self] in
                self?.dismissPopup()
            }.disposed(by: disposeBag)
        
        checkButton?.rx.tap
            .bind { [weak self] in
                self?.checkMode = true
            }.disposed(by: disposeBag)
        
        binButton?.rx.tap
            .bind { [weak self] in
                self?.showAlert("Confirm", message: "Confirm to delete these tasks?", action: "OK", cancelMessage: "Cancel" , completion: { selection in
                    if selection == true {
                        self?.deleteChecked()
                    }
                })
            }.disposed(by: disposeBag)
        
        cancelButton?.rx.tap
            .bind { [weak self] in
                self?.clearChecked()
                self?.checkMode = false
            }.disposed(by: disposeBag)
        
        doneButton?.rx.tap
            .bind { [weak self] in
                self?.completeChecked()
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
    
    func clearPopup(){
        let icon1:TaskIcon = .icon1
        popupName.text = ""
        popupDate.text = ""
        popupTime.text = ""
        popupDescriptionLabel.text = ""
        popupIconView.backgroundColor = icon1.backgroundColor
        popupIconImage.image = UIImage(named: icon1.imageName)
    }
    
    func showPopup(_ item: NewTaskModel){
        clearPopup()
        popupView.isHidden = false
        
        popupName.text = item.name
        popupDate.text = item.date
        popupTime.text = item.time
        popupDescriptionLabel.text = item.description
        popupIconView.backgroundColor = getTaskIcon(item.icon ?? "").backgroundColor
        popupIconImage.image = UIImage(named: getTaskIcon(item.icon ?? "").imageName)
    }
    
    func getCheckList() -> [String] {
        var checkId: [String] = []
        for (index, listObj) in taskList.enumerated() {
            if let id = listObj.id {
                if index >= checkList.count {
                    continue
                }
                
                if checkList[index] {
                    checkId.append(id)
                }
            }
        }
        return checkId
    }
    
    func completeChecked(){
        let checkList = getCheckList()
        if checkList.count == 0 { return }
        viewModel.finishedTaskById(checkList)
        viewModel.afterComplete = { [weak self] in
            self?.checkMode = false
            self?.reloadContent()
        }
    }
    
    func deleteChecked(){
        let checkList = getCheckList()
        if checkList.count == 0 { return }
        viewModel.deleteTaskById(checkList)
        viewModel.afterDelete = { [weak self] in
            self?.checkMode = false
            self?.reloadContent()
        }
    }
    
    func clearChecked(){
        let numeberOfList = checkList.count
        for index in 0 ... numeberOfList - 1 {
            checkList[index] = false
        }
    }
    
    func dismissPopup(){
        popupView.isHidden = true
    }
    
    func convertToTaskObject(_ descriptions: [TaskResponse]){
        taskList = []
        checkList = []
        for data in descriptions {
            guard let desc = data.description ,
                  let id = data.id
            else { return }
            if let data = desc.data(using: .utf8) {
                guard var newTaskObj = try? JSONDecoder().decode(NewTaskModel.self, from: data) else { return }
                newTaskObj.id = id
                checkList.append(false)
                taskList.append(newTaskObj)
            }
        }
        tableView.reloadData()
    }
    
    func convertTaskRespToNewTaskModel(_ data: TaskResponse) -> NewTaskModel {
        guard let desc = data.description ,
              let id = data.id
        else { return NewTaskModel() }
        if let data = desc.data(using: .utf8) {
            guard var newTaskObj = try? JSONDecoder().decode(NewTaskModel.self, from: data) else { return NewTaskModel() }
            newTaskObj.id = id
            return newTaskObj
        } else {
            return NewTaskModel()
        }
    }
    
    func defaultButton(){
        checkView.isHidden = false
        addView.isHidden = false
        cancelView.isHidden = true
        binView.isHidden = true
        doneView.isHidden = true
    }
    
    func checkModeButton(){
        checkView.isHidden = true
        addView.isHidden = true
        cancelView.isHidden = false
        binView.isHidden = false
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
            
            if checkList[indexPath.row] {
                cell.checkImage.image = UIImage(named: "checked")
            } else {
                cell.checkImage.image = UIImage(named: "uncheck")
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !checkMode {
            guard let id = taskList[indexPath.row].id else { return }
            showWaiting()
            viewModel.getTaskById(id)
        } else {
            checkList[indexPath.row] = !checkList[indexPath.row]
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
    }
}
