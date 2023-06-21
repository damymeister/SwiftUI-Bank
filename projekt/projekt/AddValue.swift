import SwiftUI
import CoreData

struct AddValue: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Currency.name, ascending: true)], animation: .default)
    var currencies: FetchedResults<Currency>
    
    @State private var selectedCurrency = "PLN"
    @Binding var userName: String
    @State private var inputValue: String = ""
    @State private var outputValue: String = ""
    @State private var inputValueSubstraction: String = ""
    @State private var subtractionValue: String = ""
    @State private var isSaved: Bool = false
    @State private var errorMessage: String = ""
    
    private func saveCurrencies() {
        var currenciesTab: [Currency] = []
        let curr: [String] = ["PLN", "EUR", "USD", "GBP"]
        if currencies.count == 0 {
            for i in curr {
                let newCurrency = Currency(context: viewContext)
                newCurrency.name = i
                currenciesTab.append(newCurrency)
            }
        }
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func addToAccount() {
        guard let value = Float(outputValue) else {
            isSaved = false
            errorMessage = "Invalid value entered."
            return
        }
        
        let user = userName
        let currency = selectedCurrency
        let accountFetchRequest: NSFetchRequest<Account> = Account.fetchRequest()
        accountFetchRequest.predicate = NSPredicate(format: "user == %@ AND currency == %@", user, currency)
        
        do {
            let accounts = try viewContext.fetch(accountFetchRequest)
            
            if let account = accounts.first {
                account.amount += value
            } else {
                let newAccount = Account(context: viewContext)
                newAccount.amount = value
                newAccount.user = user
                newAccount.currency = currency
            }
            
            try viewContext.save()
            isSaved = true
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    private func subtractFromAccount() {
        guard let value = Float(subtractionValue) else {
            isSaved = false
            errorMessage = "Invalid value entered."
            return
        }
        
        let user = userName
        let currency = selectedCurrency
        let accountFetchRequest: NSFetchRequest<Account> = Account.fetchRequest()
        accountFetchRequest.predicate = NSPredicate(format: "user == %@ AND currency == %@", user, currency)
        
        do {
            let accounts = try viewContext.fetch(accountFetchRequest)
            
            if let account = accounts.first {
                let currentValue = account.amount
                
                if currentValue >= value {
                    account.amount -= value
                    try viewContext.save()
                    isSaved = true
                    errorMessage = ""
                } else {
                    isSaved = false
                    errorMessage = "You have less money than you expect."
                }
            } else {
                isSaved = false
                errorMessage = "You don't have enough funds in the selected currency."
            }
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    
    var body: some View {
        VStack {
            Text("Select Currency")
            Picker(selection: $selectedCurrency, label: Text("Selected currencies")) {
                ForEach(currencies, id: \.self) { currency in
                    Text(currency.name!)
                        .tag(currency.name!)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.blue)
                                .opacity(currency.name == selectedCurrency ? 1.0 : 0.3)
                        )
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            Text("Your choice: \(selectedCurrency)")
            
            TextField("Enter a value", text: $inputValue)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                outputValue = inputValue
                addToAccount()
            }) {
                Text("Add money")
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            TextField("Withdraw from account", text: $inputValueSubstraction)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                subtractionValue = inputValueSubstraction
                subtractFromAccount()
            }) {
                Text("Withdraw")
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            if isSaved {
                Text("Successfully saved to the database!")
                    .foregroundColor(.green)
                    .padding()
            } else if !isSaved && !outputValue.isEmpty {
                Text("Failed to save to the database.")
                    .foregroundColor(.red)
                    .padding()
            }
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.2))
        )
        .onAppear {
            saveCurrencies()
        }
    }
}

struct AddValue_Previews: PreviewProvider {
    static var previews: some View {
        AddValue(userName: .constant(""))
    }
}
