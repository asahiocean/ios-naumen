import Foundation
import Gloss

protocol Parser {
    static func parser<T: Decodable & JSONDecodable>(with data: Data, _ completion: @escaping (Result<T,Error>)->())
}

struct Model: Parser {
    static func parser<T: Decodable & JSONDecodable>(with data: Data, _ completion: @escaping (Result<T, Error>) -> ()) {
        let logger: Logger = GlossLogger()
        let serializer = GlossJSONSerializer()
        if let model = T(data: data, serializer: serializer, options: .mutableContainers) {
            completion(.success(model))
        } else {
            do {
                guard let model = try JSONDecoder().decode(T?.self, from: data) else { return }
                completion(.success(model))
            } catch {
                logger.log(message: "Swift.Decodable error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    fileprivate init() { }
}

extension Model {
    static func parser<T: Decodable & JSONDecodable>(with data: Data, _ completion: @escaping (Result<[T], Error>) -> ()) {
        do {
            guard let model = try JSONDecoder().decode([T]?.self, from: data) else { return }
            completion(.success(model))
        } catch {
            completion(.failure(error))
        }
    }
}
