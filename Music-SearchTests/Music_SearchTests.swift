//
//  Music_SearchTests.swift
//  Music-SearchTests
//

import XCTest
@testable import Music_Search;

class Music_SearchTests: XCTestCase {
    
    var testMusic = Music()
    
    override func setUp() {
        super.setUp()
    }
    
    func test_inputParsing_extraEmptySpace() {
        let input1 = " Tom Waits"
        let expected = "Tom Waits"
        XCTAssertEqual(inputParsing(input: input1), expected)
    }
    
    
    func test_inputParsing_multEmptySpace() {
        let input1 = " Tom  Waits  "
        let expected = "Tom Waits"
        XCTAssertEqual(inputParsing(input: input1), expected)
    }
    
    func test_inputParsing_seperatedWithComma() {
        let input1 = "Tom,Waits"
        let expected = "Tom Waits"
        XCTAssertEqual(inputParsing(input: input1), expected)
    }
    
    func test_inputParsing_seperatedWithCommaEmptySpace() {
        let input1 = "Tom, Waits"
        let expected = "Tom Waits"
        XCTAssertEqual(inputParsing(input: input1), expected)
    }
    
    func test_inputParsing_seperatedWithCommaMultiEmptySpace() {
        let input1 = "  Tom  , Waits   "
        let expected = "Tom Waits"
        XCTAssertEqual(inputParsing(input: input1), expected)
    }
    
    
    func test_creatITuneSearchUrlString() {
        let keyWords = "Tom Waits"
        let expected = "https://itunes.apple.com/search?term=Tom+Waits"
        XCTAssertEqual(creatITuneSearchUrlString(searchKeyWords: keyWords), expected)
    }
    
    func test_creatITuneSearchUrlString_emptyInput() {
        let keyWords = ""
        let expected = ""
        XCTAssertEqual(creatITuneSearchUrlString(searchKeyWords: keyWords), expected)
    }
    
    func test_getiTuneDate_getResults() {
        
        let urlString = "https://itunes.apple.com/search?term=tom+waits"
        let url = URL(string: urlString)
        
        self.testMusic.getiTuneDate(url: url!, completion: {
            (result: [Music]) in
            XCTAssertTrue(result.count > 0 )
        })
    }
    
    func test_getiTuneDate_noResults() {
        
        let urlString = "https://itunes.apple.com/search?term=tom+waitsqwerty"
        let url = URL(string: urlString)
        let expected = NORESULT
        self.testMusic.getiTuneDate(url: url!, completion: {
            (result: [Music]) in
            XCTAssertEqual(result[0].trackName, expected )
        })
    }

    
    func test_creatLyricsWikiaUrlString() {
        let artistName = "Tom Waits"
        let trackName = "Hold On"
        let expected = "http://lyrics.wikia.com/wikia.php?controller=LyricsApi&method=getSong&artist=Tom%20Waits&song=Hold%20On"
        XCTAssertEqual(creatLyricsWikiaUrlString(artistName: artistName, songName: trackName), expected)
    }
    
    
    func test_creatLyricsWikiaUrlString_artistName_Empty() {
        let artistName = ""
        let trackName = "Hold On"
        let expected = ""
        XCTAssertEqual(creatLyricsWikiaUrlString(artistName: artistName, songName: trackName), expected)
    }
    
    func test_creatLyricsWikiaUrlString_trackName_Empty() {
        let artistName = "Tom Waits"
        let trackName = ""
        let expected = ""
        XCTAssertEqual(creatLyricsWikiaUrlString(artistName: artistName, songName: trackName), expected)
    }
    
    
    func test_getLyricsWikia_getLyrics() {
        
        let urlString = "http://lyrics.wikia.com/wikia.php?controller=LyricsApi&method=getSong&artist=Tom%20Waits&song=Hold%20On"
        let url = URL(string: urlString)
        
        self.testMusic.getLyricsWikia(url: url!) {
            (result: String) in
            XCTAssertNotNil(result)
            
        }
    }
    
    
    func test_getLyricsWikia_getNoLyrics() {
        
        let urlString = "http://lyrics.wikia.com/wikia.php?controller=LyricsApi&method=getSong&artist=Terry%20Gilliam&song=The%20Imaginarium%20of%20Doctor%20Parnassus"
        let url = URL(string: urlString)
        
        self.testMusic.getLyricsWikia(url: url!) {
            (result: String) in
            XCTAssertEqual(result, "No Lyrics Available!" )
            
        }
    }
    
    
    func test_getiTuneDate_PerformanceTesting() {
        
        let urlString = "https://itunes.apple.com/search?term=tom+waits"
        let url = URL(string: urlString)
        
        self.measure {
            self.testMusic.getiTuneDate(url: url!, completion: {
                (result: [Music]) in
                print("completed")
            })
        }
    }
    
    func test_getLyricsWikia_PerformacneTesting() {
        
        let urlString = "http://lyrics.wikia.com/wikia.php?controller=LyricsApi&method=getSong&artist=Tom%20Waits&song=Hold%20On"
        let url = URL(string: urlString)
        
        self.measure {
            self.testMusic.getLyricsWikia(url: url!) {
                (result: String) in
                
                print("completed")
            }
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    
}

