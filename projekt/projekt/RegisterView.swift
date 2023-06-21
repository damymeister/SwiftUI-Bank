//
//  RegisterView.swift
//  projekt
//
//  Created by student on 06/06/2023.
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @Environment(\.presentationMode) var presentationMode
    @State private var username = ""
    @State private var password = ""
    @State private var usernameValidate = ""
    @State private var passwordValidate = ""
    @State private var showAlert = false
    
    private var isUsernameValid: Bool {
        return username.count >= 6
    }
    
    private var isPasswordValid: Bool {
        let passwordRegex = "(?=.*[A-Z])(?=.*[0-9]).{7,}"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
    
    private func addUser() {
        let newUser = User(context: viewContext)
        newUser.name = username
        newUser.password = password
        
        do {
            try viewContext.save()
            showAlert = true
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    var body: some View {
        VStack() {
Spacer()
            Text("Register")
                .font(.system(size: 48))
            
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            if usernameValidate != "" {
                Text(usernameValidate)
                    .foregroundColor(.red)
            }
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            if passwordValidate != "" {
                Text(passwordValidate)
                    .foregroundColor(.red)
            }

            Button(action: {
                if isUsernameValid && isPasswordValid {
                    usernameValidate = ""
                    passwordValidate = ""
                    addUser()
                } else if !isUsernameValid {
                    usernameValidate = "Your Username must include at least 6 characters."
                } else if !isPasswordValid {
                    passwordValidate = "Your password must include at least 7 characters, one digit and one capital letter."
                }
            }) {
                Text("Register")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .background(Color.green)
                    .cornerRadius(8.0)
                    .padding()
            }
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Back")
                    .foregroundColor(Color.blue)
            }
            .padding()
            
            Spacer()
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Registered"),
                message: Text("You have been registered successfully."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}

