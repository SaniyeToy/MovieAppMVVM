//
//  ApiClient.swift
//  MovieApp
//
//  Created by MacOS on 28.10.2021.
//

import Foundation
import RxSwift
import Alamofire

class ApiClient {
    
    static func getMovieList(params: [String: Any]) -> Observable<MovieListResponse> {
        return request(ApiEndPoint.movieList(params: params))
    }
    
    static func getMovieDetails(params: [String: Any]) -> Observable<MovieDetailsResponse> {
        return request(ApiEndPoint.movieDetails(params: params))
    }
    
    
    private static func request<T: Codable> (_ urlConvertible: URLRequestConvertible) -> Observable<T> {

          //Create an RxSwift observable, which will be the one to call the request when subscribed to
          return Observable<T>.create { observer in
              //Trigger the HttpRequest using AlamoFire (AF)
              let request = AF.request(urlConvertible).responseDecodable { (response: AFDataResponse<T>) in
                  //Check the result from Alamofire's response and check if it's a success or a failure
                  switch response.result {

                  case .success(let value):
                      //Everything is fine, return the value in onNext
                    
                      observer.onNext(value)
                      observer.onCompleted()
                  case .failure(let error):
                      //Something went wrong, switch on the status code and return the error
                      
                      print(response.response)
                      print(response.data)
                      print(response.description)
                      print(error.errorDescription)
                      print("test")
                      observer.onError(error)
                      observer.onCompleted()

                  }
              }
              //Finally, we return a disposable to stop the request
              return Disposables.create {
                  request.cancel()
              }
          }
      }
  }
