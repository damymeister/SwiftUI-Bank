import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            NavigationView {
                LoginView()
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

