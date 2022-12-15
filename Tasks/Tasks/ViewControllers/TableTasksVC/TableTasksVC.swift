//
//  TableTasksVC.swift
//  Tasks
//
//  Created by mac on 17.04.22.
//

import UIKit

class TableTasksVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleTasks: UILabel!
    @IBOutlet weak var book: UIImageView!
    
    
    var tasks = RealmManager.read(){
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        tableView.dataSource = self
        tableView.delegate = self
        
        let nibCell = UINib(nibName: String(describing: TaskCell.self), bundle: nil)
        tableView.register(nibCell, forCellReuseIdentifier: String(describing: TaskCell.self))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        update()
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func pushEditAction(_ sender: Any) {
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
    
}

extension TableTasksVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return tasks.filter({!$0.isDone}).count
        }
        return tasks.filter({$0.isDone}).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TaskCell.self), for: indexPath) as! TaskCell
        
        if indexPath.section == 0 {
            let undone = tasks.filter({ !$0.isDone })
            cell.configureCell(task: undone[indexPath.row])
        } else if indexPath.section == 1 {
            let done = tasks.filter({ $0.isDone })
            cell.configureCell(task: done[indexPath.row])
        }
        return cell
    }
    
}
extension TableTasksVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Невыполненые"
        }
        return "Выполненые"
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") {  (contextualAction, view, boolValue) in
            RealmManager.delete(object: self.tasks[indexPath.row])
            self.tasks = RealmManager.read()
            self.update()
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return swipeActions
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        RealmManager.startTransaction()
        if indexPath.section == 0 {
            let undone = tasks.filter({ !$0.isDone })
            undone[indexPath.row].isDone = !undone[indexPath.row].isDone
        } else if indexPath.section == 1 {
            let done = tasks.filter({ $0.isDone })
            done[indexPath.row].isDone = !done[indexPath.row].isDone
        }
        RealmManager.claseTransaction()
        tableView.reloadData()
    }
//    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to : IndexPath) {
//
//    }
}

extension TableTasksVC: Update {
    
    func update() {
        if RealmManager.read().count == 0 {
            titleTasks.text = "Список пуст"
            book.isHidden = true
        } else {
            titleTasks.text = "Список задач"
            
        }
    }
    
}
