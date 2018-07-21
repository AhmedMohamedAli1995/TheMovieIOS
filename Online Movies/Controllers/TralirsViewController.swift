//
//  TralirsViewController.swift
//  Online Movies
//
//  Created by Sayed Abdo on 4/7/18.
//  Copyright © 2018 jets. All rights reserved.
//

import UIKit

class TralirsViewController: UIViewController, UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate{
    @IBOutlet weak var youtubeWebView: UIWebView!
    @IBOutlet weak var tralirsTableView: UITableView!
    @IBOutlet weak var tralirLabel: UILabel!
     @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    
    var count : Int = 1
    var movieId : Int = 0
    var returnedArrayy:Array = [MovieDetails] ()
    var arrayOfKeys:Array = [String] ()
    var arrayOfNames:Array = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tralirLabel.text = "Watch Trailers"
        self.youtubeWebView.delegate = self
        getKeys()
        tralirsTableView.delegate = self
        tralirsTableView.dataSource = self
        self.indicatorView.stopAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return arrayOfKeys.count
        
    }
    func getKeys(){
        
        var tralirsURL : String = ""
        tralirsURL = "https://api.themoviedb.org/3/movie/\(movieId)/videos?api_key=479232edd3efda1b9f316b26d891d23a"
//        reviews
        API.getJason(url:tralirsURL, flage :"details") { (error : Error?, arr : Any) in
            if error == nil {
            
            var array = arr as! Array<Any>
            self.returnedArrayy = array as! Array<MovieDetails>
       
            for i in 0...(self.returnedArrayy.count)-1{
                var key :String = String()
                var name :String = String()
                key = self.returnedArrayy[i].key
                name = self.returnedArrayy[i].name
                self.arrayOfKeys.append(key)
                self.arrayOfNames.append(name)
                self.tralirsTableView.reloadData()
            
                           }
            }
            else {
                
                 FavouriteCollectionViewController.showAlert(mess:"No internet Connection ", tit:"No internet !")
            }
           
         
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel!.text = arrayOfNames[indexPath.row]
        return cell
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Yarb")
        self.indicatorView.startAnimating()
        var finalKey:String = arrayOfKeys[indexPath.row]
        var urlToPlayMovie:String = "https://www.youtube.com/watch?v=" + finalKey
        loadViedo(url: urlToPlayMovie)
       
        
    }
    func loadViedo( url : String){
 
        self.youtubeWebView.loadRequest(URLRequest(url: URL(string: url)!))
        
        
            }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Trailers"
    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        <#code#>
//    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.indicatorView.stopAnimating()
        print("Callllllllllllllllllleed")
    }

}
