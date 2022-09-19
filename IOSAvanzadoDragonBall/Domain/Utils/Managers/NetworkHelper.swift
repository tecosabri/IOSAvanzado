//
//  NetworkModel.swift
//  DragonBall
//
//  Created by Ismael Sabri Pérez on 12/7/22.
//

import UIKit
import CoreData

enum NetworkError: Error, Equatable {
    case malformedURL
    case noData
    case errorCode(Int?)
    case tokenFormat
    case decoding
    case other
}

final class NetworkHelper {
    
    // MARK: - Properties
    let session: URLSession
    let server: String = "https://vapor2022.herokuapp.com"
    let coreDataManager = CoreDataManager()
    var token: String?
    
    init(urlSession: URLSession = .shared, token: String? = nil) {
        self.session = urlSession
        self.token = token
    }
    
    func login(withUser user: String, andPassword password: String, completion: @escaping ((String?, NetworkError?) -> Void)){
        
        // Get login data as base64string
        let loginString = String(format: "%@:%@", user, password)
        let loginData = loginString.data(using: .utf8)
        guard let base64loginString = loginData?.base64EncodedString() else {return}
        
        // Get the URLrequest
        guard let url = URL(string: "\(server)/api/auth/login") else {
            completion(nil, NetworkError.malformedURL)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64loginString)", forHTTPHeaderField: "Authorization")
        
        // Get URLSession and perform the call
        let task = session.dataTask(with: request) { data, response, error in
            //Check parameters
            guard error == nil else {
                completion(nil, .other)
                return
            }
            guard let data = data else {
                completion(nil, .noData)
                return
            }
            guard let httpResponse = (response as? HTTPURLResponse), httpResponse.statusCode == 200 else {
                completion(nil, .errorCode((response as? HTTPURLResponse)?.statusCode))
                return
            }
            
            // Get the token from data
            guard let token = String(data: data, encoding: .utf8) else {
                completion(nil, .tokenFormat)
                return
            }
            
            completion(token, nil)
            
        }
        task.resume()
    }
    
    
    
    func getHeroes(name: String = "", completion: @escaping ([Hero], NetworkError?) -> Void) {
        guard let url = URL(string: "\(server)/api/heros/all") else {
            completion([], .malformedURL)
            return
        }
        
        guard let token = self.token else {
            completion([], .other)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        struct Body: Encodable {
            let name: String
        }
        
        let body = Body(name: name)
        
        urlRequest.httpBody = try? JSONEncoder().encode(body)
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                completion([], .other)
                return
            }
            
            guard let data = data else {
                completion([], .noData)
                return
            }
            
            guard let httpResponse = (response as? HTTPURLResponse),
                  httpResponse.statusCode == 200 else {
                completion([], .errorCode((response as? HTTPURLResponse)?.statusCode))
                return
            }
            
            // Get JSONDecoder with the appropriate context
            let decoder = JSONDecoder(context: self.coreDataManager.container.viewContext)
            guard let heroesResponse = try? decoder.decode([Hero].self, from: data) else {
                completion([], .decoding)
                return
            }
            self.coreDataManager.save()
            
            completion(heroesResponse, nil)
        }
        
        task.resume()
    }
    
    
    func getTransformations(id: String, completion: @escaping ([Transformation], NetworkError?) -> Void) {
        guard let url = URL(string: "\(server)/api/heros/tranformations") else {
            completion([], .malformedURL)
            return
        }
        
        guard let token = self.token else {
            completion([], .other)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        struct Body: Encodable {
            let id: String
        }
        
        let body = Body(id: id)
        
        urlRequest.httpBody = try? JSONEncoder().encode(body)
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                completion([], .other)
                return
            }
            
            guard let data = data else {
                completion([], .noData)
                return
            }
            
            guard let httpResponse = (response as? HTTPURLResponse),
                  httpResponse.statusCode == 200 else {
                completion([], .errorCode((response as? HTTPURLResponse)?.statusCode))
                return
            }
            
            let decoder = JSONDecoder(context: self.coreDataManager.container.viewContext)
            guard let transformationResponse = try? decoder.decode([Transformation].self, from: data) else {
                completion([], .decoding)
                return
            }
            
            completion(transformationResponse, nil)
        }
        
        task.resume()
    }
    
    func getLocations(id: String, completion: @escaping ([Location], NetworkError?) -> Void) {
        guard let url = URL(string: "\(server)/api/heros/locations") else {
            completion([], .malformedURL)
            return
        }
        
        guard let token = self.token else {
            completion([], .other)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        struct Body: Encodable {
            let id: String
        }
        
        let body = Body(id: id)
        
        urlRequest.httpBody = try? JSONEncoder().encode(body)
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                completion([], .other)
                return
            }
            
            guard let data = data else {
                completion([], .noData)
                return
            }
            
            guard let httpResponse = (response as? HTTPURLResponse),
                  httpResponse.statusCode == 200 else {
                completion([], .errorCode((response as? HTTPURLResponse)?.statusCode))
                return
            }
            
            // Get JSONDecoder with the appropriate context
            let decoder = JSONDecoder(context: self.coreDataManager.container.viewContext)
            guard let locationResponse = try? decoder.decode([Location].self, from: data) else {
                completion([], .decoding)
                return
            }
            self.coreDataManager.save()
            
            completion(locationResponse, nil)
        }
        
        task.resume()
    }
    
}

