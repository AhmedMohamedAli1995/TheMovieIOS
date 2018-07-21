//
//  HomeCollectionViewController.swift
//  Online Movies
//
//  Created by Sayed Abdo on 3/30/18.
//  Copyright © 2018 jets. All rights reserved.
//

import UIKit
import SDWebImage
import Dropdowns

private let reuseIdentifier = "Cell"


class HomeCollectionViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {

    var jsonArray : Array = [Movies]()
    var movieObject : Movies = Movies()
    var urlObject = URLS()
    
    @IBOutlet weak var selectButton: UIBarButtonItem!
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
 
    

    override func viewDidLoad() {
    
        super.viewDidLoad()
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        let items = ["Now Playing","Popular", "Top Rated"]
        let titleView = TitleView(navigationController: navigationController!, title: "Menu", items: items)
        titleView?.action = { [weak self] index in
        
            switch index {
            case 0:
        API.getJason(url: URLS.now_Playing,flage:"movie" , completion: { (error :Error?, arr : Any) in
            if error == nil {
                var array = arr as! Array<Any>
                self?.jsonArray = array as! Array<Movies>
                self?.homeCollectionView.reloadData()
            }
            else {
                
                FavouriteCollectionViewController.showAlert(mess:"Please check your internet Connection", tit: "No internet Connection")
            }
            
        })
            case 1:
                API.getJason(url: URLS.popular,flage:"movie" , completion: { (error :Error?, arr : Any) in
                    if error == nil {
                        var array = arr as! Array<Any>
                        self?.jsonArray = array as! Array<Movies>
                        self?.homeCollectionView.reloadData()
                    }
                    else {
                        
                        FavouriteCollectionViewController.showAlert(mess:"Please check your internet Connection", tit: "No internet Connection")
                    }
                    
                })

            case 2 :
                API.getJason(url: URLS.top_Rated,flage:"movie" , completion: { (error :Error?, arr : Any) in
                    if error == nil {
                        var array = arr as! Array<Any>
                        self?.jsonArray = array as! Array<Movies>
                        self?.homeCollectionView.reloadData()
                    }
                    else {
                        
                        FavouriteCollectionViewController.showAlert(mess:"Please check your internet Connection", tit: "No internet Connection")
                    }
                    
                })

                
            default:
                
                print("Error In Swith case Drop down List")
                
                
            }//DropDownSwitch
        }
        // code to collection cell apperance
        navigationItem.titleView = titleView
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: width / 2, height: width / 2)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        homeCollectionView!.collectionViewLayout = layout
        homeCollectionView.layer.borderColor = UIColor.black.cgColor
        homeCollectionView.layer.borderWidth = 2.0
        homeCollectionView.layer.cornerRadius = 2.0
        
    }//viewDidLoad
    override func viewWillAppear(_ animated: Bool) {
        API.getJason(url: URLS.now_Playing,flage:"movie" , completion: { (error :Error?, arr : Any) in
            if error == nil {
                var array = arr as! Array<Any>
                self.jsonArray = array as! Array<Movies>
                self.homeCollectionView.reloadData()
            }
            else {
                
                FavouriteCollectionViewController.showAlert(mess:"Please check your internet Connection", tit: "No internet Connection")
            }
            
        })

    }





     func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return jsonArray.count
    }

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let image=UIImage(named:"panda.jpg");
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeCollectionViewCell
        
        var imagePath :String  = urlObject.imageBaseURL + jsonArray[indexPath.row].posterPath
        var imageUrl : URL = URL(string: imagePath)!
        

        cell.cellImage.sd_setImage(with: imageUrl , placeholderImage: image )
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        let minSpace: CGFloat = 0
        
        return CGSize(width : (homeCollectionView.frame.size.width - minSpace)/4, height: 2)
    }
  


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        movieObject.title = jsonArray[indexPath.row].title
        movieObject.releaseDate = jsonArray[indexPath.row].releaseDate
        movieObject.voteAvarage = jsonArray[indexPath.row].voteAvarage
        movieObject.Duration = jsonArray[indexPath.row].Duration
        movieObject.overView = jsonArray[indexPath.row].overView
        movieObject.id = jsonArray[indexPath.row].id
        movieObject.posterPath = jsonArray[indexPath.row].posterPath
        
var objectFromDetails = self.storyboard?.instantiateViewController(withIdentifier:"MovieDetailVC") as! MovieDetailsTableViewController
        objectFromDetails.movieDetailsObject = movieObject
        var imagePath :String  = urlObject.imageBaseURL + jsonArray[indexPath.row].posterPath
        var imageUrl : URL = URL(string: imagePath)!
        objectFromDetails.imgUrl = imageUrl
 self.navigationController?.pushViewController(objectFromDetails, animated: true)
        
        
    }

}
