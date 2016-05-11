//
//  Worker.swift
//  CoreDataStacksExample
//
//  Created by Andrii Kravchenko on 12/22/15.
//  Copyright © 2015 Andrii Kravchenko. All rights reserved.
//

import Foundation

class Worker: NSObject, FMDBEntityProtocol {
    var age: Int = 0
    var name: String!
    var position: String!

    // MARK: FMDBEntityProtocol
    override required init() {
        super.init()
    }

    var columnsValues: [AnyObject] { return [age, name, position] }

    static func columnTypeByName(name: String) -> FMDBVariableType? {
        switch name {
        case "age":
            return .IntType

        case "name", "position":
            return .StringType

        default:
            return nil
        }
    }
}
