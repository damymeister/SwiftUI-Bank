//
//  ThirdView.swift
//  projekt
//
//  Created by student on 06/06/2023.
//
import SwiftUI

struct LoginView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \User.name, ascending: true)],
        animation: .default)
    private var users: FetchedResults<User>
    
    @State private var username = ""
    @State private var password = ""
    @State private var isPresentingRegisterView = false
    @State private var isPresentingMenuView = false
    @State private var showInvalidCredentialsAlert = false
    @State private var isUserLogged = false
    @State private var userName = ""
    var body: some View {
        NavigationView {
            VStack {
                if isPresentingMenuView {
                    menuView(isUserLogged: $isUserLogged, userName: $userName)
                        .transition(.opacity)
                } else {
                    Text("Login")
                        .font(.system(size: 48))
                    
                    TextField("Username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        for user in users {
                            if user.name == username && user.password == password {
                                self.isPresentingRegisterView = false
                                self.isPresentingMenuView = true
                                self.isUserLogged = true
                                self.userName = username
                                return
                            }
                        }
                        self.isPresentingRegisterView = false
                        self.showInvalidCredentialsAlert = true
                    }) {
                        Text("Login")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .background(Color.blue)
                            .cornerRadius(8.0)
                    }
                    
                    Button(action: {
                        self.isPresentingRegisterView.toggle()
                    }) {
                        Text("Don't have an account? Register here.")
                            .foregroundColor(Color.blue)
                    }
                }
            }
            .padding()
            .alert(isPresented: $showInvalidCredentialsAlert) {
                Alert(
                    title: Text("Invalid Credentials"),
                    message: Text("Please check your username and password and try again."),
                    dismissButton: .default(Text("OK"))
                )
            }
            .fullScreenCover(isPresented: $isPresentingRegisterView) {
                RegisterView()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
