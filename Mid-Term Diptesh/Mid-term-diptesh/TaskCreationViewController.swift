
import UIKit

class TaskCreationViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var prioritySegment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func addTaskDidTapped(_ sender: UIButton) {
        addTask()
    }
    
    private func addTask() {
        if titleTextField.text == "" || descriptionTextField.text == "" {
            presentAlert()
        } else {
            let title = titleTextField.text ?? ""
            let description = descriptionTextField.text ?? ""
            let dueDate = dueDatePicker.date
            let priority = priority(for: prioritySegment.selectedSegmentIndex)
            
            let task = Todo(title: title, description: description, dueDate: dueDate, priority: priority, status: .pending)
            
            FunctionsForCoreData.shared.addTodoData(task: task)
            
            self.titleTextField.text = ""
            self.descriptionTextField.text = ""
        }
    }
    
    private func priority(for index: Int) -> todopriority {
        switch index {
        case 0:
            return .low
        case 1:
            return .medium
        case 2:
            return .high
        default:
            return .low
        }
    }
    
    private func presentAlert() {
        let alertController = UIAlertController(title: "Error", message: "Unknown error encountered", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "ok", style: .default))
        self.present(alertController, animated: true)
    }
}
