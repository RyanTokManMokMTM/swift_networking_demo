//
//  ContentView.swift
//  Networking_Swift
//
//  Created by Jackson on 10/2/2021.
//

import SwiftUI

struct ContentView: View {
    @State private var req_text = ""
    
    var body: some View {
        VStack{
            Text(req_text)
                .font(.title)
            
            Button(action:{
                SendRequest()
            }){
                Text("Get").font(.largeTitle)
            }
            
            Button(action: {
                req_text = ""
            }) {
                Text("Cancle").font(.largeTitle)
            }
        }
    }
    
    func SendRequest(){
        NetworkAPI.Get_data_json{ response in
            switch response{
            case .success(let data):update_txt(str:"\(data.list.count)")
            case .failure(let error):update_txt(str:error.localizedDescription)
            }
        }
    }
    
    func update_txt(str:String){
        //main thread
        //   DispatchQueue.main.async {
        req_text = str
        // }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
