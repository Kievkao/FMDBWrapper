//
//  DatabaseController.swift
//  FmdbExample
//
//  Created by Andrii Kravchenko on 5/5/16.
//  Copyright © 2016 kievkao. All rights reserved.
//

import FMDB

class DatabaseController {

    static let DefaultDatabaseName = "TestDB"

    private let db: FMDatabase!
    private let serialDispatchQueue: dispatch_queue_t!

    init(databaseName: String) {
        let dbPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first! + "/" + databaseName + ".db"
        let databaseExist = NSFileManager.defaultManager().fileExistsAtPath(dbPath as String)

        db = FMDatabase(path: dbPath)

        if db == nil {
            print(db.lastErrorMessage())
        }

        serialDispatchQueue = dispatch_queue_create(databaseName + "_dbQueue", DISPATCH_QUEUE_SERIAL)

        if !databaseExist {
            self.setupDatabase()
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

    func addWorker(worker: Worker, completion: Bool -> Void) {
        runDatabaseBlockInTransaction { () in
            do {
                try self.db.executeUpdate("INSERT INTO WORKER (name, age, position) values (?,?,?)", values: [worker.name, worker.age, worker.position])
                completion(true)
            }
            catch {
                print(self.db.lastErrorMessage())
                completion(false)
            }
        }
    }

    func fetchAllWorkers(completion: Array<Worker> -> Void) {
        runDatabaseBlockInTransaction { () in
            do {
                let results:FMResultSet = try self.db.executeQuery("SELECT name, age, position FROM WORKER", values: nil)
                var workers = [Worker]()

                while results.next() {
                    let worker = Worker()
                    worker.name = results.stringForColumn("name")
                    worker.age = Int(results.intForColumn("age"))
                    worker.position = results.stringForColumn("position")

                    workers.append(worker)
                }
                
                completion(workers)
            }
            catch {
                print(self.db.lastErrorMessage())
                completion([])
            }
        }
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

    private func setupDatabase() {
        guard self.open() else {
            return
        }

        let sql_stmt = "CREATE TABLE IF NOT EXISTS WORKER (ID INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age INTEGER, position TEXT)"
        if !self.db.executeStatements(sql_stmt) {
            print("Error: \(self.db.lastErrorMessage())")
        }

        self.close()
    }
}
