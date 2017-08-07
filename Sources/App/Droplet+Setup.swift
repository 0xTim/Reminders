@_exported import Vapor

extension Droplet {
    public func setup() throws {
        try setupRoutes()
        // Do any additional droplet setup
        let reminderController = ReminderController()
        reminderController.addRoutes(drop: self)
        let reminderWebController = ReminderWebController(drop: self)
        reminderWebController.addRoutes()
    }
}
