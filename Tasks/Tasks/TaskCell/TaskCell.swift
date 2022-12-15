//
//  TaskCell.swift
//  Tasks
//
//  Created by mac on 17.04.22.
//

import UIKit

class TaskCell: UITableViewCell {
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var unCheck: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    func configureCell(task: Task) {
        unCheck.image = task.isDone ? UIImage(named: "check") : UIImage(named: "uncheck")
        taskLabel.text = task.task
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        dateLabel.text = formatter.string(from: task.time!)
    }
}
