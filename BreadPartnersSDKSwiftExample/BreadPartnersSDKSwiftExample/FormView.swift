import BreadPartnersSDKSwift
import SwiftUI

struct FormView: View {
    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            ?? "Unknown"
    }

    var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
    }
    var body: some View {
        NavigationView {
            TabView {
                PlacementFormView().tabItem {
                    Image(systemName: "house.fill")
                    Text("Placement")
                }
                RTPSFormView().tabItem {
                    Image(systemName: "cart.fill")
                    Text("RTPS")
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    VStack(alignment: .leading) {
                        Text("Bread Partners Swift Package Manager Example")
                            .font(.subheadline)
                            .bold().padding(.top, 8)
                        Text("App Version: v\(appVersion) (\(buildNumber))")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }

}
