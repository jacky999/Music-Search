//
//  MusicTableViewCell.swift
//  Music-Search
//

import UIKit

class MusicTableViewCell: UITableViewCell {
    @IBOutlet weak var musicImage: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameAlbumNameLabel: UILabel!

  
    func updateMusicTabelCell( music: Music) {
        
        var music = music
        trackNameLabel.text = music.trackName
        artistNameAlbumNameLabel.text = music.artistName + HORIZONTALBAR + music.albumName
        musicImage.sd_setImage(with: URL(string: music.image30), placeholderImage: UIImage(named: "no-Image-Icon"), options: .progressiveDownload)
    }
    
}
