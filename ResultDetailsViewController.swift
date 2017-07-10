//
//  ResultDetailsViewController.swift
//  Music-Search
//

import UIKit
import MBProgressHUD

extension UIViewController {
    func performToReturnBack()  {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

class ResultDetailsViewController: UIViewController {
    
    var musicDetails : Music?
    var musicDetailsTitle = String ()
    
    @IBOutlet weak var lyricsContent: UITextView!
    @IBOutlet weak var musicImage100: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameAndAlbumNameLabel: UILabel!
    @IBOutlet weak var lyricsTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !(musicDetailsTitle.isEmpty) {
            self.navigationItem.title = musicDetailsTitle
        }
        if (musicDetails != nil) {
            fetchLyrics()
        }
    }
    
    func fetchLyrics() {
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."
        
        let urlString = creatLyricsWikiaUrlString(artistName: musicDetails?.artistName, songName: musicDetails?.trackName)
        
        if let url = URL(string: urlString) {
            
            musicDetails?.getLyricsWikia(url: url) {
                (result: String) in
                
                if (!result.isEmpty) {
                    self.musicDetails?.lyrics = result
                } else {
                    self.musicDetails?.lyrics = NOLYRICS
                }
                DispatchQueue.main.async {
                    self.resultDetailsUIUpdate()
                    loadingNotification.hide(animated: true)
                }
            }
        } else {
            self.musicDetails?.lyrics = NOLYRICS
            DispatchQueue.main.async {
                self.resultDetailsUIUpdate()
                loadingNotification.hide(animated: true)
                
            }
        }
    }
    
    func resultDetailsUIUpdate() {
        
        trackNameLabel.text = musicDetails?.trackName
        artistNameAndAlbumNameLabel.text = musicDetails!.artistName + HORIZONTALBAR + musicDetails!.albumName
        lyricsTitleLabel.text = LYRICSLABEL  + musicDetails!.trackName
        lyricsContent.text = musicDetails!.lyrics
        musicImage100.sd_setImage(with: URL(string: musicDetails!.image100), placeholderImage: UIImage(named: "no-Image-Icon"), options: .progressiveDownload)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        performToReturnBack()
        
    }
    
    
}
