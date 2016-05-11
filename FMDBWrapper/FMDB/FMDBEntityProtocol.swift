//
//  FMDBEntityProtocol.swift
//  FmdbExample
//
//  Created by Andrii Kravchenko on 5/5/16.
//  Copyright © 2016 kievkao. All rights reserved.
//

import Foundation

enum FMDBVariableType: Int {
    case IntType
    case BoolType
    case DoubleType
    case StringType
    case DateType

    func sqlType() -> String {
        switch self {
        case .IntType, .BoolType, .DateType:
            return "INTEGER"

        case .StringType:
            return "TEXT"

        case .DoubleType:
            return "REAL"
        }
    }
}

protocol FMDBEntityProtocol {
    static var tableName: String { get }
    var columnsNames: String { get }
    var columnsPattern: String { get }
    var columnsNamesArray: [String] { get }

    var columnsValues: [AnyObject] { get }
    static func columnTypeByName(name: String) -> FMDBVariableType?
    func setValue(value: AnyObject, key: String)

    init()
}

extension FMDBEntityProtocol where Self: NSObject {
    static var tableName: String { return String(self) }

    var columnsNamesArray: [String] {
        return Mirror(reflecting: self).children.filter { $0.label != nil }.map { $0.label! }
    }

    var columnsNames: String {
        return self.columnsNamesArray.joinWithSeparator(",")
    }

    var columnsPattern: String {
        let pattern = String(byRepeatingString: "?,", count: self.columnsNamesArray.count)
        return String(pattern.characters.dropLast())
    }

    func setValue(value: AnyObject, key: String) {
        self.setValue(value, forKey: key)
    }
}

extension String {
    public init(byRepeatingString str: String, count: Int) {
        var newString = ""

        for _ in 0 ..< count {
            newString += str
        }
        
        self.init(newString)
    }
}