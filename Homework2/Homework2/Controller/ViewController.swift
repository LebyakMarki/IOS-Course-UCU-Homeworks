//
//  ViewController.swift
//  Homework2
//
//  Created by Маркі on 04.11.2020.
//

import UIKit

enum NotesActivenessType {
    case inUse
    case deleted
}

class ViewController: UIViewController {
    
    @IBOutlet weak var inUseButton: UIButton!
    @IBOutlet weak var deletedButton: UIButton!
    
    static var notesManager = NoteDataManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        inUseButton.layer.borderWidth = 1.0
        inUseButton.layer.cornerRadius = 8.0
        inUseButton.layer.borderColor = UIColor.black.cgColor
        
        deletedButton.layer.borderWidth = 1.0
        deletedButton.layer.cornerRadius = 8.0
        deletedButton.layer.borderColor = UIColor.black.cgColor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! NotesListViewController
        if segue.identifier == "notesInUseSegue" {
            destinationVC.notesActiveness = NotesActivenessType.inUse
        } else {
            destinationVC.notesActiveness = NotesActivenessType.deleted
        }
    }


}

