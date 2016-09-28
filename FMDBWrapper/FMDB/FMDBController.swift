//
//  FMDBController.swift
//  FmdbExample
//
//  Created by Andrii Kravchenko on 5/5/16.
//  Copyright © 2016 kievkao. All rights reserved.
//

import FMDB

final class FMDBController {

    private let db: FMDatabase!
    private let serialDispatchQueue: DispatchQueue!

    // TODO: optional init
    init<T: FMDBEntityProtocol>(databaseName: String, entitiesTypes: [T.Type]?) {
        let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/" + databaseName + ".db"
        let databaseExist = FileManager.default.fileExists(atPath: dbPath as String)

        db = FMDatabase(path: dbPath)

        if db == nil {
            print(db.lastErrorMessage())
        }

        serialDispatchQueue =  DispatchQueue(label: databaseName + "_dbQueue")

        if !databaseExist && entitiesTypes != nil {
            self.setupDatabase(entitiesTypes: entitiesTypes!)
        }
    }

    func addEntity<T: FMDBEntityProtocol>(entity: T, completion: ((Bool) -> Void)?) {
        runDatabaseBlockInTransaction { () in
            do {
                try self.db.executeUpdate("INSERT INTO \(T.tableName) (\(entity.columnsNames)) values (\(entity.columnsPattern))", values: entity.columnsValues)
                completion?(true)
            }
            catch {
                print(self.db.lastErrorMessage())
                completion?(false)
            }
        }
    }

    func fetchAllEntities<T: FMDBEntityProtocol>(entityClass:T.Type, completion: @escaping ((Array<T>) -> Void)) {
        self.fetchEntities(entityClass: entityClass, whereStatement: nil, orderBy: nil, completion: completion)
    }

    func fetchAllEntities<T: FMDBEntityProtocol>(entityClass:T.Type, orderBy:String, completion: @escaping (Array<T>) -> Void) {
        self.fetchEntities(entityClass: entityClass, whereStatement: nil, orderBy: orderBy, completion: completion)
    }

    func fetchEntities<T: FMDBEntityProtocol>(entityClass:T.Type, whereStatement: String?, orderBy:String?, completion: @escaping (Array<T>) -> Void) {
        runDatabaseBlockInTransaction { () in
            do {
                var query = "SELECT * FROM \(T.tableName)"
                if let _whereStatement = whereStatement {
                    query = query + " WHERE \(_whereStatement)"
                }

                if let _orderBy = orderBy {
                    query = query + " ORDER BY \(_orderBy)"
                }

                let results:FMResultSet = try self.db.executeQuery(query, values: nil)
                var entities = [T]()

                while results.next() {
                    let entity = T()

                    for columnName in entity.columnsNamesArray {
                        guard let columnType = T.columnTypeByName(name: columnName) else {
                            continue
                        }

                        var value: AnyObject!

                        switch columnType {
                        case .IntType:
                            value = results.long(forColumn: columnName) as AnyObject!

                        case .BoolType:
                            value = results.bool(forColumn: columnName) as AnyObject!

                        case .DoubleType:
                            value = results.double(forColumn: columnName) as AnyObject!

                        case .StringType:
                            value = results.string(forColumn: columnName) as AnyObject!

                        case .DateType:
                            value = results.date(forColumn: columnName) as AnyObject!
                        }

                        entity.setValue(value: value, key: columnName)
                    }

                    entities.append(entity)
                }
                
                completion(entities)
            }
            catch {
                print(self.db.lastErrorMessage())
                completion([])
            }
        }
    }

    @discardableResult func open() -> Bool {
        let result = self.db.open()

        if !result {
            print(self.db.lastErrorMessage())
        }
        return result
    }

    @discardableResult func close() -> Bool {
        let result = self.db.close()

        if !result {
            print(self.db.lastErrorMessage())
        }

        return result
    }

    private func runDatabaseBlockInTransaction(block: @escaping (Void) -> Void) {
        serialDispatchQueue.async() {
            autoreleasepool(invoking: {
                self.db.beginTransaction()
                block()
                self.db.commit()
            })
        }
    }

    private func setupDatabase<T: FMDBEntityProtocol>(entitiesTypes: [T.Type]) {
        guard self.open() else {
            return
        }

        for entityType in entitiesTypes {
            let columnsNames = T().columnsNamesArray
            var columnsStr = ""

            for (index, row) in columnsNames.enumerated() {
                columnsStr = columnsStr + row + " \(T.columnTypeByName(name: row)!.sqlType())"
                if index < columnsNames.count - 1 {
                    columnsStr = columnsStr + ", "
                }
            }

            let sql_stmt = "CREATE TABLE IF NOT EXISTS \(entityType.tableName) (ID INTEGER PRIMARY KEY AUTOINCREMENT, \(columnsStr))"

            if !self.db.executeStatements(sql_stmt) {
                print("Error: \(self.db.lastErrorMessage())")
            }
        }
    }
}
