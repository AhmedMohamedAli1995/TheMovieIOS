//
//  MovieDetailsTableViewController.swift
//  Online Movies
//
//  Created by Sayed Abdo on 4/6/18.
//  Copyright © 2018 jets. All rights reserved.
//

import UIKit
import SDWebImage
import WCLShineButton
import CoreData
import Cosmos
class MovieDetailsTableViewController: UITableViewController{
    var arrayOfAuthor:Array = [String] ()
    var arrayOfContent:Array = [String]()
    var returnedArrayOfContent :Array = [MovieDetailForReview]()
    var objFromCustomTable : ReviewsViewController = ReviewsViewController()
    @IBOutlet weak var overwiewDetail: UITextView!
    var movieDetailsObject :Movies = Movies()
    var objectFromTFavourite  : FavouriteCollectionViewController
    = FavouriteCollectionViewController()
    var flage : String = ""
    var chech : String = ""
    var objectComeFromFavourite:Movies = Movies()
    
    

    let image=UIImage(named:"panda.jpg");
     var  arrayComeFromCoreData:Array<NSManagedObject> = Array<NSManagedObject>()
    var checkArray :Array<MovieTable> = Array<MovieTable>()
   var imgUrl : URL!
    @IBOutlet weak var imgDetails: UIImageView!
    @IBOutlet weak var titleDetails: UILabel!
    @IBOutlet weak var rateDetails: UILabel!
    @IBOutlet weak var DurationDetail: UILabel!
    @IBOutlet weak var releaseYearDetail: UILabel!
    @IBOutlet weak var reviewsTableView: UITableView!
    
@IBOutlet weak var stars: CosmosView!
    var urlObject2:URLS = URLS()
    
    @IBAction func showTralir(_ sender: Any) {
        var objectFromTralirs = self.storyboard?.instantiateViewController(withIdentifier:"TralirsVC") as! TralirsViewController
        objectFromTralirs.movieId = movieDetailsObject.id
        self.navigationController?.pushViewController(objectFromTralirs, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleDetails.text = movieDetailsObject.title
         print(movieDetailsObject.id)
       
     rateDetails.text=(movieDetailsObject.voteAvarage).description + "/10"
        releaseYearDetail.text = movieDetailsObject.releaseDate
        DurationDetail.text = movieDetailsObject.Duration
        imgDetails.sd_setImage(with: imgUrl, placeholderImage: image)
        overwiewDetail.text = movieDetailsObject.overView
        stars.rating = Double(movieDetailsObject.voteAvarage/2.0)
        
        stars.settings.updateOnTouch = false
        stars.settings.fillMode = .half
         getReviews()
        
        

    }
    override func viewWillAppear(_ animated: Bool) {
       
        
        reviewsTableView.delegate = objFromCustomTable
        reviewsTableView.dataSource = objFromCustomTable
        
        var param1 = WCLShineParams()
        param1.bigShineColor = UIColor(rgb: (153,152,38))
        param1.smallShineColor = UIColor(rgb: (250,51,51))
        let bt1 = WCLShineButton(frame: .init(x: 240, y: 15, width: 60, height: 60), params: param1)
        bt1.image = WCLShineImage.star
      
        bt1.addTarget(self, action: #selector(action), for: .valueChanged)
        view.addSubview(bt1)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let manageContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MovieTable")
        do{
            checkArray = try manageContext.fetch(fetchRequest) as! [MovieTable]
            if(checkArray.count != 0){
             
            for i in 0...(checkArray.count)-1 {
               
                
                if(checkArray[i].title == movieDetailsObject.title){
                    
       
                    bt1.fillColor = UIColor(rgb: (250,250,250))
                    bt1.color = UIColor(rgb: (250,250,0))
                    
                    
                    bt1.image = WCLShineImage.star
                    flage = "false"
                  
                
                      break
                }
              
                if(checkArray[i].title != movieDetailsObject.title){
                    bt1.fillColor = UIColor(rgb: (250,250,0))
                    bt1.color = UIColor(rgb: (250,250,250))
                    bt1.image = WCLShineImage.star
                    flage = "true"
                  
                }
            
                }
            }
            else {
               
                bt1.fillColor = UIColor(rgb: (250,250,0))
                bt1.color = UIColor(rgb: (250,250,250))
                bt1.image = WCLShineImage.star
                flage = "true"
            }
        }catch let error as NSError {
            print(error.localizedDescription)
        }
        
      
    }
    
    @objc func action(){
        
     if(flage == "true"){
         var imagePath2 :String  = urlObject2.imageBaseURL + movieDetailsObject.posterPath
    
        let appDelegate = UIApplication.shared.delegate as!AppDelegate
        let manageContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName:"MovieTable", in:manageContext)
        let movie = NSManagedObject(entity: entity!, insertInto: manageContext)
        movie.setValue(movieDetailsObject.title, forKey:"title")
        movie.setValue(imagePath2, forKey:"image_path")
        print(imagePath2)
        movie.setValue(movieDetailsObject.releaseDate, forKey:"releaseDate")
        movie.setValue(movieDetailsObject.id, forKey:"id")
    
        movie.setValue(movieDetailsObject.voteAvarage, forKey:"rating")
   
        movie.setValue(movieDetailsObject.Duration, forKey:"duration")
        do{
            try manageContext.save()
            
          
            
        }
        catch let error as NSError{
            
            print(error.localizedDescription)
        }
        }
        if(flage == "false"){
          
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let manageContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MovieTable")
            let predicate = NSPredicate(format: "title == %@",movieDetailsObject.title )
            fetchRequest.predicate = predicate
            do{
                arrayComeFromCoreData = try manageContext.fetch(fetchRequest)
                
            }catch let error as NSError {
                print(error.localizedDescription)
            }

   
            
            for i in 0...(arrayComeFromCoreData.count)-1{
                
                
                
            manageContext.delete(arrayComeFromCoreData[i])
           
                do{
                    try manageContext.save()
                    
                    
                    
                }
                catch let error as NSError{
                    
                    print(error.localizedDescription)
                }
            }
              flage = "true"
            
        }

    }
    func getReviews(){
        var tralirsURL : String = ""
        tralirsURL = "https://api.themoviedb.org/3/movie/\(movieDetailsObject.id)/reviews?api_key=479232edd3efda1b9f316b26d891d23a"
        
        API.getJason(url:tralirsURL, flage :"content") { (error : Error?, arr : Any) in
            if error == nil {
            var array = arr as! Array<Any>
            self.returnedArrayOfContent = array as! Array<MovieDetailForReview>
            for i in 0...(self.returnedArrayOfContent.count)-1{
                var author :String = String()
                var content :String = String()
                author = self.returnedArrayOfContent[i].author
                content = self.returnedArrayOfContent[i].content
                self.arrayOfAuthor.append(author)
                self.arrayOfContent.append(content)
            }
            DispatchQueue.main.async {
                self.objFromCustomTable.arrayOfAuthor = self.arrayOfAuthor
                self.objFromCustomTable.arrayOfContent = self.arrayOfContent
                self.reviewsTableView.reloadData()
            }
            
        }
        
        else {
            
            FavouriteCollectionViewController.showAlert(mess:"No internet Connection ", tit:"No internet !")
        }
       
    }
    }

}
