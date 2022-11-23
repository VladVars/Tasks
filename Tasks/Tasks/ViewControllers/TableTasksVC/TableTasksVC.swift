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
    
}

extension TableTasksVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TaskCell.self), for: indexPath) as! TaskCell
        
        cell.configureCell(taskText: RealmManager.read()[indexPath.row].task, taskTime: RealmManager.read()[indexPath.row].time!)
        
        return cell
    }
}
extension TableTasksVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Удалить", message: "Вы действительно хотите удалить напоминание?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Нет", style: .cancel)
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
            RealmManager.delete(object: self.tasks[indexPath.row])
            self.tasks = RealmManager.read()
            
        }
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true)
        update()
    }
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
