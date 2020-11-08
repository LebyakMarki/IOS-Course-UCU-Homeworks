//
//  NotesBrain.swift
//  Homework2
//
//  Created by Маркі on 05.11.2020.
//

import Foundation

struct Note {
    // Struct holding note information
    var noteId: Int
    var noteName: String
    var noteText: String
    var noteTags: [String]
    var noteIsFavorite: Bool
    var noteCreationDate: Date
    var noteDeletionDate: Date?
}


struct NoteDataManager {
    // Struct operating over Note struct
    var notesArray = [Note(noteId: 0, noteName: "First active note", noteText: "Simple active note", noteTags: ["Simple tag"], noteIsFavorite: true, noteCreationDate: Date.init(timeIntervalSince1970: 86400), noteDeletionDate: nil)]
    var notesDeletedArray = [Note(noteId: 0, noteName: "First deleted note", noteText: "Simple deleted note", noteTags: ["Simple deleted tag"], noteIsFavorite: false, noteCreationDate: Date(), noteDeletionDate: nil)]
//    var notesDeletedArray = [Note]()
//    var notesArray = [Note]()
    
    mutating func createNote(noteName: String, noteText: String, noteTags: [String]) {
        // Function creating new note. Date is setted automatically as well as id
        if !checkNoteIfExists(noteName: noteName) {
            let newNote = Note(noteId: notesArray.count, noteName: noteName, noteText: noteText, noteTags: noteTags, noteIsFavorite: false, noteCreationDate: Date(), noteDeletionDate: nil)
            notesArray.append(newNote)
        } else {
            print("There is already note with such a name!")
        }
    }
    
    
    func searchNoteByName(noteName: String) -> Note? {
        // Function searching note by its name
        return notesArray.first(where: { $0.noteName == noteName })
    }
    
    func searchNoteByWord(noteWord: String) -> Note? {
        // Function searching note by its name
        return notesArray.first(where: { $0.noteText.contains(noteWord)})
    }
    
    mutating func changeNoteFavoutiteStatus(noteName: String) {
        // Function setting note favourite status to opposite value
        if let index = notesArray.firstIndex(where: { $0.noteName == noteName }) {
            notesArray[index].noteIsFavorite = !notesArray[index].noteIsFavorite
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
    }
    
    mutating func recoverDeletedNotesIds() {
        if notesDeletedArray.count > 1 {
            for i in 0..<notesDeletedArray.count {
                notesDeletedArray[i].noteId = i
            }
        } else if notesDeletedArray.count == 1 {
            notesDeletedArray[0].noteId = 0
        }
    }
    
    mutating func deleteNote(noteName: String) {
        // Function deleting note from array
        for var someNote in notesArray {
            if someNote.noteName == noteName {
                let deletedId = someNote.noteId
                someNote.noteId = notesDeletedArray.count
                someNote.noteDeletionDate = Date()
                notesDeletedArray.append(someNote)
                notesArray.remove(at: deletedId)
                recoverNotesIds()
            }
        }
    }
    
    mutating func restoreNote(noteName: String) {
        // Function recovering note from "deleted"
        for var someNote in notesDeletedArray {
            if someNote.noteName == noteName {
                let deletedId = someNote.noteId
                someNote.noteId = notesArray.count
                someNote.noteDeletionDate = nil
                notesArray.append(someNote)
                notesDeletedArray.remove(at: deletedId)
                recoverDeletedNotesIds()
            }
        }
    }
    
    mutating func deleteDeleted(noteName: String) {
        for someNote in notesDeletedArray {
            if someNote.noteName == noteName {
                let deletedId = someNote.noteId
                notesDeletedArray.remove(at: deletedId)
                recoverDeletedNotesIds()
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
    
    func filterByTag(noteTag: String)-> [Note]{
        // Function filtering notes by provided tag
        var resultNotes = [Note]()
        for someNote in notesArray {
            if someNote.noteTags.contains(noteTag) {
                resultNotes.append(someNote)
            }
        }
        return resultNotes
    }
    
    func filterByDateBefore(noteDay: Date)-> [Note]{
        // Function filtering notes before provided date
        var resultNotes = [Note]()
        for someNote in notesArray {
            if someNote.noteCreationDate < noteDay {
                resultNotes.append(someNote)
            }
        }
        return resultNotes
    }
    
    func filterByDateAfter(noteDay: Date)-> [Note]{
        // Function filtering notes after provided date
        var resultNotes = [Note]()
        for someNote in notesArray {
            if someNote.noteCreationDate > noteDay {
                resultNotes.append(someNote)
            }
        }
        return resultNotes
    }
}
