//
//  AuthenticateAPI.swift
//  ToDoApp
//
//  Created by Bundid on 26/11/2565 BE.
//

import Moya
import ObjectMapper

private extension String {
    var URLEscapedString: String {
        let unreserved = "-._~/?"
        let allowed = NSMutableCharacterSet.alphanumeric()
        allowed.addCharacters(in: unreserved)
        return self.addingPercentEncoding(withAllowedCharacters: allowed as CharacterSet)!
    }
}

public enum TodoAPI {
    case addTask(description: String)
    case getTask
    case getTaskById(id: String)
    case getCompleted
}

extension TodoAPI: TargetType {
    public var sampleData: Data {
        switch self {
        default:
            return "{}".data(using: String.Encoding.utf8)!
        }
    }
    
    public var headers: [String: String]? {
        return ["Content-type": "application/json",
                "X-Api-Version": "1.0",
                "Authorization" : "Bearer \(myToken())"
                ]
    }
    
    public func myToken() -> String {
        guard let currentToken = UserDefaults.standard.string(forKey: "accessToken") else { return ""}
        return currentToken
    }
    
    public var task: Task {
        switch self {
        default:
            if let parameters = parameters {
                return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            } else {
                return .requestPlain
            }
        }
    }
    
    public var baseURL: URL {
        return URL(string: "https://api-nodejs-todolist.herokuapp.com")!
    }
    
    public var path: String {
        switch self {
        case .addTask:
            return "/task"
        case .getTask:
            return "/task"
        case .getCompleted:
            return "/task?completed=true"
        case .getTaskById(id: let id):
            return "/task/\(id)"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .addTask:
            return .post
        case .getTask:
            return .get
        case .getCompleted:
            return .get
        case .getTaskById:
            return .get
        }
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case .addTask(let description):
            let json = ["description": description]
            return json
    
        default:
            return nil
        }
    }
}
