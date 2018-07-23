//
//  Jokes.swift
//  Chuck-Norris-Facts
//
//  Created by Codenation10 on 09/07/2018.
//  Copyright © 2018 Codenation. All rights reserved.
//

import Foundation

struct Jokes {
    
    let joke: String
    
    enum SerialisationError:Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    // initaliser that accepts a JSON object
    private init(json:[String:Any]) throws {
        guard let joke = json["joke"] as? String else {throw SerialisationError.missing("joke is missing")}
        
        //initialise property
        //self.id = id
        self.joke = joke
    }
    
    //url to access jokes
    private static let basePath = "https://api.icndb.com/jokes/random/"
    
    //function to get information from the api
    static func ChuckNorrisJoke(neverEnding: Bool, caseURL: String, completion: @escaping([Jokes]) -> ()) {
        
        let url = basePath + caseURL
        
        let request = URLRequest(url: URL(string: url)!)
        // data task
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            
            var jokesArray:[Jokes] = []
            
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        // if more than one is request they will need to be passed to as array of dictionaries
                        if neverEnding == true {
                            if let jokeValue = json["value"] as? [[String:Any]] {
                                for dataPoint in jokeValue {
                                    if let jokesObject = try? Jokes(json: dataPoint) {
                                        jokesArray.append(jokesObject)
                                    }
                                }
                            }
                        } else {
                            // handles the request for one joke
                            if let jokeValue = json["value"] as? [String:Any] {
                                print(jokeValue)
                                if let jokesObject = try? Jokes(json: jokeValue) {
                                    jokesArray.append(jokesObject)
                                }
                            }
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
                completion(jokesArray)
            }
        }
        task.resume()
    }
}
