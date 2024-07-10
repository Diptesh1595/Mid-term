
import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var todoTitle: UILabel!
    @IBOutlet weak var todoDescription: UILabel!
    @IBOutlet weak var todosubtitle: UILabel!
    @IBOutlet weak var todostatus: UILabel!
    
    var todo: Todo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.todoTitle.text = todo?.title
        self.todoDescription.text = todo?.description
        self.todostatus.text = todo?.status.rawValue ?? ""
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        
        if let completedate = todo?.dueDate {
            let dateString = formatter.string(from: completedate)
            self.todosubtitle.text = "Last date to complete this task is \(dateString)"
        }
    }
}
