import Foundation

class ParseApi {
    static let shared = ParseApi()
    private init() {}

    func isValidCredentials(email: String, password: String, completion: @escaping (Bool) -> Void) {

        if(email.isEmpty || password.isEmpty){
            completion(false)
            return
        }

        guard let url = URL(string: "https://api.timmerdorp.com/1/login") else {
            print("Invalid URL")
            completion(false)
            return
        }

        guard let infoDictionary: [String: Any] = Bundle.main.infoDictionary else { 
            completion(false)
            return
        }
        guard let ParseAppId: String = infoDictionary["ParseAppId"] as? String else { 
            completion(false)
            return
        }
        guard let ParseJsKey: String = infoDictionary["ParseJsKey"] as? String else { 
            completion(false)
            return
        }

        let jsonBody: [String: Any] = [
            "username": email,
            "password": password
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonBody)

            // Create the request
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue(ParseAppId, forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue(ParseJsKey, forHTTPHeaderField: "X-Parse-Javascript-Key")

            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    completion(false)
                }
                    
                // Check if a response was received
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("No HTTP response")
                    completion(false)
                    return
                }

                // Check the status code in the response
                if httpResponse.statusCode == 200 {
                    // Successful request, handle the response data
                    if let responseData = data {
                        // Process the responseData as needed
                        completion(true)

                        print("Response Data: \(String(data: responseData, encoding: .utf8) ?? "")")
                    } else {
                        print("No response data")
                        completion(false)

                    }
                } else {
                    // Handle other status codes (e.g., error responses)
                    print("HTTP Status Code: \(httpResponse.statusCode)")
                    completion(false)
                }

            }
            task.resume()

        } catch {
            print("JSON Serialization Error: \(error.localizedDescription)")
            completion(false)
        }
    }
}
