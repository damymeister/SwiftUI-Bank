

import SwiftUI
import CoreData
struct BalanceView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Account.user, ascending: true)], animation: .default)
    var accounts: FetchedResults<Account>

    @Binding var userName: String

    var body: some View {
        VStack {
            if let filteredAccounts = filteredAccounts() {
                List {
                    Text("User: \(userName)")
                    ForEach(filteredAccounts, id: \.self) { account in
                        Group {
                            VStack {
                                Text("Currency: \(account.currency ?? "")")
                                Text("Amount: \(String(format: "%.2f", account.amount))")
                            }
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                        }
                    }
                }
            } else {
                Text("No accounts found")
            }
        }
        .onAppear {
            viewContext.perform {
                try? viewContext.save()
            }
        }
    }

    private func filteredAccounts() -> [Account]? {
        return Array(accounts.filter { $0.user == userName })
    }
}
