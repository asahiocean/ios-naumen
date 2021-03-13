import Foundation
import Alamofire

enum Host: URLRequestConvertible {
    
    /// ```
    /// https == 403
    /// ```
    static let baseURLString = "http://testwork.nsd.naumen.ru"
    
    case info(id: Int)
    case search(request: String)
    case similar(id: Int)
    case page(n: Int)
    
    // MARK: URLRequestConvertible
    
    fileprivate var path: String {
        switch self {
        case .info, .page, .search, .similar:
            return "/rest/computers"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let result: (path: String, parameters: Parameters?) = {
            switch self {
            case let .page(page):
                return (path, ["p": page])
            case let .info(id):
                return (path, ["/": id])
            case .search(let request):
                return (path, ["f": request])
            case .similar(let id):
                return (path, ["/": "\(id)/similar"])
            }
        }()
        
        let url = try Host.baseURLString.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(result.path))
        
        if let param = result.parameters?.first, param.key == "/" {
            urlRequest.url = urlRequest.url.flatMap( {
                URL(string: $0.absoluteString + "/\(param.value)")
            })
            return try URLEncoding.default.encode(urlRequest, with: nil)
        } else {
            return try URLEncoding.default.encode(urlRequest, with: result.parameters)
        }
    }
}
