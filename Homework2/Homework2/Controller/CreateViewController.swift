//
//  CreateViewController.swift
//  Homework2
//
//  Created by Маркі on 07.11.2020.
//

import UIKit

class CreateViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var noteDateLabel: UILabel!
    @IBOutlet weak var workTag: UIButton!
    @IBOutlet weak var passwordTag: UIButton!
    @IBOutlet weak var todoTag: UIButton!
    
    var note: Note?
    var notesActiveness: NotesActivenessType?
    var selectedTags = ["Work": false, "Passwords": false, "To-Do": false]

    override func viewDidLoad() {
        super.viewDidLoad()

        titleTextView.delegate = self
        contentTextView.delegate = self
        
        if note != nil {
            for tag in note!.noteTags {
                selectedTags[tag] = true
            }
        }
        
        workTag.isSelected = selectedTags["Work"]!
        passwordTag.isSelected = selectedTags["Passwords"]!
        todoTag.isSelected = selectedTags["To-Do"]!
        
        titleTextView.clipsToBounds = true
        titleTextView.layer.cornerRadius = 10
        titleTextView.layer.borderWidth = 1.0
        titleTextView.layer.borderColor = UIColor.black.cgColor
        titleTextView.text = note != nil ? note?.noteName : "Enter Title"
        titleTextView.textColor = note != nil ? UIColor.black : UIColor.lightGray
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        noteDateLabel.text = note != nil ? formatter.string(from: note!.noteCreationDate) : ""
            
        contentTextView.clipsToBounds = true
        contentTextView.layer.cornerRadius = 10
        contentTextView.layer.borderWidth = 1.0
        contentTextView.layer.borderColor = UIColor.black.cgColor
        contentTextView.text = note != nil ? note?.noteText : "Enter Text"
        contentTextView.textColor = note != nil ? UIColor.black : UIColor.lightGray
        
        if notesActiveness == .deleted {
            saveButton.isHidden = true
            titleTextView.isUserInteractionEnabled = false
            contentTextView.isUserInteractionEnabled = false
        }
    }
    
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        if titleTextView.text == "Enter Title" || titleTextView.text == "" {
            titleTextView.text = "You must enter title"
            titleTextView.textColor = UIColor.lightGray
            titleTextView.endEditing(true)
        } else {
            var noteTags = [String]()
            for tag in selectedTags {
                if tag.value == true {
                    noteTags.append(tag.key)
                }
            }
            if note == nil {
                ViewController.notesManager.createNote(noteName: titleTextView.text, noteText: contentTextView.text, noteTags: noteTags)
            } else {
                ViewController.notesManager.notesArray[note!.noteId].noteName = titleTextView.text
                ViewController.notesManager.notesArray[note!.noteId].noteText = contentTextView.text
                ViewController.notesManager.notesArray[note!.noteId].noteTags = noteTags
            }
            navigationController?.popViewController(animated: true)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    @IBAction func tagSelected(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        selectedTags[sender.titleLabel!.text!] = sender.isSelected
    }
    
    
}
