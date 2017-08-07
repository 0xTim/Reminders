import Vapor
import LeafProvider
import AuthProvider

struct ReminderWebController {
    
    let drop: Droplet
    
    func addRoutes() {
        drop.get(handler: indexHandler)
        drop.get("reminder", Reminder.parameter, handler: reminderHandler)
        drop.get("login", handler: loginHandler)
        drop.post("login", handler: loginPostHandler)
        
        let redirectMiddleware = LoginRedirectMiddleware()
        let protected = drop.grouped(redirectMiddleware)
        protected.get("create", handler: createHandler)
        protected.post("create", handler: createPostHandler)
    }
    
    func indexHandler(_ req: Request) throws -> ResponseRepresentable {
        return try drop.view.make("index", [
            "reminders": try Reminder.all()
            ])
    }
    
    func reminderHandler(_ req: Request) throws -> ResponseRepresentable {
        let reminder = try req.parameters.next(Reminder.self)
        return try drop.view.make("reminder", ["reminder": reminder])
    }
    
    func createHandler(_ req: Request) throws -> ResponseRepresentable {
        return try drop.view.make("create")
    }
    
    func createPostHandler(_ req: Request) throws -> ResponseRepresentable {
        guard let title = req.data["title"]?.string, let description = req.data["description"]?.string else {
            throw Abort.badRequest
        }
        
        let reminder = Reminder(title: title, description: description)
        try reminder.save()
        return Response(redirect: "/reminder/\(reminder.id?.string ?? "NIL")")
    }
    
    func loginHandler(_ req: Request) throws -> ResponseRepresentable {
        return try drop.view.make("login")
    }
    
    func loginPostHandler(_ req: Request) throws -> ResponseRepresentable {
        guard let username = req.data["username"]?.string, let password = req.data["password"]?.string else {
            throw Abort.badRequest
        }
        
        let credentials = Password(username: username, password: password)
        
        do {
            let user = try User.authenticate(credentials)
            req.auth.authenticate(user)
        } catch {
            return try drop.view.make("login")
        }
        
        return Response(redirect: "/")
    }
}
