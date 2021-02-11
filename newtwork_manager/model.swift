//
//  model.swift
//  newtwork_manager
//
//  Created by Jackson on 10/2/2021.
//

struct user_list:Codable {
    var list:[user_data]
}


struct user_data : Identifiable,Codable {
    var id:Int
    var name : String
    var age:Int
    
}

struct user_info: Identifiable,Codable{
    var id:Int
    var username:String
    var password:String
}
