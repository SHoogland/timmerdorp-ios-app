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
                    // Handle login logic here
                    // You can check the email and password entered by the user
                    // against your authentication system or any other logic.
                    
                    // Example:
                    if isValidCredentials(email: email, password: password) {
                        // Successful login
                        print("Login attempted!")
                    } else {
                        // Failed login
                        print("Invalid email or password")
                    }
                }
                .padding()
                
                NavigationLink(destination: WelcomeView(), isActive: $isLoginSuccessful) {
                    EmptyView()
                }
                
            }
            .padding()
            .navigationTitle("Timmerdorp")
        }
    }

    func isValidCredentials(email: String, password: String) -> Bool {
        
        if(email.isEmpty || password.isEmpty){
            return false
        }
        
        guard let url = URL(string: "https://api.timmerdorp.com/1/login") else {
            print("Invalid URL")
            return false
        }

        guard let infoDictionary: [String: Any] = Bundle.main.infoDictionary else { return false }
        guard let ParseAppId: String = infoDictionary["ParseAppId"] as? String else { return false }
        guard let ParseJsKey: String = infoDictionary["ParseJsKey"] as? String else { return false }
        
        let jsonBody: [String: Any] = [
            "username": email,
            "password": password
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonBody)

            // Create the request
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            // Add any additional headers if needed
            
            request.setValue(ParseAppId, forHTTPHeaderField: "X-Parse-Application-Id")
            request.setValue(ParseJsKey, forHTTPHeaderField: "X-Parse-Javascript-Key")
            request.setValue("1", forHTTPHeaderField: "X-Parse-Revocable-Session")

            // Attach the JSON data to the request body
            request.httpBody = jsonData

            // Make the request using URLSession
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                // Check for errors
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }

                // Check if a response was received
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("No HTTP response")
                    return
                }

                // Check the status code in the response
                if httpResponse.statusCode == 200 {
                    // Successful request, handle the response data
                    if let responseData = data {
                        // Process the responseData as needed
                        isLoginSuccessful = true

                        print("Response Data: \(String(data: responseData, encoding: .utf8) ?? "")")
                    } else {
                        print("No response data")
                    }
                } else {
                    // Handle other status codes (e.g., error responses)
                    print("HTTP Status Code: \(httpResponse.statusCode)")
                }
            }

            // Start the URLSession task
            task.resume()
            
            return true
        } catch {
            // Handle JSON serialization error
            print("JSON Serialization Error: \(error.localizedDescription)")
            return false
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
