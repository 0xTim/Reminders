import Vapor
import FluentProvider

struct ReminderController {
    func addRoutes(drop: Droplet) {
        let reminderGroup = drop.grouped("api", "reminders")
        
        reminderGroup.get(handler: allReminders)
        reminderGroup.post("create", handler: createReminder)
        reminderGroup.get(Reminder.parameter, handler: getReminder)
        
    }
    
    func allReminders(_ req: Request) throws -> ResponseRepresentable {
        let reminders = try Reminder.all()
        return try reminders.makeJSON()
    }
    
    func createReminder(_ req: Request) throws -> ResponseRepresentable {
        let reminder = try req.reminder()
        try reminder.save()
        return reminder
    }
    
    func getReminder(_ req: Request) throws -> ResponseRepresentable {
        let reminder = try req.parameters.next(Reminder.self)
        return reminder
    }
}

extension Request {
    func reminder() throws -> Reminder {
        guard let json = json else {
            throw Abort.badRequest
        }
        
        return try Reminder(json: json)
    }
}
