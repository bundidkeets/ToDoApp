//  
//  LoginModel.swift
//  ToDoApp
//
//  Created by Bundid on 26/11/2565 BE.
//

import Foundation
import ObjectMapper

public struct LoginModel {
    public var email: String?
    public var password: String?
}

public struct LoginResponse: Mappable {
    public var user: UserResponse?
    public var token: String?
    
    public init?(map: Map) { }
    
    mutating public func mapping(map: Map) {
        user <- map["user"]
        token <- map["token"]
    }
}

public struct UserResponse: Mappable {
    public var age: Int?
    public var id: String?
    public var name: String?
    public var email: String?
    
    public init?(map: Map) { }
    
    mutating public func mapping(map: Map) {
        age <- map["age"]
        id <- map["_id"]
        name <- map["name"]
        email <- map["email"]
    }
}
