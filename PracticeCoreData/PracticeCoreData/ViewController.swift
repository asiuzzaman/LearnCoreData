//
//  ViewController.swift
//  PracticeCoreData
//
//  Created by Md. Asiuzzaman on 30/12/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private var models = [TodoListItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(tableView)
        title = "Core Data todo list"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = view.bounds
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

       let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = model.name
        return cell
    }

    // Core Data
    func getAllItems() {
        do {
            models = try context.fetch(TodoListItem.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
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

