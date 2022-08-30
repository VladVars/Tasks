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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    func configureCell(taskText: String, taskTime: Date) {
        taskLabel.text = taskText
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        dateLabel.text = formatter.string(from: taskTime)
    }
}
