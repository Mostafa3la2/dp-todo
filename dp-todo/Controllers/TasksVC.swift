//
//  ViewController.swift
//  dp-todo
//
//  Created by Mostafa Alaa on 10/4/18.
//  Copyright © 2018 Mostafa Alaa. All rights reserved.
//

import UIKit
import CoreData

//global reference to app delegate where whe get a reference to the core data context
let appDelegate = UIApplication.shared.delegate as? AppDelegate

class TasksVC: UIViewController {

    
    @IBOutlet weak var tasksTableView: UITableView!
    
    private var tasks:[Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tasksTableView.delegate = self
        tasksTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchModelFromCoreData()
        tasksTableView.reloadData()
    }
    
    func fetchModelFromCoreData(){
        self.fetch { (complete) in
            if complete{
                if tasks.count>=1{
                    tasksTableView.isHidden = false
                }else{
                    tasksTableView.isHidden = true
                }
            }
        }
    }

}
extension TasksVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tasksCell") as? TasksCell else{return UITableViewCell()}
        //this array should be populated with data from core data
        let task = tasks[indexPath.row]
        var completionDateString = ""
        //as completion date is optional, I only format it when it exists
        if task.completionDate != nil{
            let formatter = DateFormatter()
            
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            formatter.dateFormat = "dd/MMMM/yyyy"
            completionDateString = formatter.string(from: task.completionDate!)
        }
        
        //configuring the task cell with data extracted from Core Data
        cell.configCell(title: task.taskTitle!, date: completionDateString, categoryTitle: (task.category?.categoryName)!, categoryColour: (task.category?.categoryColour!)!,completed: task.completed)
        return cell
        
    }
    //configure actions and refetching data when deletion occurs
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (rowAction, indexPath) in
            self.removeTask(atIndexPath: indexPath)
            self.fetchModelFromCoreData()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        let completeAction = UITableViewRowAction(style: .normal, title: "Complete") { (rowAction, indexPath) in
            let selectedTask = self.tasks[indexPath.row]
            selectedTask.completed = true
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        completeAction.backgroundColor = #colorLiteral(red: 0.003921568627, green: 0.5803921569, blue: 0.2549019608, alpha: 1)
        return [deleteAction,completeAction]
    }

    
}

extension TasksVC{
    //fetching data from core data and populating the array with it
    func fetch(completion:(_ complete:Bool)->()){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else{return}
        
        let fetchRequest = NSFetchRequest<Task>(entityName: "Task")
        
        do{
            tasks = try managedContext.fetch(fetchRequest)
            completion(true)
        }catch{
            debugPrint(error.localizedDescription)
            completion(false)
        }
    }
    func removeTask(atIndexPath indexPath:IndexPath){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else{return}
        managedContext.delete(tasks[indexPath.row])
        
        do{
            try managedContext.save()
        }catch{
            debugPrint(error.localizedDescription)
        }
    }
    
}

