//
//  ViewController.swift
//  FmdbExample
//
//  Created by Andrii Kravchenko on 5/5/16.
//  Copyright © 2016 kievkao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var dbController = FMDBController(databaseName: "TestDB", entitiesTypes: [Worker.self, Furniture.self])

    override func viewDidLoad() {
        super.viewDidLoad()

        dbController.open()

        addWorkers()
        addFurniture()
        fetchAllWorkers()
        fetchAllFurniture()
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
    
    func addFurniture() {
        dbController.open()
        
        var furniture = Furniture()
        furniture.type = "Table"
        furniture.inventoryNumber = 15283
        
        dbController.addEntity(entity: furniture) { (success) in
            print("Added Furniture result: \(success)")
        }
        
        furniture = Furniture()
        furniture.type = "Chair"
        furniture.inventoryNumber = 683
        
        dbController.addEntity(entity: furniture) { (success) in
            print("Added Furniture result: \(success)")
        }

    }
    
    func fetchAllFurniture() {
        dbController.fetchAllEntities(entityClass: Furniture.self) { (furnitures) in
            for case let furniture as Furniture in furnitures {
                print("Fetched Furniture: type: \(furniture.type), number: \(furniture.inventoryNumber)")
            }
        }
    }

    func fetchAllWorkers() {
        dbController.fetchAllEntities(entityClass: Worker.self) { (workers) in
            for case let worker as Worker in workers {
                print("Fetched Worker: \(worker.name), \(worker.age) years, position: \(worker.position)")
            }
        }
    }

    func fetchWorkersWithFilter() {
        dbController.fetchEntities(entityClass: Worker.self, whereStatement: "age = 30", orderBy: "age") { (workers) in
            if case let worker as Worker = workers.first {
                print("Fetched Worker: \(worker.name), \(worker.age) years, position: \(worker.position)")
            }
            else {
                print("No workers")
            }
        }
    }
}

