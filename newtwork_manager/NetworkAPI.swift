//
//  NetworkAPI.swift
//  newtwork_manager
//
//  Created by Jackson on 11/2/2021.
//

import Foundation
import Alamofire

class NetworkAPI{
    
    //send requset to get data json using our Network Manager
    static func Get_data_json(complecting:@escaping (Result<user_list,Error>)->Void){
        NetworkManager.share.request_get(URL_Path: "data.json", parameters: nil){ response in
            switch response{
            case.success(let data):
                let result : Result<user_list,Error> = parseJson(data)
                complecting(result)
            case .failure(let error):
                complecting(.failure(error))
            }
        }
    }
    
    //Just take an example for request to get sometging
    @discardableResult
    static func User_reg(complection:@escaping (Result<user_info,Error>)->Void) -> DataRequest{ //if weed need to get request return DataRequest to cancle the request
        //TODO
        NetworkManager.share.reques_post(URL_Path: "", parameters: ["user_accound":"123","user_password":"123"]){ response in
                //TODO
        }
        //.cancel() -> to cancel our request
    }
    
    static func User_login(complection:@escaping (Result<user_info,Error>)->Void){
        NetworkManager.share.reques_post(URL_Path: "", parameters: ["user_accound":"123","user_token":"xxxxxToken"]){ response in
                //TODO
        }
    }
    
    static func User_logout(complection:@escaping (Result<user_info,Error>)->Void){
        NetworkManager.share.reques_post(URL_Path: "", parameters:nil){ response in
                //TODO
        }
    }
    
    
    //parse json data if need
    private static func parseJson<T:Decodable>(_ data:Data)->Result<T,Error>{
        //generic type =》 detect type in return type
        
        //try to parse json(guard success) decode data to data model T(generic type)
        guard let result = try? JSONDecoder().decode(T.self, from: data) else {
            //NSError: custom own error
            //In this case: domain(what error),code(error code),userInfo(user reable string)
            //NSLocalizedDescriptionKey is used to set user reable string
            //message store in localizedDescription
            let error = NSError(domain: "NetworkAPI",
                                code: 0,
                                userInfo: [NSLocalizedDescriptionKey:"Can't parase JSON Data"])
            //error.localizedDescription
            return .failure(error)
        }
        return .success(result)
    }
}
