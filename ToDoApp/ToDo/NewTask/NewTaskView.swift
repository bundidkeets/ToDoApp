//  
//  NewTaskView.swift
//  ToDoApp
//
//  Created by Bundid on 26/11/2565 BE.
//

import UIKit
import RxSwift
import RxCocoa
import IQActionSheetPickerView

class NewTaskView: UIViewController {
    
    // OUTLETS HERE
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var screenButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var timeField: UITextField!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var marginRight: NSLayoutConstraint!
    @IBOutlet weak var modalView: UIView!
    
    // VARIABLES HERE
    private var viewModel: NewTaskViewModelProtocol!
    private let disposeBag = DisposeBag()
    private let iconList: [TaskIcon] = [.icon1, .icon2, .icon3, .icon4, .icon5, .icon6]
    private var selectedIconIndex = 0
    private var isPickerDate = false
    private var selectedDate = Date()
    private var selectedTime = Date()
    var afterDismiss: (() -> Void)?
    
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
        setupRX()
    }
    
    func setupView() {
        let screenWidth = UIScreen.main.bounds.size.width * 0.8
        marginRight.constant = -screenWidth
        view.layoutIfNeeded()
        presentView()
        addButton.setRectangle()
        descriptionField.setRectangle()
        descriptionField.setBorder(1.0, color: .lightGray)
        modalView.roundCorners([.topLeft, .bottomLeft], radius: 20)
        
        viewModel.onSuccess = { [weak self] in
            self?.showAlert("Done", message: "Add new task!!", action: "OK", completion: {
                self?.dismissView()
                self?.afterDismiss?()
            })
        }
        
        viewModel.onError = { [weak self] error in
            self?.dismissWaiting()
            self?.showAlert("Error", message: "\(error)", action: "OK")
        }
    }
    
    func setupRX(){
        screenButton?.rx.tap
            .bind { [weak self] in
                self?.dismissView()
            }.disposed(by: disposeBag)
        
        addButton?.rx.tap
            .bind { [weak self] in
                if self?.nameValidation() == true &&
                    self?.dateValidation() == true &&
                    self?.timeValidation() == true {
                    var taskObj = NewTaskModel()
                    taskObj.name = self?.nameField.text
                    taskObj.description = self?.descriptionField.text
                    taskObj.date = self?.dateField.text
                    taskObj.time = self?.timeField.text
                    taskObj.icon = self?.iconList[self!.selectedIconIndex].imageName
                    self?.viewModel.addTask(taskObj)
                }
                
            }.disposed(by: disposeBag)
        
        dateButton?.rx.tap
            .bind { [weak self] in
                self?.showDatePicker()
            }.disposed(by: disposeBag)
        
        timeButton?.rx.tap
            .bind { [weak self] in
                self?.showTimePicker()
            }.disposed(by: disposeBag)
    }
    
    func dismissView(){
        UIView.animate(withDuration: 0.5, delay: 0, animations: {
            let screenWidth = UIScreen.main.bounds.size.width * 0.8
            self.marginRight.constant = -screenWidth
            self.view.layoutIfNeeded()
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.dismiss(animated: false)
        }
    }
    
    func presentView(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            UIView.animate(withDuration: 0.5, delay: 0, animations: {
                self.marginRight.constant = 0
                
                self.view.layoutIfNeeded()
            })
        }
    }
    
    public func showDatePicker() {
        isPickerDate = true
        let picker = IQActionSheetPickerView(title: "", delegate: self)
        picker.actionSheetPickerStyle = .datePicker
        picker.show()
        picker.setDate(selectedDate, animated: false)
    }
    
    public func showTimePicker() {
        isPickerDate = false
        let picker = IQActionSheetPickerView(title: "", delegate: self)
        picker.actionSheetPickerStyle = .timePicker
        picker.show()
        picker.setDate(selectedTime, animated: false)
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

extension NewTaskView {
    func nameValidation() -> Bool {
        guard let name = nameField.text else { return false }
        if name.isEmpty {
            showAlert("Warning", message: "Please enter name of task", action: "OK")
            return false
        }
        return true
    }
    
    func dateValidation() -> Bool {
        guard let date = dateField.text else { return false }
        if date.isEmpty {
            showAlert("Warning", message: "Please enter date of task", action: "OK")
            return false
        }
        return true
    }
    
    func timeValidation() -> Bool {
        guard let time = timeField.text else { return false }
        if time.isEmpty {
            showAlert("Warning", message: "Please enter time of task", action: "OK")
            return false
        }
        return true
    }
}

extension NewTaskView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return iconList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "iconcell", for: indexPath) as? IconCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.iconView.backgroundColor = iconList[indexPath.row].backgroundColor
        cell.iconImage.image = UIImage(named: iconList[indexPath.row].imageName)
        if selectedIconIndex == indexPath.row {
            cell.bullet.isHidden = false
        } else {
            cell.bullet.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIconIndex = indexPath.row
        collectionView.reloadData()
    }
    
}

extension NewTaskView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 48.0, height: 48.0)
    }
}

extension NewTaskView: IQActionSheetPickerViewDelegate {
    func actionSheetPickerView(_ pickerView: IQActionSheetPickerView, didSelect date: Date) {
        if isPickerDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM yyyy"
            dateFormatter.locale = Locale(identifier: "en-US")
            dateField.text = dateFormatter.string(from: date)
            selectedDate = date
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            dateFormatter.locale = Locale(identifier: "en-US")
            timeField.text = dateFormatter.string(from: date)
            selectedTime = date
        }
    }
}
