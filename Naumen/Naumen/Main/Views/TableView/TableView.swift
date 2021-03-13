import UIKit

class TableView: UITableView, ReloadDelegate {
    
    func updateTableView() {
        DispatchQueue.main.async { self.reloadData() }
    }
    
    weak var storage: Storage! = .shared
    weak var presenter: VCPresenterDelegate?
    
    private var searchText: String = ""
    weak var searchController: SearchController?
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.id)
        decelerationRate = .fast
        dataSource = self
        delegate = self
        
        rowHeight = frame.height / 10
        
        searchController = .shared
        searchController?.searchBar.delegate = self
        
        storage.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        print("didMoveToSuperview")
    }
}

extension TableView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        guard let items = storage.list?.items else { return }
        storage.list?.items = items.filter {
            $0.name?.range(of: searchText,
                           options: .caseInsensitive) != nil }
        if searchText == "" { storage.list = storage.backup }
        self.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        searchText.removeAll()
        reloadData()
    }
}

extension TableView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storage.list?.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.id, for: indexPath) as! TableViewCell
        if let item = storage.list?.items?[indexPath.row] { cell.config(with: item) }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard searchText.count == 0 else { return }
        if let count = storage.list?.items?.count, indexPath.row == count - 2 {
            Interactor.shared.fetchPage()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let infoVC = InfoVC()
        if let item = storage.list?.items?[indexPath.row], let id = item.id, let info = storage.info[id] {
            infoVC.config(with: info)
            presenter?.show(vc: infoVC)
        }
    }
}
