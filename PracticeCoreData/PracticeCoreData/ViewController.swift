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
        getAllItems()
        title = "Core Data todo list"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = view.bounds

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addItem)
        )
    }

    @objc private func addItem() {
        let alert = UIAlertController(
            title: "Add Item",
            message: "Enter new Item",
            preferredStyle: .alert
        )

        alert.addTextField(configurationHandler: nil)

        alert.addAction(UIAlertAction(
            title: "Submit",
            style: .cancel,
            handler: { [weak self] _ in
                guard
                    let field = alert.textFields?.first,
                    let text = field.text,
                    !text.isEmpty
                else {
                    print("Text field is empty")
                    return
                }

                self?.createItem(name: text)
            }
        )
        )
        present(alert, animated: true)
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let item = models[indexPath.row]

        let sheet = UIAlertController(
            title: "Edit Item",
            message: nil,
            preferredStyle: .actionSheet
        )

        sheet.addAction(UIAlertAction(title: "Cancle", style: .cancel, handler: { _ in } ))

        sheet.addAction(UIAlertAction(
            title: "Edit",
            style: .default,
            handler: { _ in

                let alert = UIAlertController(
                    title: "Add Item",
                    message: "Enter new Item",
                    preferredStyle: .alert
                )

                alert.addTextField(configurationHandler: nil)

                alert.textFields?.first?.text = item.name

                alert.addAction(UIAlertAction(
                    title: "Save",
                    style: .cancel,
                    handler: { [weak self] _ in
                        guard
                            let field = alert.textFields?.first,
                            let newText = field.text,
                            !newText.isEmpty
                        else {
                            print("Text field is empty")
                            return
                        }

                        self?.updateItem(item: item, name: newText)
                    }
                )
                )
                self.present(alert, animated: true)
            }
        ))


        sheet.addAction(UIAlertAction(
            title: "Delete",
            style: .destructive,
            handler: {  [weak self]_ in
                self?.deleteItem(item: item)
            }
        ))

        present(sheet, animated: true)
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
            getAllItems()
        } catch {
            print("Error while saving data")
        }
    }

    func deleteItem(item: TodoListItem)
    {
        context.delete(item)

        do {
            try context.save()
            getAllItems()
        } catch {
            print("Error while Deleting data")
        }

    }

    func updateItem(item: TodoListItem, name: String) {
        item.name = name
        
        do {
            try context.save()
            getAllItems()
        } catch {
            print("Error while Deleting data")
        }
    }

}

