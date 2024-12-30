//
//  ViewController.swift
//  PracticeCoreData
//
//  Created by Md. Asiuzzaman on 30/12/24.
//

import UIKit

class ViewController: UIViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // Core Data
    func getAllItems() {
        do {
           try context.fetch(TodoListItem.fetchRequest())
        }
        catch {
            print("Error fetching data")
        }
    }

    func createItem(name: String) {
        let item = TodoListItem(context: context)
        item.name = name
        item.createdAt = Date()

        do {
            try context.save()
        } catch {
            print("Error while saving data")
        }
    }

    func deleteItem(item: TodoListItem)
    {
        context.delete(item)

        do {
            try context.save()
        } catch {
            print("Error while Deleting data")
        }

    }

    func updateItem(item: TodoListItem, name: String) {
        item.name = name
        
        do {
            try context.save()
        } catch {
            print("Error while Deleting data")
        }
    }

}

