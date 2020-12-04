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

    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        inUseButton.isHidden = true
        deletedButton.isHidden = true
        customActivityIndicatory(self.view, startAnimate: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.customActivityIndicatory(self.view, startAnimate: false)
            self.inUseButton.isHidden = false
            self.deletedButton.isHidden = false
        }
        
        ViewController.notesManager.fetchActiveData()
        ViewController.notesManager.fetchDeletedData()

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
    

    func customActivityIndicatory(_ viewContainer: UIView, startAnimate:Bool)  {
        let mainContainer: UIView = UIView(frame: viewContainer.frame)
        mainContainer.center = viewContainer.center
        mainContainer.backgroundColor = UIColor.black
        mainContainer.alpha = 0.5
        mainContainer.tag = 1
        mainContainer.isUserInteractionEnabled = false
      
        let viewBackgroundLoading: UIView = UIView(frame: CGRect(x:0,y: 0,width: 70,height: 70))
        viewBackgroundLoading.center = viewContainer.center
        viewBackgroundLoading.backgroundColor = UIColor.black
        viewBackgroundLoading.alpha = 0.5
        viewBackgroundLoading.clipsToBounds = true
        viewBackgroundLoading.layer.cornerRadius = 15
      
        let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.frame = CGRect(x:0.0,y: 0.0,width: 30.0, height: 30.0)
        activityIndicatorView.style = UIActivityIndicatorView.Style.large
        activityIndicatorView.color = .white
        activityIndicatorView.center = CGPoint(x: viewBackgroundLoading.frame.size.width / 2, y: viewBackgroundLoading.frame.size.height / 2)
        if startAnimate{
            viewBackgroundLoading.addSubview(activityIndicatorView)
            mainContainer.addSubview(viewBackgroundLoading)
            viewContainer.addSubview(mainContainer)
            activityIndicatorView.startAnimating()
        } else {
            for subview in viewContainer.subviews {
                if subview.tag == 1 {
                    subview.removeFromSuperview()
                }
            }
        }
    }


}



