
import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var ascendingSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSwitch()
    }
    
    private func addSwitch() {
        ascendingSwitch.addTarget(self, action: #selector(switchOnOff), for: .valueChanged)
    }
    
    @objc func switchOnOff(_ sender: UISwitch) {
        isAscending.toggle()
    }
    
    @IBAction func filterChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            filterType = .low
        case 1:
            filterType = .medium
        case 2:
            filterType = .high
        case 3:
            filterType = .all
        default:
            return
        }
    }
}
