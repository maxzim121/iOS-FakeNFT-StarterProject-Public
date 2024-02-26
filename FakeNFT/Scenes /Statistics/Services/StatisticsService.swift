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
    
    private (set) var listOfUsers: [UserProfile]=[]
        
    func fetchUsers(completion: @escaping (Result<[UserProfile], Error>) -> Void) {
        guard let url = URL(string: "\(RequestConstants.baseURL)/api/v1/users") else {return}

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("\(RequestConstants.accessToken)", forHTTPHeaderField: "X-Practicum-Mobile-Token")
        task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else {return}
            if let error = error {
                print("get users error \(error)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                DispatchQueue.main.async { 
                    completion(.failure(NetworkError.codeError))
                }
                return
            }
            
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let initialListOfUsers = try decoder.decode([UserProfileServer].self, from: data)
                DispatchQueue.main.async {
                    self.convert2UserProfile(from: initialListOfUsers)
                    self.doSort()
                    
                    self.task = nil
                    completion(.success(self.listOfUsers))
                }
            }  catch {
                print("Failed to parse the downloaded file")
            }
        }
        task?.resume()
    }
    
    func fetchNftById(nftId: String, completion: @escaping (Result<NftByIdServer, Error>) -> Void) {
        guard let url = URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(nftId)") else {return}

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("\(RequestConstants.accessToken)", forHTTPHeaderField: "X-Practicum-Mobile-Token")
        task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else {return}
            if let error = error {
                print("get nftById error \(error)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                DispatchQueue.main.async { 
                    completion(.failure(NetworkError.codeError))
                }
                return
            }
            
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let initialNftById = try decoder.decode(NftByIdServer.self, from: data)
                DispatchQueue.main.async {
                    self.task = nil
                    completion(.success(initialNftById))
                }
            }  catch {
                print("Failed to parse the downloaded file")
            }
        }
        task?.resume()
    }
    
    func fetchProfile(completion: @escaping (Result<MainProfile, Error>) -> Void) {
        guard let url = URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("\(RequestConstants.accessToken)", forHTTPHeaderField: "X-Practicum-Mobile-Token")
        task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else {return}
            if let error = error {
                print("get mainProfile error \(error)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                DispatchQueue.main.async { 
                    completion(.failure(NetworkError.codeError))
                }
                return
            }
            
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let initialMainProfile = try decoder.decode(MainProfile.self, from: data)
                DispatchQueue.main.async {
                    self.task = nil
                    completion(.success(initialMainProfile))
                }
            }  catch {
                print("Failed to parse the downloaded file")
            }
        }
        task?.resume()
    }
    
    func updateLikesArrayInMainProfile(_ likesArray: [String], completion: @escaping (Result<MainProfile, Error>) -> Void) {
        guard let url = URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("\(RequestConstants.accessToken)", forHTTPHeaderField: "X-Practicum-Mobile-Token")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let data = "{ \"likes\": \(likesArray)}".data(using: String.Encoding.utf8)
        request.httpBody = data
        //print(likesArray)
        
        task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else {return}
            if let error = error {
                print("get mainProfile error \(error)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                DispatchQueue.main.async { 
                    completion(.failure(NetworkError.codeError))
                }
                return
            }
            
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let initialMainProfile = try decoder.decode(MainProfile.self, from: data)
                DispatchQueue.main.async {
                    self.task = nil
                    completion(.success(initialMainProfile))
                }
            }  catch {
                print("Failed to parse the downloaded file")
            }
        }
        task?.resume()
    }
}
extension StatisticsService {
    private func convert2UserProfile(from: [UserProfileServer]) {
        for i in 0..<from.count {
            let user_i = UserProfile(name: from[i].name,
                                     avatar: from[i].avatar,
                                     description: from[i].description,
                                     website: from[i].website,
                                     nfts: from[i].nfts,
                                     rating: Int(from[i].rating) ?? 0,
                                     id: from[i].id)
            self.listOfUsers.append(user_i)
        }
    }
    
    func doSort() {
        let setSortBy = UserDefaults.standard.integer(forKey: "sortBy")
        if setSortBy == SortBy.rating.rawValue {
            //we get "0" even if the value for key is not defined
            //check this behaviour:
            //print(UserDefaults.standard.integer(forKey: "sortBy")) (checked, that it returns 0 on 21Feb2024)
            
            //sort users according the rating in descending order
            listOfUsers.sort {
                $0.rating > $1.rating
            }
        } else if setSortBy == SortBy.name.rawValue {
            //sort users according the name in increasing order
            listOfUsers.sort {
                $0.name < $1.name
            }
        } else {
            print("Set the proper value of the sorting flag.")
        }
    }
     
}
