//  
//  NewTaskModel.swift
//  ToDoApp
//
//  Created by Bundid on 26/11/2565 BE.
//

import Foundation
import ObjectMapper

struct NewTaskModel: Codable {
    public var name: String?
    public var description: String?
    public var date: String?
    public var time: String?
    public var icon: String?
}

extension NewTaskModel {
    func toString() -> String {
        do {
            let encodedData = try JSONEncoder().encode(self)
            let jsonString = String(data: encodedData, encoding: .utf8)
            return jsonString ?? ""
        } catch {
            return ""
        }
    }
}
