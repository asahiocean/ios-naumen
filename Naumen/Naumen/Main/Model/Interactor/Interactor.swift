import Foundation

class Interactor {
    
    public static let shared = Interactor()
    
    private var storage: Storage = .shared
    
    private(set) var pageCount: Int = 0
    
    func loadImage(url: String, _ completion: @escaping (Data?) -> ()) {
        let request = URLRequest(url: URL(string: url)!)
        API.load(of: request, with: { data in
            do {
                guard let data = try data.get() else { return }
                completion(data)
            } catch {
                completion(nil)
            }
        })
    }
    
    fileprivate func loadInfo(list: Computers) {
        list.items?.forEach({ item in
            guard let id = item.id else { return }
            let info = Host.info(id: id).urlRequest
            API.load(of: info, with: { data in
                do {
                    guard let data = try data.get() else { return }
                    Model.parser(with: data, { [self] (info: Result<Info,Error>) in
                        do {
                            let list = try info.get()
                            storage.info[id] = list
                        } catch {
                            print("❗️INFO_ERROR ->", error.localizedDescription)
                        }
                    })
                } catch {
                    print("❗️ERROR_LOADING_LIST_ITEM ->", error.localizedDescription)
                }
            })
        })
    }
    
    func similar(id: Int, _ completion: @escaping (Similars) -> Void) {
        let url = Host.similar(id: id)
        
        API.load(of: url.urlRequest, with: { data in
            do {
                guard let data = try data.get() else { return }
                Model.parser(with: data, { (list: Result<Similars,Error>) in
                    do {
                        let list = try list.get()
                        completion(list)
                    } catch {
                        print("❗️ERROR_CONVERSION_TO_LIST_MODEL ->", error.localizedDescription)
                    }
                })
            } catch {
                print("❗️ERROR_LOADING_LIST ->", error.localizedDescription)
            }
        })
    }
    
    func fetchPage() {
        let page = Host.page(n: pageCount)
        self.pageCount += 1
        
        API.load(of: page.urlRequest, with: { data in
            do {
                guard let data = try data.get() else { return }
                Model.parser(with: data, { [self] (list: Result<Computers,Error>) in
                    do {
                        let list = try list.get()
                        storage.listSet(from: list)
                        loadInfo(list: list)
                    } catch {
                        print("❗️ERROR_CONVERSION_TO_LIST_MODEL ->", error.localizedDescription)
                    }
                })
            } catch {
                print("❗️ERROR_LOADING_LIST ->", error.localizedDescription)
            }
        })
    }
    
    fileprivate init() {
        
    }
}
