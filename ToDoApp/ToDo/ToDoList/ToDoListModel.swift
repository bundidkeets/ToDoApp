//  
//  ToDoListModel.swift
//  ToDoApp
//
//  Created by Bundid on 26/11/2565 BE.
//

import Foundation
import ObjectMapper

struct ToDoListModel {
    
}

public struct ToDoResponse: Mappable {
    public var data: [TaskResponse]?

    public init?(map: Map) { }

    mutating public func mapping(map: Map) {
        data <- map["data"]
    }
}

public struct ToDoSingleResponse: Mappable {
    public var data: TaskResponse?

    public init?(map: Map) { }

    mutating public func mapping(map: Map) {
        data <- map["data"]
    }
}

public struct TaskResponse: Mappable {
    public var description: String?
    public var id: String?

    public init?(map: Map) { }

    mutating public func mapping(map: Map) {
        description <- map["description"]
        id <- map["_id"]
    }
}
