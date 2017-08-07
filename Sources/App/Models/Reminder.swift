import Vapor
import FluentProvider

final class Reminder: Model {
    let storage = Storage()
    
    let title: String
    let description: String
    
    init(title: String, description: String) {
        self.title = title
        self.description = description
    }
    
    init(row: Row) throws {
        title = try row.get("title")
        description = try row.get("description")
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("title", title)
        try row.set("description", description)
        return row
    }
}

extension Reminder: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string("title")
            builder.string("description")
        }
    }
    
    static func revert(_ database: Database) throws {
        
    }
}

extension Reminder: JSONRepresentable {
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("title", title)
        try json.set("description", description)
        try json.set("id", id)
        return json
    }
}

extension Reminder: JSONInitializable {
    convenience init(json: JSON) throws {
        try self.init(title: json.get("title"), description: json.get("description"))
    }
}

extension Reminder: NodeRepresentable {
    func makeNode(in context: Context?) throws -> Node {
        var node = Node([:], in: nil)
        try node.set("title", title)
        try node.set("description", description)
        try node.set("id", id)
        return node
    }
}

extension Reminder: ResponseRepresentable {}
