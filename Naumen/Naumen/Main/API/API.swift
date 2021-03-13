import Foundation
import Alamofire

protocol GETPOST {
    typealias ResultDataError = (Result<Data?,Error>) -> ()
    static func load(of request: URLRequest?, with completion: @escaping ResultDataError)
    static func post(to urlStr: String, with postbody: [String:Any], _ completion: ResultDataError?)
}

struct API: GETPOST {
    
    private static var storage: Storage = .shared
    static weak var delegate: URLSessionDelegate?
    
    static func load(of request: URLRequest?, with completion: @escaping ResultDataError) {
        guard let request = request else { fatalError("REQUEST NIL") }
        
        if let cached = storage.cache.cachedResponse(for: request) {
            completion(.success(cached.data))
        } else {
            switch request {
            case let req as URLRequestConvertible:
                AF.request(req).response(completionHandler: { resp in
                    if let error = resp.error {
                        completion(.failure(error))
                    } else if let data = resp.data {
                        if let response = resp.response {
                            let cachedResponse = CachedURLResponse(response: response, data: data, storagePolicy: .allowed)
                            storage.cache.storeCachedResponse(cachedResponse, for: request)
                        }
                        completion(.success(data))
                    }
                })
            default:
                fatalError("Unsupported request type!")
            }
        }
    }
    
    static func post(to urlStr: String, with postbody: [String : Any], _ completion: ResultDataError?) {
        
    }
    
    fileprivate init() {
        
    }
}
