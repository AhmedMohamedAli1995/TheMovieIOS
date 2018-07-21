//
//  API.swift
//  Online Movies
//
//  Created by Sayed Abdo on 4/1/18.
//  Copyright © 2018 jets. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class API: NSObject {
    class func getJason(url:String,flage:String,completion:@escaping (_ error:Error?,_ array:Any)
        ->Void){
        Alamofire.request(url, method:.get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                switch response.result
                {
                case.failure:
                    completion(response.error!,false)
                case.success:
                     var arrayOfMovies:[Movies] = []
                     var arrayOfDetails:[MovieDetails] = []
                     var arrayOfContent:[MovieDetailForReview] = []
                    let json = JSON(response.value)
                    var returnedMovie = json["results"].array
                     if(flage == "movie"){
                    for i in 0 ... (returnedMovie?.count)!-1 {
                        var movie = Movies()
                     
                        movie.title = returnedMovie![i]["title"].string!
                        movie.overView = returnedMovie![i]["overview"].string!
                        movie.releaseDate = returnedMovie![i]["release_date"].string!
                        movie.posterPath = returnedMovie![i]["poster_path"].string!
                        movie.voteAvarage = returnedMovie![i]["vote_average"].float!
                        movie.Duration = returnedMovie![i]["original_language"].string!
                        movie.id = returnedMovie![i]["id"].int!
                        
                        arrayOfMovies.append(movie)
    
                       }
                        completion( nil , arrayOfMovies)
                     }
                     if(flage == "details"){

                        for i in 0...(returnedMovie?.count)!-1{
                            var movieDetail : MovieDetails = MovieDetails()
                            movieDetail.key = returnedMovie![i]["key"].string!
                            movieDetail.type = returnedMovie![i]["type"].string!
                            movieDetail.name = returnedMovie![i]["name"].string!

                            arrayOfDetails.append(movieDetail)
                        }
                        completion( nil , arrayOfDetails)
                       
                        
                     }
                     if(flage == "content"){
                        
                        if(returnedMovie?.count != 0){
                    for i in 0...(returnedMovie?.count)!-1{
var movieDetailContent : MovieDetailForReview = MovieDetailForReview()
                            movieDetailContent.author = returnedMovie![i]["author"].string!
                            movieDetailContent.content = returnedMovie![i]["content"].string!
                        
                arrayOfContent.append(movieDetailContent)
                        }
                        }
                        if(returnedMovie?.count == 0){
                            
                            var movieDetailContent : MovieDetailForReview = MovieDetailForReview()
                            movieDetailContent.author = "No Review"
                            movieDetailContent.content = "No Content Here"
                            
                            arrayOfContent.append(movieDetailContent)
                        }
                        completion( nil , arrayOfContent)
                        
                        
                    }
                    
                    
                
                    
                }
                
        }
        
    }
}
