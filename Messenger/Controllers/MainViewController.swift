//
//  MainViewController.swift
//  Messenger
//
//  Created by Ryan Untalan on 2/21/21.
//

import UIKit
import Firebase

class MainViewController: UIViewController {

    //MARK:- Properties
    private var recordingsViewController: RecordingsViewController? {
        get {
            return children.compactMap({ $0 as? RecordingsViewController }).first
        }
    }
    private var recorderViewController: RecorderViewController? {
        get {
            return children.compactMap({ $0 as? RecorderViewController }).first
        }
    }
    
    //MARK:- Outlets
    @IBOutlet weak var recordingsView: UIView!
    @IBOutlet weak var recorderView: UIView!
    
    //MARK:- Actions
//    let randomID = UUID.init().uuidString
//    @IBAction func uploadButtonwasTapped(_ sender: Any) {
//        let uploadRef = Storage.storage().reference(withPath: "reflections/\(randomID).wav")
//        guard let audioData = AudioVisualizerView.
//    }
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let recorder = self.recorderViewController {
            recorder.delegate = self
        }
        if let recordings = self.recordingsViewController {
            recordings.delegate = self
        }
        

    }

}

extension MainViewController: RecorderViewControllerDelegate {
    func didAddRecording() {
        if let recordings = self.recordingsViewController {
                    DispatchQueue.main.async {
                        recordings.loadRecordings()
                    }
                }
    }
    
    func didStartRecording() {
        if let recordings = self.recordingsViewController {
            recordings.fadeView.isHidden = false
            UIView.animate(withDuration: 0.25, animations: {
                recordings.fadeView.alpha = 1
            })
        }
    }
    
    func didFinishRecording() {
        if let recordings = self.recordingsViewController {
            recordings.view.isUserInteractionEnabled = true
            UIView.animate(withDuration: 0.25, animations: {
                recordings.fadeView.alpha = 0
            }, completion: { (finished) in
                if finished {
                    recordings.fadeView.isHidden = true
                    DispatchQueue.main.async {
                        recordings.loadRecordings()
                    }
                    self.performSegue(withIdentifier: "nextReflection", sender: self)
                }
            })
        }
    }
}

extension MainViewController: RecordingsViewControllerDelegate {
    func didStartPlayback() {
        if let recorder = self.recorderViewController {
            recorder.fadeView.isHidden = false
            UIView.animate(withDuration: 0.25, animations: {
                recorder.fadeView.alpha = 1
            })
        }
    }
    
    func didFinishPlayback() {
        if let recorder = self.recorderViewController {
            recorder.view.isUserInteractionEnabled = true
            UIView.animate(withDuration: 0.25, animations: {
                recorder.fadeView.alpha = 0
            }, completion: { (finished) in
                if finished {
                    recorder.fadeView.isHidden = true
                }
            })
        }
    }
}
