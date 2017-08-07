import FluentProvider
import LeafProvider
import AuthProvider
import Sessions

extension Config {
    public func setup() throws {
        // allow fuzzy conversions for these types
        // (add your own types here)
        Node.fuzzy = [Row.self, JSON.self, Node.self]

        try setupProviders()
        try setupPreparations()
        
        addConfigurable(middleware: SessionsMiddleware.init, name: "sessions")
        addConfigurable(middleware: PersistMiddleware.init(User.self), name: "persist")
    }
    
    /// Configure providers
    private func setupProviders() throws {
        try addProvider(FluentProvider.Provider.self)
        try addProvider(LeafProvider.Provider.self)
    }
    
    /// Add all models that should have their
    /// schemas prepared before the app boots
    private func setupPreparations() throws {
        preparations.append(Reminder.self)
        preparations.append(User.self)
        preparations.append(UserSeed.self)
    }
}
