//
//  Worker.swift
//  CoreDataStacksExample
//
//  Created by Andrii Kravchenko on 12/22/15.
//  Copyright © 2015 Andrii Kravchenko. All rights reserved.
//

import Foundation

class Worker: NSObject, EntityProtocol {
    var age: Int!
    var name: String!
    var position: String!

    var tableName: String { return "WORKER" }
    var rowsNames: String { return "name, age, position" }
    var rowsPattern: String { return "?,?,?" }
    var rowsValues: [AnyObject] { return [name, age, position] }
}
