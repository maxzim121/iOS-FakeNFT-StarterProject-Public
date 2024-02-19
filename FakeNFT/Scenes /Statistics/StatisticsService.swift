//
//  StatisticsService.swift
//  FakeNFT
//
//  Created by Александр Медведев on 18.02.2024.
//

import Foundation

enum NetworkError: Error {
    case codeError
}

final class StatisticsService {
    static let shared = StatisticsService()
    
    private var task: URLSessionDataTask?
    
    private (set) var listOfUsers: [UserProfile]?
    
    func fetchUsers(completion: @escaping (Result<[UserProfile], Error>) -> Void) {
        guard let url = URL(string: "\(RequestConstants.baseURL)/api/v1/users") else {return}
        //print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("\(RequestConstants.accessToken)", forHTTPHeaderField: "X-Practicum-Mobile-Token")
        task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else {return}
            if let error = error {
                print("get users error \(error)")
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }
            
            //print("users response \(response)")
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                DispatchQueue.main.async { completion(.failure(NetworkError.codeError))
                }
                return
            }
            
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let initialListOfUsers = try decoder.decode([UserProfile].self, from: data)
                //print(initialListOfUsers)
                DispatchQueue.main.async {
                    self.listOfUsers = initialListOfUsers
                    //for i in 0..<self.imagesPerPage {
                      //  self.photos.append(nextPagePhotosForTable[i])
                    //}
                    //print("HINT final: \(self.photos)")
                    self.task = nil
                    
                    completion(.success(self.listOfUsers!))
                }
            }  catch {
                print("Failed to parse the downloaded file")
            }
        }
        task!.resume()
    }
}
