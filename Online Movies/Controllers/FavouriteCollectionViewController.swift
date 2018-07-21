//
//  FavouriteCollectionViewController.swift
//  Online Movies
//
//  Created by Sayed Abdo on 4/9/18.
//  Copyright © 2018 jets. All rights reserved.
//

import UIKit
import SDWebImage
import CoreData


private let reuseIdentifier = "cell"

class FavouriteCollectionViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate{
    var favouriteObject : Movies = Movies()
    var arrayComeFromDetails : Array <MovieTable> = Array<MovieTable>()
    var urlsObject : URLS = URLS()

    @IBOutlet weak var favouriteCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        favouriteCollectionView.delegate = self
        favouriteCollectionView.dataSource = self
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: width / 2, height: width / 2)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        favouriteCollectionView!.collectionViewLayout = layout
        favouriteCollectionView.layer.borderColor = UIColor.black.cgColor
        favouriteCollectionView.layer.borderWidth = 2.0
        favouriteCollectionView.layer.cornerRadius = 2.0
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let manageContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MovieTable")
        do{
            arrayComeFromDetails = try manageContext.fetch(fetchRequest) as! [MovieTable]
            if(arrayComeFromDetails.count == 0){
                FavouriteCollectionViewController.showAlert(mess: "No Favourite Yet", tit: "Favaourit")
                
            }
        }catch let error as NSError {
            print(error.localizedDescription)
        }
        
        self.favouriteCollectionView.reloadData();
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
      
        return 1
    }


     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
  
        return arrayComeFromDetails.count
    }

   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let image=UIImage(named:"panda.jpg");
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"cell", for: indexPath) as! FavouriteCollectionViewCell
    var imagePath :String  =  arrayComeFromDetails[indexPath.row].image_path!

        var imageUrl : URL = URL(string: imagePath)!
        
        cell.favouriteImageCell.sd_setImage(with: imageUrl , placeholderImage: image )

        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var movieTable:MovieTable = arrayComeFromDetails[indexPath.row]
        var movie:Movies = Movies()
        movie.id = Int(movieTable.id)
        movie.title = movieTable.title!
        
       
        movie.Duration = movieTable.duration!
        movie.releaseDate = movieTable.releaseDate!
        movie.voteAvarage = Float(movieTable.rating)
       var objectFromDetails = self.storyboard?.instantiateViewController(withIdentifier:"MovieDetailVC") as! MovieDetailsTableViewController
    objectFromDetails.movieDetailsObject = movie
        var imageUrl2 : URL = URL(string:movieTable.image_path!)!
        objectFromDetails.imgUrl = imageUrl2
        self.navigationController?.pushViewController(objectFromDetails, animated: true)
    
        
    }
    static func showAlert( mess : String , tit : String){
        let alert = UIAlertController(title: tit, message: mess, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:{ action in
        }))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }


}
