import SwiftUI

@main
struct BreadPartnersTestApp: App {
    @StateObject private var model = BreadPartnersTestAppVewModel()

    var body: some Scene {
        WindowGroup {
            if !model.isSetupComplete {
                ProgressView("Setting up...")
                    .progressViewStyle(CircularProgressViewStyle())
            } else {
                FormView()
            }
        }
    }
}
