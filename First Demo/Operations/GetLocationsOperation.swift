import Foundation

class GetLocationsOpearion: OperationWithFinnished {
    
    var data: [[String : AnyObject]] = []
    
    override func main() {
        print("started")
        let request = NSMutableURLRequest(url: NSURL(string: "https://ihh8zvixsc.execute-api.us-east-2.amazonaws.com/Location_0")! as URL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            do {
                self.data = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [[String : AnyObject]]
            }
            catch {
                print("ERROR GetLocationsOpearion: \(error)")
            }
            
            self.isFinished = true
        }
        task.resume()
    }
}
