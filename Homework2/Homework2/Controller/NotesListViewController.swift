//
//  NotesListViewController.swift
//  Homework2
//
//  Created by Маркі on 05.11.2020.
//

import UIKit

class NotesListViewController: UITableViewController, UITextFieldDelegate {
    
    var notesActiveness: NotesActivenessType?
    @IBOutlet weak var addNoteButtton: UIBarButtonItem!
    var filteredArray = [Note]()
    var filterEnabled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        func sortByNameHandler(action: UIAction) {
            ViewController.notesManager.sortNotesArrayByName()
            tableView.reloadData()
        }
        
        func sortByDateAscHandler(action: UIAction) {
            ViewController.notesManager.sortNotesArrayByDate(ascending: true)
            tableView.reloadData()
        }
        
        func sortByDateDescHandler(action: UIAction) {
            ViewController.notesManager.sortNotesArrayByDate(ascending: false)
            tableView.reloadData()
        }
        
        func sortByFavouriteHandler(action: UIAction) {
            ViewController.notesManager.sortNotesArrayByFavourite()
            tableView.reloadData()
        }
        
        func filterByTagHandler(action: UIAction) {
            let alert = UIAlertController(title: "Filter by tag", message: "Enter exact tag for fltering", preferredStyle: .alert)
            var searchTextField = UITextField()
            alert.view.tintColor = UIColor.black
            alert.addTextField { (textField) -> Void in
                searchTextField = textField
                searchTextField.delegate = self
                searchTextField.placeholder = "Example tag"
            }
            alert.addAction(UIAlertAction(title: "Filter", style: .default, handler: { [weak alert] (_) in
                    let textField = alert?.textFields![0]
                    if textField?.text != "" {
                        self.filteredArray = ViewController.notesManager.filterByTag(noteTag: (textField?.text)!)
                        if self.filteredArray.count != 0 {
                            self.filterEnabled = true
                            self.tableView.reloadData()
                        }
                        
                    }
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        func filterByDateBefHandler(action: UIAction) {
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .date
            let alert = UIAlertController(title: "Filter by date", message: "Enter date to filter before it", preferredStyle: .alert)
            alert.view.addSubview(datePicker)
            alert.view.tintColor = UIColor.black
            let ok = UIAlertAction(title: "Ok", style: .default) { (action) in
                self.filteredArray = ViewController.notesManager.filterByDateBefore(noteDay: datePicker.date)
                if self.filteredArray.count != 0 {
                    self.filterEnabled = true
                    self.tableView.reloadData()
                }
            }
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alert.addAction(ok)
            alert.addAction(cancel)
            datePicker.translatesAutoresizingMaskIntoConstraints = false
            let alertView = alert.view!
            let horizontalConstraint = datePicker.centerXAnchor.constraint(equalTo: alertView.centerXAnchor)
            let verticalContraint = datePicker.centerYAnchor.constraint(equalTo: alertView.centerYAnchor)
            let heightConstraint = alertView.heightAnchor.constraint(equalToConstant: 280)
            alertView.addConstraints([horizontalConstraint,verticalContraint, heightConstraint])
            present(alert, animated: true, completion: nil)
        }
        
        func filterByDateAftHandler(action: UIAction) {
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .date
            let alert = UIAlertController(title: "Filter by date", message: "Enter date to filter after it", preferredStyle: .alert)
            alert.view.addSubview(datePicker)
            alert.view.tintColor = UIColor.black
            let ok = UIAlertAction(title: "Ok", style: .default) { (action) in
                self.filteredArray = ViewController.notesManager.filterByDateAfter(noteDay: datePicker.date)
                if self.filteredArray.count != 0 {
                    self.filterEnabled = true
                    self.tableView.reloadData()
                }
            }
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alert.addAction(ok)
            alert.addAction(cancel)
            datePicker.translatesAutoresizingMaskIntoConstraints = false
            let alertView = alert.view!
            let horizontalConstraint = datePicker.centerXAnchor.constraint(equalTo: alertView.centerXAnchor)
            let verticalContraint = datePicker.centerYAnchor.constraint(equalTo: alertView.centerYAnchor)
            let heightConstraint = alertView.heightAnchor.constraint(equalToConstant: 280)
            alertView.addConstraints([horizontalConstraint,verticalContraint, heightConstraint])
            present(alert, animated: true, completion: nil)
        }
        
        func searchByNameHandler(action: UIAction) {
            let alert = UIAlertController(title: "Search by note name", message: "Enter name", preferredStyle: .alert)
            var searchTextField = UITextField()
            alert.view.tintColor = UIColor.black
            alert.addTextField { (textField) -> Void in
                searchTextField = textField
                searchTextField.delegate = self
                searchTextField.placeholder = "Example name"
            }
            alert.addAction(UIAlertAction(title: "Search", style: .default, handler: { [weak alert] (_) in
                    let textField = alert?.textFields![0]
                    if textField?.text != "" {
                        let foundNote: Note? = ViewController.notesManager.searchNoteByName(noteName: (textField?.text)!)
                        if foundNote != nil {
                            self.performSegue(withIdentifier: "editNoteSegue", sender: foundNote)
                        }
                    }
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        func searchByWordHandler(action: UIAction) {
            let alert = UIAlertController(title: "Search by matching word", message: "Enter word", preferredStyle: .alert)
            var searchTextField = UITextField()
            alert.view.tintColor = UIColor.black
            alert.addTextField { (textField) -> Void in
                searchTextField = textField
                searchTextField.delegate = self
                searchTextField.placeholder = "Example word"
            }
            alert.addAction(UIAlertAction(title: "Search", style: .default, handler: { [weak alert] (_) in
                    let textField = alert?.textFields![0]
                    if textField?.text != "" {
                        let foundNote: Note? = ViewController.notesManager.searchNoteByWord(noteWord: (textField?.text)!)
                        if foundNote != nil {
                            self.performSegue(withIdentifier: "editNoteSegue", sender: foundNote)
                        }
                    }
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        
        let sortNotesButton = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down.circle")?.withTintColor(.black, renderingMode: .automatic),
                                              menu: UIMenu(title: "Sorting menu", children: [
                                                  UIAction(title: "Sort by name", image: UIImage(systemName: ""), handler: sortByNameHandler),
                                                  UIAction(title: "Sort by date (asc)", image: UIImage(systemName: ""), handler: sortByDateAscHandler),
                                                  UIAction(title: "Sort by date (desc)", image: UIImage(systemName: ""), handler: sortByDateDescHandler),
                                                  UIAction(title: "Sort by favourite", image: UIImage(systemName: ""), handler: sortByFavouriteHandler)
                                              ]))
        let searchNotesButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass.circle")?.withTintColor(.black, renderingMode: .automatic),
                                                menu: UIMenu(title: "Searching menu", children: [
                                                    UIAction(title: "Filter by tag", image: UIImage(systemName: ""), handler: filterByTagHandler),
                                                    UIAction(title: "Filter by date (before)", image: UIImage(systemName: ""), handler: filterByDateBefHandler),
                                                    UIAction(title: "Filter by date (after)", image: UIImage(systemName: ""), handler: filterByDateAftHandler),
                                                    UIAction(title: "Search by name", image: UIImage(systemName: ""), handler: searchByNameHandler),
                                                    UIAction(title: "Search by matching word", image: UIImage(systemName: ""), handler: searchByWordHandler)
                                                ]))
        navigationItem.rightBarButtonItems = [
            addNoteButtton,
            sortNotesButton,
            searchNotesButton
        ]
        
        switch notesActiveness {
        case .inUse:
            navigationItem.title = "In Use"
        case .deleted:
            navigationItem.title = "Deleted"
            addNoteButtton.isEnabled = false
            sortNotesButton.isEnabled = false
            searchNotesButton.isEnabled = false
        case .none:
            navigationItem.title = "In Use"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editNoteSegue" {
            let destinationVC = segue.destination as! CreateViewController
            if let selectedCell = sender as? IndexPath {
                switch notesActiveness {
                case .inUse:
                    destinationVC.note = ViewController.notesManager.notesArray[selectedCell.row]
                    destinationVC.notesActiveness = NotesActivenessType.inUse
                case .deleted:
                    destinationVC.note = ViewController.notesManager.notesDeletedArray[selectedCell.row]
                    destinationVC.notesActiveness = NotesActivenessType.deleted
                case .none:
                    destinationVC.note = ViewController.notesManager.notesArray[selectedCell.row]
                    destinationVC.notesActiveness = NotesActivenessType.inUse
                }
            } else {
                let note = sender as! Note
                destinationVC.note = note
                destinationVC.notesActiveness = NotesActivenessType.inUse
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if filterEnabled {
            return filteredArray.count
        } else {
            switch notesActiveness {
            case .inUse:
                return ViewController.notesManager.notesArray.count
            case .deleted:
                return ViewController.notesManager.notesDeletedArray.count
            case .none:
                return ViewController.notesManager.notesArray.count
            }
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath)
        if filterEnabled {
            cell.textLabel?.text = filteredArray[indexPath.row].noteName
        } else {
            switch notesActiveness {
            case .inUse:
                cell.textLabel?.text = ViewController.notesManager.notesArray[indexPath.row].noteName
                if ViewController.notesManager.notesArray[indexPath.row].noteIsFavorite {
                    cell.imageView?.image = UIImage(systemName: "heart.fill")
                } else {
                    cell.imageView?.image = nil
                }
            case .deleted:
                cell.textLabel?.text = ViewController.notesManager.notesDeletedArray[indexPath.row].noteName
            case .none:
                cell.textLabel?.text = ViewController.notesManager.notesArray[indexPath.row].noteName
            }
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            switch notesActiveness {
            case .inUse:
                ViewController.notesManager.deleteNote(noteName: ViewController.notesManager.notesArray[indexPath.row].noteName)
            case .deleted:
                ViewController.notesManager.deleteDeleted(noteName: ViewController.notesManager.notesDeletedArray[indexPath.row].noteName)
            case .none:
                ViewController.notesManager.deleteNote(noteName: ViewController.notesManager.notesArray[indexPath.row].noteName)
            }
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        switch notesActiveness {
        case .inUse:
            if ViewController.notesManager.notesArray[indexPath.row].noteIsFavorite {
                let actionFav = UIContextualAction(style: .normal, title: "Unavourite",
                    handler: { (action, view, completionHandler) in
                    // Update data source when user taps action
                        ViewController.notesManager.changeNoteFavoutiteStatus(noteName: ViewController.notesManager.notesArray[indexPath.row].noteName)
                        tableView.reloadData()
                    completionHandler(true)
                  })
                let actionDel = UIContextualAction(style: .normal, title: "Delete",
                                                   handler: { (action, view, completionHandler) in
                                                   // Update data source when user taps action
                                                       ViewController.notesManager.deleteNote(noteName: ViewController.notesManager.notesArray[indexPath.row].noteName)
                                                       tableView.reloadData()
                                                   completionHandler(true)
                                                 })
                actionDel.backgroundColor = .red
                let configuration = UISwipeActionsConfiguration(actions: [actionDel, actionFav])
                return configuration
            } else {
                let actionFav = UIContextualAction(style: .normal, title: "Favourite",
                    handler: { (action, view, completionHandler) in
                    // Update data source when user taps action
                        ViewController.notesManager.changeNoteFavoutiteStatus(noteName: ViewController.notesManager.notesArray[indexPath.row].noteName)
                        tableView.reloadData()
                    completionHandler(true)
                  })
                actionFav.backgroundColor = UIColor.init(red: 218/255.0, green: 165/255.0, blue: 32/255.0, alpha: 1.0)
                let actionDel = UIContextualAction(style: .normal, title: "Delete",
                                                   handler: { (action, view, completionHandler) in
                                                   // Update data source when user taps action
                                                       ViewController.notesManager.deleteNote(noteName: ViewController.notesManager.notesArray[indexPath.row].noteName)
                                                       tableView.reloadData()
                                                   completionHandler(true)
                                                 })
                actionDel.backgroundColor = .red
                let configuration = UISwipeActionsConfiguration(actions: [actionDel, actionFav])
                return configuration
            }
        case .deleted:
            let actionRes = UIContextualAction(style: .normal, title: "Restore",
                handler: { (action, view, completionHandler) in
                // Update data source when user taps action
                ViewController.notesManager.restoreNote(noteName: ViewController.notesManager.notesDeletedArray[indexPath.row].noteName)
                    tableView.reloadData()
                completionHandler(true)
              })
            let actionDel = UIContextualAction(style: .normal, title: "Delete",
                handler: { (action, view, completionHandler) in
                // Update data source when user taps action
                    ViewController.notesManager.deleteDeleted(noteName: ViewController.notesManager.notesDeletedArray[indexPath.row].noteName)
                    tableView.reloadData()
                completionHandler(true)
              })
            actionDel.backgroundColor = .red
            let configuration = UISwipeActionsConfiguration(actions: [actionDel, actionRes])
            return configuration
        case .none:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "editNoteSegue", sender: indexPath)
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
