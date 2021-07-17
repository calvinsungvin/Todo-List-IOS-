//
//  ViewController.swift
//  Todo List
//
//  Created by Calvin Sung on 2021/7/14.
//

import UIKit

class ViewController: UIViewController {
    
    var items = [String]()
    let userDefaults = UserDefaults.standard
    
    var table: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        table.frame = view.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Todo List"
        view.addSubview(table)
        self.items = userDefaults.value(forKey: "items") as! [String]
        table.dataSource = self
        table.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    }
    
    @objc func addTapped(){
        
        let alert = UIAlertController(title: "Add Items!", message: "add your todo list items", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "enter your todo"
        }
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "done", style: .default, handler: { (_) in
            if let textField = alert.textFields?.first {
                if let text = textField.text, !text.isEmpty {
                    DispatchQueue.main.async {
                        var currentValue = self.userDefaults.value(forKey: "items") as! [String]
                        currentValue.append(text)
                        self.userDefaults.setValue(currentValue, forKey: "items")
                        self.items.append(text)
                        self.table.reloadData()
                    }
                }
            }
        }))
        present(alert, animated: true)
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)

        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "delete", style: .destructive, handler: { (_) in
            self.table.beginUpdates()
            self.items.remove(at: indexPath.row)
            self.table.deleteRows(at: [indexPath], with: .fade)
            self.table.endUpdates()
        }))
        present(sheet, animated: true)
        }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            table.beginUpdates()
            
            items.remove(at: indexPath.row)
            table.deleteRows(at: [indexPath], with: .fade)
            
            table.endUpdates()
        }
    }
    
}


