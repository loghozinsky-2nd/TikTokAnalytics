//
//  APIService.swift
//  TikTok Analytics
//
//  Created by Aleksander Loghozinsky on 06.08.2020.
//

import Foundation
import Alamofire

typealias JsonDictionary = [String : Any]
typealias SessionManagerDictionary = [String : Session]

enum Response {
    case success(response: String)
    case failure(error: Error)
    case notConnectedToInternet
}

private protocol APIServiceDelegate: class {
    var dataRequestArray: [DataRequest] { get set }
    var sessionManager: SessionManagerDictionary { get set }
    
    func callEndPoint(_ url: String, method: Alamofire.HTTPMethod, params: JsonDictionary, headers: HTTPHeaders, completion: @escaping (Response) -> Void)
    func serializeResponse(response: AFDataResponse<String>,  completion: @escaping (Response) -> Void)
    func cancelAllRequests()
    
    func success(response: String?, headers: [AnyHashable: Any], completion: @escaping (Response) -> Void)
    func failure(error: Error?, completion: @escaping (Response) -> Void)
    func notConnectedToInternet(completion: @escaping (Response) -> Void)
}

private protocol APIServiceFormatter {
    func getUrlString(api: API, endPoint: EndPoint) -> String
    func getUrlString(_ dict: JsonDictionary, api: API, endPoint: String) -> String
}

class APIService: APIServiceDelegate, APIServiceFormatter {
    
    static let shared = APIService()
    
    private let decoder = JSONDecoder()
    
    fileprivate var dataRequestArray: [DataRequest] = []
    fileprivate var sessionManager: SessionManagerDictionary = [:]
    
    private init() {}
    
    // MARK: - GitHubRepositories
    public func getUser(username: String, completion: @escaping (UserResponse?, Error?) -> Void) {
        let dict: JsonDictionary = ["key" : Constant.key]
        let url = getUrlString(dict, api: .dev, endPoint: EndPoint.user.rawValue + username)
        
        callEndPoint(url) { [weak self] (response) in
            switch response {
                case .success(let result):
                    let json: String = result
                    do {
                        guard let `self` = self else { return }
                        let data = try self.decoder.decode(UserResponse.self, from: Data(json.utf8))
                        
                        completion(data, nil)
                    } catch {
                        print(error.localizedDescription)
                        completion(nil, error)
                    }
                case .failure(let error):
                    print(">> response Error from failure")
                    print(error)
                    completion(nil, error)
                default:
                    print(">> response Error from default state")
                    break
            }
        }
    }
    
    public func getVideoList(userId: Int, completion: @escaping (VideoResponse?, Error?) -> Void) {
        let dict: JsonDictionary = ["key" : Constant.key]
        let url = getUrlString(dict, api: .dev, endPoint: EndPoint.user.rawValue + String(userId) + EndPoint.videos.rawValue)
        
        callEndPoint(url) { [weak self] (response) in
            switch response {
                case .success(let result):
                    let json: String = result
                    do {
                        guard let `self` = self else { return }
                        let data = try self.decoder.decode(VideoResponse.self, from: Data(json.utf8))

                        completion(data, nil)
                    } catch {
                        print(error.localizedDescription)
                        completion(nil, error)
                    }
                case .failure(let error):
                    print(">> response Error from failure")
                    print(error)
                    completion(nil, error)
                default:
                    print(">> response Error from default state")
                    break
            }
        }
    }
    
    func getImage(withUrlString url: String, completion: @escaping (Data) -> Void) {
        print("APIService getImage: trying to request for image with url = \(url)")
        AF.request(url).response { (response) in
            print("APIService getImage: response = \(response)")
            if let data = response.data {
                completion(data)
            }
        }
    }
    
}

extension APIServiceFormatter {
    
    // MARK: - Format
    func getUrlString(api: API, endPoint: EndPoint) -> String {
        let result: String = api.rawValue + endPoint.rawValue
        
        return result
    }
    
    func getUrlString(_ dict: JsonDictionary, api: API, endPoint: String) -> String {
        var result = api.rawValue + endPoint
        let finalString = dict.description.replacingOccurrences(of: ":", with: "=", options: String.CompareOptions.literal, range: nil).replacingOccurrences(of: "\"", with: "", options: String.CompareOptions.literal, range: nil).replacingOccurrences(of: "[", with: "", options: String.CompareOptions.literal, range: nil).replacingOccurrences(of: " ", with: "", options: String.CompareOptions.literal, range: nil).replacingOccurrences(of: ",", with: "&", options: String.CompareOptions.literal, range: nil).replacingOccurrences(of: "]", with: "", options: String.CompareOptions.literal, range: nil)
        let endPointExtension: String = "?" + finalString
        result += endPointExtension
        
        return result
    }
    
}

extension APIServiceDelegate {
    
    // MARK: - Request API logic
    func callEndPoint(_ url: String, method: Alamofire.HTTPMethod = .get, params: JsonDictionary = [:], headers: HTTPHeaders = [:], completion: @escaping (Response) -> Void) {
        AF.request(url, method: method, parameters: params, headers: headers) { urlRequest in
            urlRequest.timeoutInterval = .infinity
        }.responseString { [weak self] (response) in
            guard let strongSelf = self else { return }
            strongSelf.serializeResponse(response: response, completion: completion)
            strongSelf.sessionManager.removeValue(forKey: url)
        }
    }
    
    func serializeResponse(response: AFDataResponse<String>,  completion: @escaping (Response) -> Void) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let strongSelf = self else { return }
            guard let urlResponse = response.response else {
                if let error = response.error as NSError?, error.code == NSURLErrorNotConnectedToInternet {
                    strongSelf.notConnectedToInternet(completion: completion)
                } else {
                    strongSelf.failure(error: response.error, completion: completion)
                }
                return
            }
            
            strongSelf.success(response: response.value, headers: urlResponse.allHeaderFields, completion: completion)
        }
    }
    
    func cancelAllRequests() {
        for dataRequest in self.dataRequestArray {
            dataRequest.cancel()
        }
        
        self.dataRequestArray.removeAll()
    }
    
    func notConnectedToInternet(completion: @escaping (Response) -> Void) {
        completion(.notConnectedToInternet)
    }
    
    func failure(error: Error?, completion: @escaping (Response) -> Void) {
        if let error = error {
            completion(.failure(error: error))
        }
    }
    
    func success(response: String?, headers: [AnyHashable: Any], completion: @escaping (Response) -> Void) {
        if let response = response {
            completion(.success(response: response))
        }
    }
    
}
