//
//  AddEditTasksVC.swift
//  dp-todo
//
//  Created by Mostafa Alaa on 10/4/18.
//  Copyright © 2018 Mostafa Alaa. All rights reserved.
//

import UIKit
import CoreData

class AddEditTasksVC: UIViewController {

    @IBOutlet weak var categoriesTableView: UITableView!
    @IBOutlet weak var taskTitleTextField: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var completionDateTextField: UITextField!
    
    private var categories:[Category] = []
    
    private var selectedCategory : Category? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //adding tap gesture to dismiss keyboard and end textfields editing
        let tapToDismiss = UITapGestureRecognizer(target: self, action: #selector(tapAnywhereToDismiss))
        tapToDismiss.cancelsTouchesInView = false
        view.addGestureRecognizer(tapToDismiss)
        
        categoriesTableView.dataSource = self
        categoriesTableView.delegate = self
        setupDatePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCategories { (success) in
            if success{
                categoriesTableView.reloadData()
            }
        }
    }
    @objc func tapAnywhereToDismiss(){
        taskTitleTextField.endEditing(true)
        completionDateTextField.endEditing(true)
    }
    @IBAction func saveBtnPressed(_ sender: Any) {
        if taskTitleTextField.text != nil && taskTitleTextField.text != "" && selectedCategory != nil{
            
            save { (success) in
                if success{
                    navigationController?.popViewController(animated: true)
                    
                }
            }
        }
    }
    
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "dd/MMMM/yyyy"
        dateFormatter.timeStyle = .none
        completionDateTextField.text = dateFormatter.string(from: sender.date)
    }
    //configuring a date picker view when the user want to set a completion date
    func setupDatePicker(){
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        datePickerView.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        
        datePickerView.setValue(#colorLiteral(red: 0.07843137255, green: 0.2588235294, blue: 0.5803921569, alpha: 1), forKey: "textColor")
        datePickerView.setValue(#colorLiteral(red: 0.003921568627, green: 0.5803921569, blue: 0.2549019608, alpha: 1), forKey: "backgroundColor")
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged(_:)), for: UIControlEvents.valueChanged)
        completionDateTextField.inputView = datePickerView
    }
    
}

extension AddEditTasksVC:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "categoriesCell") as? CategoriesCell else{return UITableViewCell()}
        let category = categories[indexPath.row]
        
        cell.configureCell(categoryName: category.categoryName!, categoryColour: category.categoryColour!)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.row]
    }
    
}


extension AddEditTasksVC{
    func save(completion:(_ finished:Bool)->()){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        let task = Task(context: managedContext)
        task.taskTitle = taskTitleTextField.text!
        task.category = selectedCategory
        
        if completionDateTextField.text != nil && completionDateTextField.text != "" {
            //date formatting before saving it to core data
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MMMM/yyyy"
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            let date = dateFormatter.date(from: completionDateTextField.text!)!
            task.completionDate = date
        }else{
            task.completionDate = nil
        }
       
        do{
            try managedContext.save()
            completion(true)
        }catch{
            debugPrint(error.localizedDescription)
            completion(false)
        }
    }
    
    //fetching categories
    func fetchCategories(completion:(_ complete:Bool)->()){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else{return}
        
        let fetchRequest = NSFetchRequest<Category>(entityName: "Category")
        
        do{
            categories = try managedContext.fetch(fetchRequest)
            completion(true)
        }catch{
            debugPrint(error.localizedDescription)
            completion(false)
        }
    }
    
}
