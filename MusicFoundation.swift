//
//  MusicFoundation.swift
//  Music-Search
//
//

import Foundation

extension String {
    var isAlphabeta: Bool {
        return !isEmpty && range(of: "[^a-zA-Z ]", options: .regularExpression) == nil
    }
}

extension String
{
    func trim() -> String
    {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
}

func inputParsing(input: String?) -> (String) {
    var result = String()
    
    if let string = input, !string.isEmpty {
        let string1 = string.trim()
        let string2 = string1.components(separatedBy: [" ", ","])
        let string3 = string2.filter({
            let s = $0 as? String
            if !(s != nil && s != "") { return false }
            return true
        })
        result = string3.joined(separator: " ")
    }
    
    return result
    
  }


func creatITuneSearchUrlString (searchKeyWords: String?) -> String {
    var result = String ()
    
    if var keyWords = searchKeyWords, !keyWords.isEmpty {
        keyWords = (keyWords.replacingOccurrences(of: " ", with: "+"))
        result = ITUNE_URL_BASE + keyWords
    } else {
        print ("Search keywords is empty!")
        result = ""
    }
    
    return result
}


func creatLyricsWikiaUrlString (artistName: String?, songName: String?) -> String {
    
    var result = String ()
    
    guard var artist = artistName, !(artistName?.isEmpty)! else {
        print("Artist name is nil or empty.")
        return result
    }
    
    guard var song = songName, !(songName?.isEmpty)! else {
        print("Song name is nil or empty.")
        return result
    }
    
    artist = artist.replacingOccurrences(of: " ", with: "%20")
    song = song.replacingOccurrences(of: " ", with: "%20")
    result = LYRICS_WIKIA_BASE + "&artist=" + artist  + "&song=" + song
    
    return result
}








