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

public enum AuthenticateAPI {
    case register(register: RegisterModel)
    case login(login: LoginModel)
    case me
}

extension AuthenticateAPI: TargetType {
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
        case .register:
            return "/user/register"
        case .login:
            return "/user/login"
        case .me:
            return "/user/me"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .register:
            return .post

        case .login:
            return .post
            
        case .me:
            return .get
        }
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case .register(let register):
            let json = ["name": register.name as Any,
                        "email" : register.email as Any,
                        "password" : register.password as Any,
                        "age" : register.age as Any
                        ] as [String : Any]
            return json
        case .login(let login):
            let json = ["email" : login.email as Any,
                        "password" : login.password as Any
                        ]
            return json
            
        default:
            return nil
        }
    }
}
