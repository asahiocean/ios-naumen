import UIKit

class ViewController: UIViewController, VCPresenterDelegate {
    
    func show(vc info: UIViewController) {
        self.navigationController?.pushViewController(info, animated: true)
    }
    
    var tableView: TableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Catalog"
        Interactor.shared.fetchPage()
        
        tableView = .init(frame: view.frame, style: .plain)
        tableView.presenter = self
        
        navigationItem.searchController = tableView.searchController
        self.view.addSubview(tableView)
    }
}
