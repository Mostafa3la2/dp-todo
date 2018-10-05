//
//  SettingsVC.swift
//  dp-todo
//
//  Created by Mostafa Alaa on 10/4/18.
//  Copyright © 2018 Mostafa Alaa. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var categoryColorTextField: UITextField!
    @IBOutlet weak var notificationSwift: UISwitch!
    @IBOutlet weak var categoryNameTextField: UITextField!
    @IBOutlet weak var switchBtn: UISwitch!
    
    //this is the system colours enum array which represents the picker options
    var colourOptions:[SystemColor] = [.red,.blue,.green,.yellow,.tealBlue,.purple,.orange,.pink]
    var selectedColour :SystemColor? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        //getting the initial state of notifications
        switchBtn.setOn(UserDefaults.standard.bool(forKey: "notifications"), animated: false)
        
        setupPickerView()
        let tapToDismiss = UITapGestureRecognizer(target: self, action: #selector(tapAnywhereToDismiss))
        tapToDismiss.cancelsTouchesInView = false
        view.addGestureRecognizer(tapToDismiss)
    }
    @objc func tapAnywhereToDismiss(){
        categoryColorTextField.endEditing(true)
        categoryNameTextField.endEditing(true)
    }
    @IBAction func saveBtnPressed(_ sender: Any) {
        if categoryNameTextField.text != "" {
            if selectedColour != nil{
                save { (success) in
                    if success{
                        navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    @IBAction func switchBtnChanged(_ sender: Any) {
        if switchBtn.isOn{
            UserDefaults.standard.set(true, forKey: "notifications")
        }else{
            UserDefaults.standard.set(false, forKey: "notifications")
        }
    }
    
}
extension SettingsVC:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return colourOptions.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        colorView.backgroundColor = colourOptions[row].uiColor
        selectedColour = colourOptions[row]
    }
    //setting the picker view with text representing each color
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var titleData = ""
        titleData = colourOptions[row].rawValue
        let attributedString = NSAttributedString(string: String(titleData), attributes: [NSAttributedStringKey.foregroundColor : colourOptions[row].uiColor])
        return attributedString
    }
    
    
    func setupPickerView(){
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.setValue(#colorLiteral(red: 0.003921568627, green: 0.5803921569, blue: 0.2549019608, alpha: 1), forKey: "backgroundColor")
        categoryColorTextField.inputView = pickerView
        
    }
    
    
}
extension SettingsVC{
    
    //saving newly created categories
    func save(completion:(_ finished:Bool)->()){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        let category = Category(context: managedContext)
        category.categoryColour = selectedColour?.rawValue
        category.categoryName = categoryNameTextField.text!
  
        do{
            try managedContext.save()
            completion(true)
        }catch{
            debugPrint(error.localizedDescription)
            completion(false)
        }
    }
}
