//
//  MusicSearchViewController.swift
//  Music-Search
//


import UIKit
import MBProgressHUD

var keyWords = String()
var musicSearchResultList = [Music] ()
var music = Music()

class MusicSearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var musicTableView: UITableView!
    
    let activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        musicTableView.delegate = self
        musicTableView.dataSource = self
        searchBar.delegate = self
        
        self.navigationController?.navigationBar.topItem?.title = "Main"
        
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading..."

        if let searchKeyWords = searchBar.text, !searchKeyWords.isEmpty {
            
            keyWords = inputParsing(input: searchKeyWords)
            
            if keyWords.isAlphabeta {
                
                let urlString = creatITuneSearchUrlString(searchKeyWords: keyWords)
                
                if let url = URL(string: urlString) {
                    
                    music.getiTuneDate(url: url) {
                        (result: [Music]) in
                        
                        if result.count > 0 {
                            musicSearchResultList = result
                            
                        } else {
                            let noResult = Music(trackName: "NORESULT")
                            musicSearchResultList.removeAll()
                            musicSearchResultList.insert(noResult, at: 0)
                        }
                 
                        DispatchQueue.main.async {
                            self.musicTableView?.reloadData()
                            loadingNotification.hide(animated: true)
                        }
                    }
                }
                
            } else {
                let noResult = Music(trackName: "NORESULT")
                musicSearchResultList.removeAll()
                musicSearchResultList.insert(noResult, at: 0)
                
                DispatchQueue.main.async {
                    self.musicTableView?.reloadData()
                    loadingNotification.hide(animated: true)
                }
            }
            
            self.view.endEditing(true)
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicSearchResultList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as? MusicTableViewCell {
            
            var result = musicSearchResultList[indexPath.row]
            
            if result.trackName.isEqual(NORESULT) {
                cell.isUserInteractionEnabled = false
            } else {
                cell.isUserInteractionEnabled = true
            }
            
            cell.updateMusicTabelCell(music: result)
            
            return cell
            
        } else {
            return MusicTableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow!
        let musicSent = musicSearchResultList[indexPath.row]
    
        guard let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "ResultDetailsViewController") as? ResultDetailsViewController else {
            print ("ResultDetailsViewController not found!")
            return
        }
        
        destinationController.musicDetailsTitle = MORE + keyWords
        destinationController.musicDetails = musicSent
        
        self.navigationController?.pushViewController(destinationController, animated: true)
        
    }
    
    
    
    
}

