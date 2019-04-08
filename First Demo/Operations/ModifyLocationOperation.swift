import Foundation

class OperationWithFinnished: Operation {
    var currentState: Bool = false
    
    override var isFinished: Bool {
        get {
            return currentState
        }
        set (newAnswer) {
            willChangeValue(forKey: "isFinished")
            currentState = newAnswer
            didChangeValue(forKey: "isFinished")
        }
    }
}

class ModifyLocationOperation: OperationWithFinnished {
    
    var payload: [String: Any]
    
    init(data: [String: Any]) {
        self.payload = data
        super.init()
    }
    
    override func main() {
        if isCancelled {
            return
        }
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://ihh8zvixsc.execute-api.us-east-2.amazonaws.com/Location_0") as! URL)
        request.httpMethod = "POST"
        
        request.httpBody = try! JSONSerialization.data(withJSONObject:  self.payload, options: JSONSerialization.WritingOptions.init(rawValue: 0))
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let error = error {
                print("ERROR ModifyLocationOperation: \(error)")
            }
            self.isFinished = true
        }
        task.resume()
    }
}
