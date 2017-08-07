import FluentProvider
import AuthProvider

final class User: Model {
    
    let storage = Storage()
    let username: String
    let password: Bytes
    
    init(row: Row) throws {
        username = try row.get("username")
        let passwordString: String = try row.get("password")
        password = passwordString.makeBytes()
    }
    
    init(username: String, password: Bytes) {
        self.username = username
        self.password = password
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("username", username)
        try row.set("password", password.makeString())
        return row
    }
}

extension User: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string("username")
            builder.string("password")
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension User: PasswordAuthenticatable {
    static let usernameKey = "username"
    static let passwordVerifier: PasswordVerifier? = User.passwordHasher
    var hashedPassword: String? {
        return password.makeString()
    }
    static var passwordHasher: PasswordHasherVerifier = BCryptHasher(cost: 10)
}

protocol PasswordHasherVerifier: PasswordVerifier, HashProtocol {}

extension BCryptHasher: PasswordHasherVerifier {}

extension User: SessionPersistable {}

struct UserSeed: Preparation {
    
    static func prepare(_ database: Database) throws {
        let password = try User.passwordHasher.make("tim")
        let user = User(username: "tim", password: password)
        try user.save()
    }
    
    static func revert(_ database: Database) throws {}
}
