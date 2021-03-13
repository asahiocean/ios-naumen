import Foundation

protocol FeedManager {
    var list: Computers? { get }
    func listSet(from config: Computers)
}

protocol ReloadDelegate: class {
    func updateTableView()
}

class Storage: FeedManager {
    
    static let shared = Storage()
    weak var delegate: ReloadDelegate?
    
    let cache: URLCache
    
    private(set) var backup: Computers!
    public var list: Computers?
    public var info: [Int:Info]
    public var pics: [Int:Data]
    
    func listSet(from config: Computers) {
        if list == nil {
            list = config
        } else {
            guard let items = config.items else { return }
            list?.items?.append(contentsOf: items)
        }
        self.backup = list
        delegate?.updateTableView()
    }
    
    fileprivate init() {
        info = [:]
        pics = [:]
        cache = .init(memoryCapacity: 100.mb,
                      diskCapacity: 100.mb,
                      diskPath: "naumen")
    }
}
