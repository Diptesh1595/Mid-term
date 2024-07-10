
import Foundation
import CoreData
import UIKit

class FunctionsForCoreData {
    
    static let shared = FunctionsForCoreData()
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    func addTodoData(task: Todo) {
        if let managedContext = appDelegate?.persistentContainer.viewContext {
            
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "TodoItem")
            fetchRequest.predicate = NSPredicate(format: "title = %@", task.title)
            
            do {
                let result = try managedContext.fetch(fetchRequest)
                
                if let result = result as? [NSManagedObject],
                   let fetchedTitle = result.first?.value(forKey: "title") as? String, fetchedTitle == task.title {
                    result[0].setValue(task.status == .pending ? false : true, forKey: "status")
                } else {
                    let entity = NSEntityDescription.entity(forEntityName: "TodoItem", in: managedContext)!
                    
                    let data = NSManagedObject(entity: entity, insertInto: managedContext)
                    data.setValue(task.title, forKey: "title")
                    data.setValue(task.status == .pending ? false : true, forKey: "status")
                    data.setValue(task.description, forKey: "taskDescription")
                    data.setValue(task.priority.rawValue, forKey: "priority")
                    data.setValue(task.dueDate, forKey: "due")
                }
                
                try managedContext.save()
                
            } catch let error as NSError {
                print(error)
            }
        } else {
            print("error")
        }
    }
    
    func getTodoData() -> [Todo] {
        
        if let managedContext = appDelegate?.persistentContainer.viewContext {
            
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TodoItem")
            
            do {
                let tasks = try managedContext.fetch(fetchRequest)
                
                var taskItems: [Todo] = []
                
                for task in tasks {
                    let title = task.value(forKey: "title") as? String ?? ""
                    let description = task.value(forKey: "taskDescription") as? String ?? ""
                    let dueDate = task.value(forKey: "due") as? Date ?? Date()
                    
                    var priority: todopriority?
                    
                   
                    if (task.value(forKey: "priority") as? String) ?? "" == "Low" {
                        priority = .low
                    } else if (task.value(forKey: "priority") as? String) ?? "" == "Medium" {
                        priority = .medium
                    } else {
                        priority = .high
                    }
                    
                    let status = task.value(forKey: "status") as? Bool == true ? status.completed : status.pending
                    
                    let item = Todo(title: title, description: description, dueDate: dueDate, priority: priority!, status: status)
                    
                    taskItems.append(item)
                }
                
                return taskItems
            } catch let error as NSError {
                print(error)
            }
        }
        return []
    }
    
    func deleteTodoItem(todoItem: Todo) {
        if let managedContext = appDelegate?.persistentContainer.viewContext {
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "TodoItem")
            fetchRequest.predicate = NSPredicate(format: "title = %@", todoItem.title)
            
            do {
                let result = try managedContext.fetch(fetchRequest)
                if let result = result as? [NSManagedObject], let entity = result.first {
                    managedContext.delete(entity)
                }
                
                try managedContext.save()
            } catch let error as NSError {
                print(error)
            }
        }
    }
}
