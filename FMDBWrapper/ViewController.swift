//
//  ViewController.swift
//  FmdbExample
//
//  Created by Andrii Kravchenko on 5/5/16.
//  Copyright © 2016 kievkao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var dbController = FMDBController(databaseName: "TestDB", entitiesTypes: [Worker.self])

    override func viewDidLoad() {
        super.viewDidLoad()

        dbController.open()

//        addWorkers()
//        fetchAllWorkers()
//        fetchWorkersWithFilter()
    }

    func addWorkers() {
        dbController.open()

        var worker = Worker()
        worker.name = "John"
        worker.age = 30
        worker.position = "Developer"

        dbController.addEntity(entity: worker) { (success) in
            print("Added Worker result: \(success)")
        }

        worker = Worker()
        worker.name = "Adam"
        worker.age = 22
        worker.position = "QA"

        dbController.addEntity(entity: worker) { (success) in
            print("Added Worker result: \(success)")
        }

        worker = Worker()
        worker.name = "Smith"
        worker.age = 26
        worker.position = "PM"

        dbController.addEntity(entity: worker) { (success) in
            print("Added Worker result: \(success)")
        }
        worker = Worker()
        worker.name = "Linda"
        worker.age = 28
        worker.position = "Designer"

        dbController.addEntity(entity: worker) { (success) in
            print("Added Worker result: \(success)")
        }
    }

    func fetchAllWorkers() {
        dbController.fetchAllEntities(entityClass: Worker.self) { (workers) in
            for worker in workers {
                print("Fetched Worker: \(worker.name), \(worker.age) years, position: \(worker.position)")
            }
        }
    }

    func fetchWorkersWithFilter() {
        dbController.fetchEntities(entityClass: Worker.self, whereStatement: "age = 30", orderBy: "age") { (workers) in
            if let worker = workers.first {
                print("Fetched Worker: \(worker.name), \(worker.age) years, position: \(worker.position)")
            }
            else {
                print("No workers")
            }
        }
    }
}

