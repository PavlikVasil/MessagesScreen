//
//  NetworkState.swift
//  MessagesScreen
//
//  Created by Павел on 01.06.2021.
//

import Foundation
import Alamofire

struct NetworkState {

    var isInternetAvailable:Bool
    {
        return NetworkReachabilityManager()!.isReachable
    }
}
