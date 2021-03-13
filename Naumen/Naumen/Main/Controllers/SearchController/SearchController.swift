import UIKit

class SearchController: UISearchController {
    
    public static let shared = SearchController(searchResultsController: nil)
    
    override init(searchResultsController: UIViewController?) {
        super.init(searchResultsController: searchResultsController)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        searchBar.placeholder = "Search"
    }
}
