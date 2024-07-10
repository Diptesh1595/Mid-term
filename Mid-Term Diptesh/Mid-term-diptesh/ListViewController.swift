
import UIKit

struct Todo {
    let title: String
    let description: String
    let dueDate: Date
    let priority: todopriority
    var status: status
}

enum todopriority: String {
    case all
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}

enum status: String {
    case all = "All"
    case pending = "Pending"
    case completed = "Completed"
}

var isAscending: Bool = true
var filterType: todopriority = .all
var filterByStatus: status = .all

func formate(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM-dd-yyyy"
    let dateString = formatter.string(from: date)
    return dateString
}

class ListViewController: UIViewController {

    @IBOutlet weak var taskListTableView: UITableView!
    @IBOutlet weak var prioritylabel: UILabel!
    
    var tasks: [Todo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchTaskData()
    }
    
    private func setupView() {
        self.title = "List"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupTable() {
        taskListTableView.delegate = self
        taskListTableView.dataSource = self
        taskListTableView.separatorStyle = .none
    }
    
    private func fetchTaskData() {
        
        tasks = []
        
        tasks.append(contentsOf: FunctionsForCoreData.shared.getTodoData())
        
        isAscending ? tasks.sort { $0.title < $1.title } : tasks.sort { $0.title > $1.title }
        
        filterData()
        
        DispatchQueue.main.async {
            self.taskListTableView.reloadData()
        }
        
        prioritylabel.text = "Current filter: \(filterType.rawValue)"
    }
    
    func filterData() {
        if filterType == .low {
            tasks = tasks.filter { $0.priority == .low }
        } else if filterType == .medium {
            tasks = tasks.filter { $0.priority == .medium }
        } else if filterType == .high {
            tasks = tasks.filter { $0.priority == .high }
        }
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ItemTableViewCell
        let task = tasks[indexPath.row]
        cell.labelTitle.text = task.title
        cell.labelDescription.text = task.description
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        let dateString = formatter.string(from: task.dueDate)
        cell.labelDate.text = dateString
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
        vc.todo = tasks[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = tasks.remove(at: indexPath.row)
            FunctionsForCoreData.shared.deleteTodoItem(todoItem: task)
            tableView.deleteRows(at: [indexPath], with: .fade)
            fetchTaskData()
        }
    }
}
