import Vapor
import AuthProvider

struct LoginRedirectMiddleware: Middleware {
    func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        guard request.auth.isAuthenticated(User.self) else {
            return Response(redirect: "/login")
        }
        
        return try next.respond(to: request)
    }
}
