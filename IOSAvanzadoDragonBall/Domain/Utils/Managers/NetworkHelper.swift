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
    let server: String = "https://dragonball.keepcoding.education/"
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
        
        struct Body: Encodable {
            let name: String
        }
        let body = Body(name: name)
        let url = "\(server)/api/heros/all"
        
        performAuthenticatedNetworkRequest(withUrl: url, httpMethod: .post, andHttpBody: body) { (result: Result<[Hero], NetworkError>) in
            switch result {
            case .success(let heros):
                completion(heros, nil)
            case .failure(let error):
                completion([], error)
            }
        }
    }
    
    func getLocations(id: String = "", completion: @escaping ([Location], NetworkError?) -> Void) {
        
        struct Body: Encodable {
            let id: String
        }
        let body = Body(id: id)
        let url = "\(server)/api/heros/locations"
        
        performAuthenticatedNetworkRequest(withUrl: url, httpMethod: .post, andHttpBody: body) { (result: Result<[Location], NetworkError>) in
            switch result {
            case .success(let locations):
                completion(locations, nil)
            case .failure(let error):
                completion([], error)
            }
        }
    }
}

// MARK: - Generic API call
private extension NetworkHelper {
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    func performAuthenticatedNetworkRequest<R: Decodable, B: Encodable>(
        withUrl url: String,
        httpMethod: HTTPMethod,
        andHttpBody httpBody: B?,
        completion: @escaping (Result<R, NetworkError>) -> Void) {
            // Its mandatory to be logged before using this function
            guard let token else {
                fatalError("No token")
            }
            
            guard let url = URL(string: url) else {
                completion(.failure(.malformedURL))
                return
            }
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = httpMethod.rawValue
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            if let httpBody {
                urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.httpBody = try? JSONEncoder().encode(httpBody)
            }
            
            session.dataTask(with: urlRequest) { (data, response, error) in
                guard error == nil else {
                    completion(.failure(.other))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(.noData))
                    return
                }
                
                // Get JSONDecoder with the appropriate context, decode into coredata and then save the object in container
                let decoder = JSONDecoder(context: self.coreDataManager.container.viewContext)
                guard let response = try? decoder.decode(R.self, from: data) else {
                    completion(.failure(.decoding))
                    return
                }
                self.coreDataManager.save()

                completion(.success(response))
            }.resume()
        }
}

