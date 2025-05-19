//
//  NetworkService.swift
//  PaymobMovieList
//
//  Created by Mahmoud Saad on 19/05/2025.
//

import Foundation
import Combine

class NetworkService: NetworkServiceType {
    
    private let session: URLSession
    private let connectivityManager: NetworkConnectivityProvider
    private var cancellables = Set<AnyCancellable>()
    
    init(session: URLSession = .shared,
         connectivityManager: NetworkConnectivityProvider = NetworkConnectivityManager.shared) {
        self.session = session
        self.connectivityManager = connectivityManager
        connectivityManager.startMonitoring()
    }
    
    func request<T: Codable>(endpoint: any Endpoint) async throws -> T {
        
        if !connectivityManager.isConnected {
            try await Task.sleep(nanoseconds: 500_000_000)
        }
        guard connectivityManager.isConnected else { throw NetworkError.notConnected }
        
        do {
            let url = try createURL(for: endpoint)
            var request = URLRequest(url: url)
            request.httpMethod = endpoint.method.rawValue
            request.addValue(APIConstants.HeaderValues.applicationJSON,
                            forHTTPHeaderField: APIConstants.HeaderKeys.contentType)
            
            request.addValue(APIConstants.HeaderValues.bearer,
                               forHTTPHeaderField: APIConstants.HeaderKeys.authorization)
            
            print("\(endpoint.method.rawValue) \(url.absoluteString)")
            
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            let validData = try handleErrors(statusCode: httpResponse.statusCode, data: data)
            
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(T.self, from: validData)
            
            logResponse(decodedData)
            
            return decodedData
            
        } catch {
            if let networkError = error as? NetworkError {
                throw networkError
            }
            throw NetworkError.unknownError(statusCode: nil)
        }
    }
}



// MARK: - NetworkService Helper Extensions
extension NetworkService {
    func createURL(for endpoint: any Endpoint) throws -> URL {
        var urlComponents = URLComponents(string: APIConstants.baseURL + endpoint.path)
        guard urlComponents != nil else {
            throw NetworkError.invalidURL
        }
        
        var queryItems: [URLQueryItem] = endpoint.parameters.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        
        queryItems.append(URLQueryItem(name: APIConstants.Parameters.language,
                                      value: APIConstants.DefaultValues.language))
        queryItems.append(URLQueryItem(name: APIConstants.Parameters.limit,
                                      value: APIConstants.DefaultValues.limit))
        queryItems.append(URLQueryItem(name: APIConstants.Parameters.apiKey,
                                      value: APIConstants.apiKey))
        
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else {
            throw NetworkError.invalidURL
        }
        
        return url
    }
    
    func handleErrors(statusCode: Int, data: Data) throws -> Data {
        switch statusCode {
        case 200..<300:
            return data
        case 400:
            throw NetworkError.badRequest
        case 401:
            throw NetworkError.unauthorized
        case 404:
            throw NetworkError.notFound
        case 500..<600:
            throw NetworkError.serverError
        default:
            throw NetworkError.unknownError(statusCode: statusCode)
        }
    }
    
    func logResponse<T: Encodable>(_ data: T) {
        #if DEBUG
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let prettyPrintedData = try encoder.encode(data)
            if let prettyPrintedString = String(data: prettyPrintedData, encoding: .utf8) {
                print(prettyPrintedString)
            }
        } catch {
            print("Could not format response for logging")
        }
        #endif
    }
}
