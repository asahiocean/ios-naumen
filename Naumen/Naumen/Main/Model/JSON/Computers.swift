import Foundation
import Gloss

// MARK: - Computers

struct Computers: JSONDecodable, Decodable {
    var items: [Item]?
    var page, offset, total: Int?
    
    init?(json: JSON) {
        self.items = "items" <~~ json
        self.page = "page" <~~ json
        self.offset = "offset" <~~ json
        self.total = "total" <~~ json
    }
    
    private enum CodingKeys: String, CodingKey {
        case items = "items"
        case page = "page"
        case offset = "offset"
        case total = "total"
    }
    
    init(from decoder: Swift.Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        items = try values.decodeIfPresent([Item].self, forKey: .items)
        page = try values.decodeIfPresent(Int.self, forKey: .page)
        offset = try values.decodeIfPresent(Int.self, forKey: .offset)
        total = try values.decodeIfPresent(Int.self, forKey: .total)
    }
}

// MARK: - Similars

typealias Similars = [Similar]

struct Similar: JSONDecodable, Decodable {
    let id: Int?
    let name: String?
    
    init?(json: JSON) {
        self.id = "id" <~~ json
        self.name = "name" <~~ json
    }
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
    
    init(from decoder: Swift.Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }
}

// MARK: - Item

struct Item: JSONDecodable, Decodable {
    let id: Int?
    let name: String?
    let company: Company?
    
    init?(json: JSON) {
        self.id = "id" <~~ json
        self.name = "name" <~~ json
        self.company = "company" <~~ json
    }
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case company = "company"
    }
    
    init(from decoder: Swift.Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        company = try values.decodeIfPresent(Company.self, forKey: .company)
    }
}

// MARK: - Company

struct Company: JSONDecodable, Decodable {
    let id: Int?
    let name: String?
    
    init?(json: JSON) {
        self.id = "id" <~~ json
        self.name = "name" <~~ json
    }
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
    
    init(from decoder: Swift.Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }
}

// MARK: - Info

struct Info: JSONDecodable, Decodable {
    
    let id: Int?
    let name: String?
    let introduced: String?
    let discounted: String?
    let imageURL: String?
    let company: Company?
    let description: String?
    
    init?(json: JSON) {
        self.id = "id" <~~ json
        self.name = "name" <~~ json
        self.introduced = "introduced" <~~ json
        self.discounted = "discounted" <~~ json
        self.imageURL = "imageUrl" <~~ json
        self.company = "company" <~~ json
        self.description = "description" <~~ json
    }
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case introduced = "introduced"
        case company = "company"
        case discounted = "discounted"
        case imageURL = "imageUrl"
        case description = "description"
    }
    
    init(from decoder: Swift.Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        introduced = try values.decodeIfPresent(String.self, forKey: .introduced)
        discounted = try values.decodeIfPresent(String.self, forKey: .discounted)
        imageURL = try values.decodeIfPresent(String.self, forKey: .imageURL)
        company = try values.decodeIfPresent(Company.self, forKey: .company)
        description = try values.decodeIfPresent(String.self, forKey: .description)
    }
}
