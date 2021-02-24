//
//  RecordingsViewController.swift
//  Messenger
//
//  Created by Ryan Untalan on 2/22/21.
//

let cellid = "audiocell"

import UIKit
import AVFoundation

struct Recording {
    var name: String
    var path: URL
}

protocol RecordingsViewControllerDelegate: class {
    func didStartPlayback()
    func didFinishPlayback()
}

class RecordingsViewController: UIViewController {
    
    //MARK:- Properties
    private var recordings: [Recording] = []
    private var audioPlayer: AVAudioPlayer?
    weak var delegate: RecordingsViewControllerDelegate?

    //MARK:- Outlets
    @IBOutlet weak var tableAudioView: UITableView!
    @IBOutlet weak var fadeView: UIView!
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadRecordings()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.isPlaying() {
            self.stopPlay()
        }
        super.viewWillDisappear(animated)
    }
    
    //MARK:- Setup Methods
    fileprivate func setupTableView() {
        self.tableAudioView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 180, right: 0)
    }

    // MARK:- Data
    func loadRecordings() {
        self.recordings.removeAll()
        let filemanager = FileManager.default
        let documentsDirectory = filemanager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let paths = try filemanager.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil, options: [])
            for path in paths {
                let recording = Recording(name: path.lastPathComponent, path: path)
                print("this is the ", recording)
                self.recordings.append(recording)
            }
            self.tableAudioView.reloadData()
        } catch {
            print(error)
        }
    }
    
    // MARK:- Playback
    private func play(audiourl: URL) {
        if let d = self.delegate {
            d.didStartPlayback()
        }
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)
        } catch let error as NSError {
            print(error.localizedDescription)
            return
        }
        do {
            let data = try Data(contentsOf: audiourl)
            self.audioPlayer = try AVAudioPlayer(data: data, fileTypeHint: AVFileType.caf.rawValue)
        } catch let error as NSError {
            print(error.localizedDescription)
            return
        }
        if let player = self.audioPlayer {
            player.delegate = self
            player.prepareToPlay()
            player.volume = 1.0
            player.play()
        }
    }
    
    func stopPlay() {
        if let d = self.delegate {
            d.didFinishPlayback()
        }
        if let paths = self.tableAudioView.indexPathsForSelectedRows {
            for path in paths {
                self.tableAudioView.deselectRow(at: path, animated: true)
            }
        }
        if let player = self.audioPlayer {
            player.pause()
        }
        self.audioPlayer = nil
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch  let error as NSError {
            print(error.localizedDescription)
            return
        }
    }
    
    private func isPlaying() -> Bool {
        if let player = self.audioPlayer {
            return player.isPlaying
        }
        return false
    }
}

extension RecordingsViewController: AVAudioPlayerDelegate {
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let e = error {
            print(e.localizedDescription)
            print("decode error")
        }
        self.stopPlay()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.stopPlay()
    }
}

extension RecordingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isPlaying() {
            self.stopPlay()
        }
        let recording = self.recordings[indexPath.row]
        self.play(audiourl: recording.path)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let result = self.recordings.count
        if result > 0 {
            self.tableAudioView.isHidden = false
        }
        else {
            self.tableAudioView.isHidden = true
        }
        return result
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var audiocell = tableView.dequeueReusableCell(withIdentifier: cellid)
        if audiocell == nil {
            audiocell = UITableViewCell(style: .subtitle, reuseIdentifier: cellid)
        }
        let recording = self.recordings[indexPath.row]
        audiocell?.textLabel?.text = recording.name
        audiocell?.detailTextLabel?.text = recording.path.absoluteString
        return audiocell!
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let filemanager = FileManager.default
            let recording = self.recordings[indexPath.row]
            do {
                try filemanager.removeItem(at: recording.path)
                self.recordings.remove(at: indexPath.row)
                self.tableAudioView.reloadData()
            }catch(let err){
                print("Error while deleteing \(err)")
            }
        }
    }
}

