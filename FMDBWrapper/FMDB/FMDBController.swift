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
    private let serialDispatchQueue: dispatch_queue_t!

    init<T: FMDBEntityProtocol>(databaseName: String, entitiesTypes: [T.Type]?) {
        let dbPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first! + "/" + databaseName + ".db"
        let databaseExist = NSFileManager.defaultManager().fileExistsAtPath(dbPath as String)

        db = FMDatabase(path: dbPath)

        if db == nil {
            print(db.lastErrorMessage())
        }

        serialDispatchQueue = dispatch_queue_create(databaseName + "_dbQueue", DISPATCH_QUEUE_SERIAL)

        if !databaseExist && entitiesTypes != nil {
            self.setupDatabase(entitiesTypes!)
        }
    }

    func addEntity<T: FMDBEntityProtocol>(entity: T, completion: (Bool -> Void)?) {
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

    func fetchAllEntities<T: FMDBEntityProtocol>(entityClass:T.Type, completion: Array<T> -> Void) {
        self.fetchEntities(entityClass, whereStatement: nil, completion: completion)
    }

    func fetchEntities<T: FMDBEntityProtocol>(entityClass:T.Type, whereStatement: String?, completion: Array<T> -> Void) {
        runDatabaseBlockInTransaction { () in
            do {
                var query = "SELECT * FROM \(T.tableName)"
                if let _whereStatement = whereStatement {
                    query = query + " WHERE \(_whereStatement)"
                }

                let results:FMResultSet = try self.db.executeQuery(query, values: nil)
                var entities = [T]()

                while results.next() {
                    let entity = T()

                    for columnName in entity.columnsNamesArray {
                        guard let columnType = T.columnTypeByName(columnName) else {
                            continue
                        }

                        var value: AnyObject!

                        switch columnType {
                        case .IntType:
                            value = results.longForColumn(columnName)

                        case .BoolType:
                            value = results.boolForColumn(columnName)

                        case .DoubleType:
                            value = results.doubleForColumn(columnName)

                        case .StringType:
                            value = results.stringForColumn(columnName)

                        case .DateType:
                            value = results.dateForColumn(columnName)
                        }

                        entity.setValue(value, key: columnName)
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

    func open() -> Bool {
        let result = self.db.open()

        if !result {
            print(self.db.lastErrorMessage())
        }
        return result
    }

    func close() -> Bool {
        let result = self.db.close()

        if !result {
            print(self.db.lastErrorMessage())
        }

        return result
    }

    private func runDatabaseBlockInTransaction(block: Void -> Void) {
        dispatch_async(serialDispatchQueue) {
            autoreleasepool({
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

            for (index, row) in columnsNames.enumerate() {
                columnsStr = columnsStr + row + " \(T.columnTypeByName(row)!.sqlType())"
                if index < columnsNames.count - 1 {
                    columnsStr = columnsStr + ", "
                }
            }

            let sql_stmt = "CREATE TABLE IF NOT EXISTS \(entityType.tableName) (ID INTEGER PRIMARY KEY AUTOINCREMENT, \(columnsStr))"

            if !self.db.executeStatements(sql_stmt) {
                print("Error: \(self.db.lastErrorMessage())")
            }
        }

        self.close()
    }
}
