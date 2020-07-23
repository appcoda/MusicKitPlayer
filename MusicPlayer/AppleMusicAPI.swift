//
//  AppleMusicAPI.swift
//  MusicPlayer
//
//  Created by Sai Kambampati on 5/30/20.
//  Copyright © 2020 Sai Kambmapati. All rights reserved.
//

import Foundation
import StoreKit

class AppleMusicAPI {
    let developerToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiIsImtpZCI6Ikw1WjQ3TEQ0N1cifQ.eyJpc3MiOiJYSllNRzc2MjI2IiwiZXhwIjoxNjA2NzYwNjIwLCJpYXQiOjE1OTA5ODkwMTl9.3D0q4GwH4wucCVnnEcuXcSDjNZJJEHCJydruCdAbueAMfDhpdVea4Dvi38DXHGMrA_Mew1JyedP_M-78-T4cjw"

    func getUserToken() -> String {
        var userToken = String()
        
        // 1
        let lock = DispatchSemaphore(value: 0)
        
        // 2
        SKCloudServiceController().requestUserToken(forDeveloperToken: developerToken) { (receivedToken, error) in
            // 3
            guard error == nil else { return }
            if let token = receivedToken {
                userToken = token
                lock.signal()
            }
        }
        
        // 4
        lock.wait()
        return userToken
    }
    
    func fetchStorefrontID() -> String {
        let lock = DispatchSemaphore(value: 0)
        var storefrontID: String! 
        
        let musicURL = URL(string: "https://api.music.apple.com/v1/me/storefront")!
        var musicRequest = URLRequest(url: musicURL)
        musicRequest.httpMethod = "GET"
        musicRequest.addValue("Bearer \(developerToken)", forHTTPHeaderField: "Authorization")
        musicRequest.addValue(getUserToken(), forHTTPHeaderField: "Music-User-Token")
        
        URLSession.shared.dataTask(with: musicRequest) { (data, response, error) in
            guard error == nil else { return }
            
            if let json = try? JSON(data: data!) {
                let result = (json["data"]).array!
                let id = (result[0].dictionaryValue)["id"]!
                storefrontID = id.stringValue
                lock.signal()
            }
        }.resume()
        
        lock.wait()
        return storefrontID
    }
    
    func searchAppleMusic(_ searchTerm: String!) -> [Song] {
        let lock = DispatchSemaphore(value: 0)
        var songs = [Song]()

        let musicURL = URL(string: "https://api.music.apple.com/v1/catalog/\(fetchStorefrontID())/search?term=\(searchTerm.replacingOccurrences(of: " ", with: "+"))&types=songs&limit=25")!
        var musicRequest = URLRequest(url: musicURL)
        musicRequest.httpMethod = "GET"
        musicRequest.addValue("Bearer \(developerToken)", forHTTPHeaderField: "Authorization")
        musicRequest.addValue(getUserToken(), forHTTPHeaderField: "Music-User-Token")
        
        URLSession.shared.dataTask(with: musicRequest) { (data, response, error) in
            guard error == nil else { return }
            if let json = try? JSON(data: data!) {
                let result = (json["results"]["songs"]["data"]).array!
                for song in result {
                    let attributes = song["attributes"]
                    let currentSong = Song(id: attributes["playParams"]["id"].string!, name: attributes["name"].string!, artistName: attributes["artistName"].string!, artworkURL: attributes["artwork"]["url"].string!)
                    songs.append(currentSong)
                }
                lock.signal()
            } else {
                lock.signal()
            }
        }.resume()
        
        lock.wait()
        return songs
    }
}
