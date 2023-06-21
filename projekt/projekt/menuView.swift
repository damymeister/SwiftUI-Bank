
//  menuView.swift
//  projekt
//
//  Created by student on 06/06/2023.
//
import SwiftUI

struct menuView: View {
    @GestureState var isLongPress = false
    @State private var showInfoAlert = false
    @State private var shouldNavigateToKantor = false
    @State private var shouldNavigateToMap = false
    @State private var shouldNavigateToLogin = false
    @State private var shouldNavigateToBalance = false
    @State private var xOffset: CGFloat = 0
    @State private var firstItemOffset: CGFloat = 0
    @State private var secondItemOffset: CGFloat = 0
    @State private var thirdItemOffset: CGFloat = 0
    @State private var fourthItemOffset: CGFloat = 0
    @Binding var isUserLogged : Bool
    @Binding var userName : String
    var body: some View {
        let longPress = LongPressGesture()
            .updating($isLongPress) { value, state, transaction in
                state = value
            }
            .onEnded { _ in
                showInfoAlert = true
                }
        
        NavigationView {
            VStack {
                ZStack(alignment: .center) {
                    Image("bg")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                    HStack {
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("FancyBank")
                                .foregroundColor(.white)
                                .font(.title)
                                .multilineTextAlignment(.center)
                                .textCase(.uppercase)
                        }
                        Spacer()
                    }
                    .background(Color.black.opacity(0.5))
                }
                List {
                    Text("About us")
                        .multilineTextAlignment(.center)
                        .gesture(longPress)
                        .listRowBackground(isLongPress ? Color.gray.opacity(0.5) : Color.clear)
                    Text("Add money/Withdraw")
                        .listRowBackground(Color.clear)
                        .gesture(DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
                            .onChanged { value in
                                let dragOffset = value.translation.width
                                let totalOffset = firstItemOffset + dragOffset
                                firstItemOffset = min(max(totalOffset, -100), UIScreen.main.bounds.width)
                            }
                            .onEnded { value in
                                if value.translation.width > 100 {
                                    shouldNavigateToKantor = true
                                    firstItemOffset = 0
                                } else {
                                    firstItemOffset = 0
                                }
                            }
                        )
                        .offset(x: firstItemOffset)
                        .animation(.default)
                    Text("See account balance")
                        .listRowBackground(Color.clear)
                        .gesture(DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
                            .onChanged { value in
                                let dragOffset = value.translation.width
                                let totalOffset = fourthItemOffset + dragOffset
                                fourthItemOffset = min(max(totalOffset, -100), UIScreen.main.bounds.width)
                            }
                            .onEnded { value in
                                if value.translation.width > 100 {
                                    shouldNavigateToBalance = true
                                    fourthItemOffset = 0
                                } else {
                                    fourthItemOffset = 0
                                }
                            }
                        )
                        .offset(x: fourthItemOffset)
                        .animation(.default)
                    
                    Text("Map")
                        .listRowBackground(Color.clear)
                        .gesture(DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
                            .onChanged { value in
                                let dragOffset = value.translation.width
                                let totalOffset = secondItemOffset + dragOffset
                                secondItemOffset = min(max(totalOffset, -100), UIScreen.main.bounds.width)
                            }
                            .onEnded { value in
                                if value.translation.width > 100 {
                                    shouldNavigateToMap = true
                                    secondItemOffset = 0
                                } else {
                                    secondItemOffset = 0
                                }
                            }
                        )
                        .offset(x: secondItemOffset)
                        .animation(.default)
                    Text("Logout")
                        .listRowBackground(Color.clear)
                        .gesture(DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
                            .onChanged { value in
                                let dragOffset = value.translation.width
                                let totalOffset = thirdItemOffset + dragOffset
                                thirdItemOffset = min(max(totalOffset, -100), UIScreen.main.bounds.width)
                            }
                            .onEnded { value in
                                if value.translation.width > 100 {
                                    shouldNavigateToLogin = true
                                    isUserLogged = false
                                    userName = ""
                                    thirdItemOffset = 0
                                } else {
                                    thirdItemOffset = 0
                                }
                            }
                        )
                        .offset(x: thirdItemOffset)
                        .animation(.default)
                }
                Spacer()
            }
        }
        .alert(isPresented: $showInfoAlert) {
            Alert(
                title: Text("FancyBank"),
                message: Text("Welcome to our bank office, where we provide exchange services and offer professional advice in this field. Our office is a place where we will gladly assist you in safely and quickly exchanging currencies at current rates. We are a team of experienced experts who have a deep understanding of the foreign exchange markets and monitor their fluctuations."),
                dismissButton: .default(Text("OK")) {
                    showInfoAlert = false
                }
            )
        }
        .background(
                   Group {
                       if shouldNavigateToKantor {
                           NavigationLink(destination: AddValue(userName: $userName), isActive: $shouldNavigateToKantor) {
                               EmptyView()
                           }
                       }
                       if shouldNavigateToBalance{
                           NavigationLink(destination: BalanceView(userName: $userName), isActive: $shouldNavigateToBalance) {
                               EmptyView()
                           }
                       }
                       if shouldNavigateToMap {
                           NavigationLink(destination: MapView(), isActive: $shouldNavigateToMap) {
                               EmptyView()
                           }
                       }
                       if shouldNavigateToLogin {
                           NavigationLink(destination: LoginView().navigationBarHidden(true), isActive: $shouldNavigateToLogin) {
                               EmptyView()
                           }
                       }
                   }
               )
           }
       }


struct menuView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            menuView(isUserLogged: .constant(true), userName: .constant(""))
             }
    }
}
