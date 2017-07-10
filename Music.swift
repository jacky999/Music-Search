//
//  HTTPandParsing.swift
//  Music-Search
//
//

import Foundation
// import AFNetworking

struct Music {
    private var _artistName: String!
    private var _trackName: String!
    private var _albumName: String!
    private var _image30: String!
    private var _image100: String!
    private var _lyrics: String!
    private var _ituneSearchURL: String!
    
    var artistName: String {
        mutating get {
            if _artistName == nil {
                
                _artistName = ""
            }
            return _artistName
        }
        set (newVal) {
            self._artistName = newVal
        }
        
    }
    
    var albumName: String {
        mutating get {
            if _albumName == nil {
                _albumName = ""
            }
            return _albumName
        }
        set (newVal) {
            self._albumName = newVal
        }
    }
    
    var trackName: String {
        mutating get {
            
            if _trackName == nil {
                _trackName = ""
            }
            return _trackName
        }
        set (newVal) {
            self._trackName = newVal
        }
    }
    
    var image30: String {
        mutating get {
            if _image30 == nil {
                
                _image30 = ""
            }
            return _image30
        }
        set (newVal) {
            self._image30 = newVal
        }
    }
    
    var image100: String {
        mutating get {
            if _image100 == nil {
                
                _image100 = ""
            }
            return _image100
        }
        set (newVal) {
            self._image100 = newVal
        }
    }
    
    var lyrics: String {
        mutating get {
            if _lyrics == nil {
                _lyrics = ""
            }
            return _lyrics
        }
        set (newVal) {
            self._lyrics = newVal
        }
    }
    
    init() {
        
    }
    
    init(trackName: String) {
        self._trackName = trackName
    }
    
    func getiTuneDate(url: URL, completion: @escaping (_ result: [Music]) -> () ) {
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) -> Void in
            
            guard error == nil else {
                print("getTodayWeatherDate: ", error!)
                return
            }
            guard let data = data else {
                print("getTodayWeatherDate: ","Data is empty")
                return
            }
            
            completion(self.JasonParsingiTuneData(data: data))
        }
        
        task.resume()
        
    }
    
    private func JasonParsingiTuneData(data: Data?) -> ([Music]) {
        
        var musicList = [Music]()
        
        if data != nil {
            do {
                if let jsondata = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    
                    if let results = jsondata["results"] as? [NSDictionary] {
                        
                        if (results.count == 0) {
                            let music = Music(trackName: "NORESULT")
                            musicList.append(music)
                            
                            return musicList
                        }
                        
                        for resultObject in results {
                            var music = Music()
                            if let artistName = resultObject["artistName"] as? String {
                                music.artistName = artistName
                            }
                            if let trackName = resultObject["trackName"] as? String {
                                music.trackName = trackName
                            }
                            if let collectionName = resultObject["collectionName"] as? String {
                                music.albumName = collectionName
                            }
                            if let imageName30 = resultObject["artworkUrl30"] as? String {
                                music.image30 = imageName30
                            }
                            if let imageName100 = resultObject["artworkUrl100"] as? String {
                                music.image100 = imageName100
                            }
            
                            musicList.append(music)
                        }
                    }
                }
            } catch let error as NSError {
                print(error)
            }
            
        } else {
            print ("Data is empty!")
        }
        
        return musicList
        
    }
    
    func getLyricsWikia(url: URL, completion: @escaping (_ result: String) -> () ) {
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) -> Void in
            
            guard error == nil else {
                print("getLyricsWikia: ", error!)
                return
            }
            guard let data = data else {
                print("getLyricsWikia: ","Data is empty")
                return
            }
            
            completion(self.JasonParsingLyricsWikia(data: data))
            
        }
        
        task.resume()
        
    }
    
    private func JasonParsingLyricsWikia(data: Data?) -> (String) {
        
        var lyrics = NOLYRICS
        
        if data != nil {
           
            do {
                if let jsondata = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                    if let result = jsondata["result"] as? NSDictionary {
                        if let lyricsText = result["lyrics"] as? String,!(lyricsText.isEmpty)  {
                            lyrics = lyricsText
                        } else {
                            lyrics = NOLYRICS
                        }
                    }
                }
                return lyrics
                
            } catch let error as NSError {
                print("Lyrics data parsing error: ", error)
            }
            
        } else {
            print ("Data is empty!")
        }
        return lyrics
    }

}



