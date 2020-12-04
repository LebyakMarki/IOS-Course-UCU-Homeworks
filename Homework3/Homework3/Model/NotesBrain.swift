//
//  NotesBrain.swift
//  Homework2
//
//  Created by Маркі on 05.11.2020.
//
import CoreData
import Foundation
import UIKit

class NoteActive: NSManagedObject {
    // Struct holding note information
    @NSManaged var noteId: Int
    @NSManaged var noteName: String
    @NSManaged var noteText: String
    @NSManaged var noteTagPasswords: Bool
    @NSManaged var noteTagToDo: Bool
    @NSManaged var noteTagWork: Bool
    @NSManaged var noteIsFavorite: Bool
    @NSManaged var noteCreationDate: Date
    @NSManaged var noteDeletionDate: Date?
}

class NoteDeleted: NSManagedObject {
    // Struct holding note information
    @NSManaged var noteId: Int
    @NSManaged var noteName: String
    @NSManaged var noteText: String
    @NSManaged var noteTagPasswords: Bool
    @NSManaged var noteTagToDo: Bool
    @NSManaged var noteTagWork: Bool
    @NSManaged var noteIsFavorite: Bool
    @NSManaged var noteCreationDate: Date
    @NSManaged var noteDeletionDate: Date?
}


struct NoteDataManager {
    // Struct operating over Note struct
    var notesDeletedArray = [NoteDeleted]()
    var notesArray = [NoteActive]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    mutating func fetchActiveData() {
        let fetchRequest = NoteActive.fetchRequest()
        do {
            self.notesArray = try context.fetch(fetchRequest) as! [NoteActive]
          } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
          }
    }
    
    mutating func fetchDeletedData() {
        let fetchRequest = NoteDeleted.fetchRequest()
        do {
            self.notesDeletedArray = try context.fetch(fetchRequest) as! [NoteDeleted]
          } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
          }
    }
    
    func saveData() {
        do {
          try context.save()
        } catch {
           print("Error saving context \(error)")
        }
    }
    
    
    
    mutating func createNote(noteName: String, noteText: String, noteTags: [String]) {
        // Function creating new note. Date is setted automatically as well as id
        if !checkNoteIfExists(noteName: noteName) {
            let newNote = NoteActive(context: self.context)
            newNote.noteId = notesArray.count
            newNote.noteName = noteName
            newNote.noteText = noteText
            newNote.noteTagToDo = noteTags.contains("To-Do") ? true : false
            newNote.noteTagWork = noteTags.contains("Work") ? true : false
            newNote.noteTagPasswords = noteTags.contains("Passwords") ? true : false
            newNote.noteIsFavorite = false
            newNote.noteCreationDate = Date()
            newNote.noteDeletionDate = nil
            notesArray.append(newNote)
            saveData()
        } else {
            print("There is already note with such a name!")
        }
    }
    
    
    func searchNoteByName(noteName: String) -> NoteActive? {
        // Function searching note by its name
        return notesArray.first(where: { $0.noteName == noteName })
    }
    
    func searchNoteByWord(noteWord: String) -> NoteActive? {
        // Function searching note by its name
        return notesArray.first(where: { $0.noteText.contains(noteWord)})
    }
    
    mutating func changeNoteFavoutiteStatus(noteName: String) {
        // Function setting note favourite status to opposite value
        if let index = notesArray.firstIndex(where: { $0.noteName == noteName }) {
            notesArray[index].noteIsFavorite = !notesArray[index].noteIsFavorite
            saveData()
        }
    }
    
    func checkNoteIfExists(noteName: String) -> Bool {
        // Function checking if note exists
        for someNote in notesArray {
            if someNote.noteName == noteName {
                return true
            }
        }
        return false
    }
    
    mutating func recoverNotesIds() {
        if notesArray.count > 1 {
            for i in 0..<notesArray.count {
                notesArray[i].noteId = i
            }
        } else if notesArray.count == 1 {
            notesArray[0].noteId = 0
        }
        saveData()
    }
    
    mutating func recoverDeletedNotesIds() {
        if notesDeletedArray.count > 1 {
            for i in 0..<notesDeletedArray.count {
                notesDeletedArray[i].noteId = i
            }
        } else if notesDeletedArray.count == 1 {
            notesDeletedArray[0].noteId = 0
        }
        saveData()
    }
    
    mutating func deleteNote(noteName: String) {
        // Function deleting note from array
        for someNote in notesArray {
            if someNote.noteName == noteName {
                let deletedId = someNote.noteId
                
                let newDeletedNote = NoteDeleted(context: self.context)
                newDeletedNote.noteId = notesDeletedArray.count
                newDeletedNote.noteName = someNote.noteName
                newDeletedNote.noteText = someNote.noteText
                newDeletedNote.noteTagToDo = someNote.noteTagToDo
                newDeletedNote.noteTagWork = someNote.noteTagWork
                newDeletedNote.noteTagPasswords = someNote.noteTagPasswords
                newDeletedNote.noteIsFavorite = someNote.noteIsFavorite
                newDeletedNote.noteCreationDate = someNote.noteCreationDate
                newDeletedNote.noteDeletionDate = Date()
                
                notesDeletedArray.append(newDeletedNote)
                context.delete(notesArray[deletedId])
                notesArray.remove(at: deletedId)
                recoverNotesIds()
                saveData()
            }
        }
    }
    
    mutating func restoreNote(noteName: String) {
        // Function recovering note from "deleted"
        for someNote in notesDeletedArray {
            if someNote.noteName == noteName {
                let deletedId = someNote.noteId
                
                let restoredNote = NoteActive(context: self.context)
                restoredNote.noteId = notesArray.count
                restoredNote.noteName = someNote.noteName
                restoredNote.noteText = someNote.noteText
                restoredNote.noteTagToDo = someNote.noteTagToDo
                restoredNote.noteTagWork = someNote.noteTagWork
                restoredNote.noteTagPasswords = someNote.noteTagPasswords
                restoredNote.noteIsFavorite = someNote.noteIsFavorite
                restoredNote.noteCreationDate = someNote.noteCreationDate
                restoredNote.noteDeletionDate = nil
                
                notesArray.append(restoredNote)
                context.delete(notesDeletedArray[deletedId])
                notesDeletedArray.remove(at: deletedId)
                recoverDeletedNotesIds()
                saveData()
            }
        }
    }
    
    mutating func deleteDeleted(noteName: String) {
        for someNote in notesDeletedArray {
            if someNote.noteName == noteName {
                let deletedId = someNote.noteId
                context.delete(notesDeletedArray[deletedId])
                notesDeletedArray.remove(at: deletedId)
                recoverDeletedNotesIds()
                saveData()
            }
        }
    }
    
    mutating func sortNotesArrayByDate(ascending: Bool) {
        // Sort notes in array by date
        if ascending {
            notesArray.sort(by: { $0.noteCreationDate < $1.noteCreationDate })
        } else {
            notesArray.sort(by: { $0.noteCreationDate > $1.noteCreationDate })
        }
    }
    
    mutating func sortNotesArrayByName() {
        // Sort notes in array by name
        notesArray.sort(by: { $0.noteName < $1.noteName })
    }
    
    mutating func sortNotesArrayByFavourite() {
        // Sort notes in array by favourite status
        notesArray.sort(by: { $0.noteIsFavorite && !$1.noteIsFavorite })
    }
    
    func filterByTag(noteTag: String)-> [NoteActive]{
        // Function filtering notes by provided tag
        var resultNotes = [NoteActive]()
        for someNote in notesArray {
            if noteTag == "To-Do" {
                if someNote.noteTagToDo {
                    resultNotes.append(someNote)
                }
            }
            if noteTag == "Work" {
                if someNote.noteTagWork {
                    resultNotes.append(someNote)
                }
            }
            if noteTag == "Passwords" {
                if someNote.noteTagPasswords {
                    resultNotes.append(someNote)
                }
            }
        }
        return resultNotes
    }
    
    func filterByDateBefore(noteDay: Date)-> [NoteActive]{
        // Function filtering notes before provided date
        var resultNotes = [NoteActive]()
        for someNote in notesArray {
            if someNote.noteCreationDate < noteDay {
                resultNotes.append(someNote)
            }
        }
        return resultNotes
    }
    
    func filterByDateAfter(noteDay: Date)-> [NoteActive]{
        // Function filtering notes after provided date
        var resultNotes = [NoteActive]()
        for someNote in notesArray {
            if someNote.noteCreationDate > noteDay {
                resultNotes.append(someNote)
            }
        }
        return resultNotes
    }
}
