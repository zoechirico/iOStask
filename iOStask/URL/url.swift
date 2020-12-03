//
//  url.swift
//  iOStask
//
//  Created by Mike Chirico on 12/2/20.
//

import UIKit

struct Session {
    var url: String
    
    func Get(completion: @escaping  (_ result: String)  -> Void, onFailure: () -> Void)  {
        let configuraion = URLSessionConfiguration.default
        configuraion.httpAdditionalHeaders = ["Authorization" : "tacoMouse_iOSurl"]

        let session = URLSession(configuration: configuraion)
        
        guard let _url = URL(string: url) else { fatalError()}

        let task = session.dataTask(with: _url) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                return
            }
            guard let data = data else {
                return
            }
            if let result = String(data: data, encoding:. utf8) {
                print(result)
                completion(result)
            }
        }
        task.resume()
    }
    
    
}
