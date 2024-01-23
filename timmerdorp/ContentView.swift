//
//  ContentView.swift
//  timmerdorp
//
//  Created by Stephan Hoogland on 21/01/2024.
//

import SwiftUI
import SwiftData
import Foundation

struct ContentView: View {
//    @Environment(\.modelContext) private var modelContext
//    @Query private var items: [Item]

    @State private var email = ""
    @State private var password = ""
    @State private var isLoginSuccessful = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            VStack {
                TextField("Email", text: $email)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .textContentType(.emailAddress)
                
                SecureField("Password", text: $password)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textContentType(.password)    

                    Button("Login") {
                        ParseApi.shared.isValidCredentials(email: email, password: password) { isValid in
                            if isValid {
                                print("Valid credentials")
                                alertMessage = "Valid credentials"
                            } else {
                                print("Invalid credentials")
                                alertMessage = "Invalid credentials"
                            }
                            showAlert = true
                        }
                    }
                    .padding()
                
            }
            .padding()
            .navigationTitle("Timmerdorp")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Login Result"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

// template ios
//    var body: some View {
//        NavigationSplitView {
//            List {
//                ForEach(items) { item in
//                    NavigationLink {
//                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
//                    } label: {
//                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
//                    }
//                }
//                .onDelete(perform: deleteItems)
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
//            }
//        } detail: {
//            Text("Select an item")
//        }
//    }
//
//    private func addItem() {
//        withAnimation {
//            let newItem = Item(timestamp: Date())
//            modelContext.insert(newItem)
//        }
//    }
//
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            for index in offsets {
//                modelContext.delete(items[index])
//            }
//        }
//    }
}

struct WelcomeView: View {
    var body: some View {
        Text("Welcome!")
            .navigationTitle("Welcome")
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
