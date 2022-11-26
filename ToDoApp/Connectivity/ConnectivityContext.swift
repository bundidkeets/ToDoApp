//
//  AuthenticateContext.swift
//  ToDoApp
//
//  Created by Bundid on 26/11/2565 BE.
//

import UIKit
import Moya
import RxSwift
import Moya_ObjectMapper

public class ConnectivityContext: NSObject {
    fileprivate var authenProvider: UncacheProvider<AuthenticateAPI>?
    fileprivate var todoProvider: UncacheProvider<TodoAPI>?
    
    public override init() {
        super.init()
        self.setupProvider()
    }
    
    func setupProvider(){
        let authURL = { () -> URL in return URL(string: "https://api-nodejs-todolist.herokuapp.com")! }
        authenProvider = UncacheProvider(authURL)
        todoProvider = UncacheProvider(authURL)
    }
}

extension ConnectivityContext {
    
    // Authen
    func register(registObject: RegisterModel) -> Observable<Response> {
        return authenProvider!.rx.request(.register(register: registObject))
            .asObservable()
            .filterSuccessfulStatusAndRedirectCodes()
    }
    
    func login(loginObject: LoginModel) -> Observable<LoginResponse> {
        return authenProvider!.rx.request(.login(login: loginObject))
            .asObservable()
            .mapObject(LoginResponse.self)
    }
    
    func me() -> Observable<UserResponse> {
        return authenProvider!.rx.request(.me)
            .asObservable()
            .mapObject(UserResponse.self)
    }
    
    // To Do
    func addTask(task: String) -> Observable<Response> {
        return todoProvider!.rx.request(.addTask(description: task))
            .asObservable()
            .filterSuccessfulStatusAndRedirectCodes()
    }
}

class UncacheProvider<Target>: MoyaProvider<Target> where Target: TargetType {

    init(_ urlClousure: @escaping (() -> URL), plugins: [PluginType] = []) {

        let endpointClosure = { (target: Target) -> Endpoint in
            let url = URL(string: target.path.encodingApiPath(), relativeTo: urlClousure())?.absoluteString
            let endpoint = Endpoint(
                url: url!,
                sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                method: target.method,
                task: target.task,
                httpHeaderFields: target.headers
            )
            return endpoint
        }

        let requestClosure = { (endpoint: Endpoint, done: MoyaProvider.RequestResultClosure) in
            do {
                var request: URLRequest = try endpoint.urlRequest()
                // this is the important line
                //            request.cachePolicy = .reloadIgnoringCacheData
                request.headers = .default
                request.timeoutInterval = 300.0
                request.cachePolicy = .reloadIgnoringLocalCacheData
                done(.success(request))
            } catch {
                done(.failure(MoyaError.underlying(error, nil)))
            }
        }

        var defaultPlugins: [PluginType] = []
        defaultPlugins.append(contentsOf: plugins)
        super.init(endpointClosure: endpointClosure, requestClosure: requestClosure, plugins: defaultPlugins)
    }
}

extension String {
    public func encodingApiPath() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? self
    }
    
    public func decodingApiPath() -> String {
        return self.removingPercentEncoding ?? self
    }
}
