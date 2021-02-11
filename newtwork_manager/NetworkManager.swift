//
//  NetworkManager.swift
//  newtwork_manager
//
//  Created by Jackson on 10/2/2021.
//

import Foundation
import Alamofire

typealias NetworkRequestType = Result<Data,Error>
typealias NetworkResquestCompltion = (NetworkRequestType)->Void

private let BaseServerURL = "https://raw.githubusercontent.com/RyanTokManMokMTM/swift_networking/master/"


//Note: newtwork request must in threading -> if it need to will suck client, client won't response before request is done
class NetworkManager{
    
    //must be share,may request use samy reference class
    static let share = NetworkManager()
    
    var RequsetHeader :HTTPHeaders {
        ["User_Id":"admin","token":"xxxx"] //just a example
    }
    
    //set init to privte -> no body can create other networkmanager()
    private init(){
        //TODO: NOTHING
    }
    
    //GET Request -> get can be not parameters
    
    @discardableResult //can be ignore the return value, need return value coz->sometime need to be cancel
    func request_get(URL_Path:String,parameters:Parameters?,completion:@escaping NetworkResquestCompltion)->DataRequest{
        AF.request(
            BaseServerURL + URL_Path, //server url
            parameters: parameters, //key=vale
            headers: RequsetHeader,//["Content-type":"application/json"] etc
            requestModifier: {$0.timeoutInterval = 15})//time to resend or cancle
            .responseData{ Response in
                //this closure will implement in sub threading
                switch Response.result{
                case .success(let data): completion(.success(data)) //if success pass to completion,completing will implement after request is done
                case .failure(let error): completion(self.handleError(error)) // if failure pass to completion,completing will implement after request is done
                }
            }
    }
    
    @discardableResult //can be ignore the return value, need return value coz->sometime need to be cancel
    func reques_post(URL_Path:String,parameters:Parameters?,completion:@escaping NetworkResquestCompltion) -> DataRequest{
        AF.request(
            BaseServerURL+URL_Path,
            method: .post, // default is GET Metho
            parameters: parameters,
            encoding: JSONEncoding.prettyPrinted,// parameter encode to json and store in body !:POST parameter is store in body
            headers: RequsetHeader,
            requestModifier: {$0.timeoutInterval = 15} //time is out after 15s and resend or canceled
        )
        .responseData{ Response in
            //this closure will implement in sub threading
            switch Response.result{
            case .success(let data): completion(.success(data)) //completing will implement after request is done
            case .failure(let error): completion(self.handleError(error)) //completing will implement after request is done
            }
        //.responseJson :
        /*
            requset may include {stateCode:0 ,data:{}} or {stateCode:1, msg:error}
             responseJson =>maybe a array or dict(Any)
             we need to handle the state code ,if code = 1 get data else get error msg
        */
            
        }
    }
    
    private func handleError(_ Error:AFError)->NetworkRequestType{
        //Result<Data(Data type),Error(AFError type)>
        //NSError -> Error -> AFError(API)
        //Underly error?
        if let underlayer = Error.underlyingError{
            let nserror = underlayer as NSError
            let code = nserror.code
            if  code == NSURLErrorNotConnectedToInternet ||
                code == NSURLErrorTimedOut ||
                code == NSURLErrorInternationalRoamingOff ||
                code == NSURLErrorDataNotAllowed ||
                code == NSURLErrorCannotFindHost ||
                code == NSURLErrorCannotConnectToHost ||
                code == NSURLErrorNetworkConnectionLost {
                    var userInfo = nserror.userInfo
                    userInfo[NSLocalizedDescriptionKey] = "Your connection is got some troble!"
                    let currentError = NSError(domain: "NetworkAPI", code: code, userInfo: userInfo)
                    return .failure(currentError)
            }
                
        }
        
        //not underlying error just normal error
        return .failure(Error)
    }
    
//        @discardableResult
//        func request_download()-> DataRequest{
//          //  return
//        }
//
//        @discardableResult
//        func request_upload()-> DataRequest{
//           // return
//        }
//
//    }
}
