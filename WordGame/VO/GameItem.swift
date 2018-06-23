//
//  GameItem.swift
//  WordGame
//
//  Created by xiaog on 2018/6/23.
//  Copyright © 2018年 xiaog. All rights reserved.
//

import Foundation

class GameItem: NSObject {
    
    var arrConfirmedResults: Array<String> = Array.init()
    var word: String?
    var sourceLang: String?
    var targetLang: String?
    var wordLocations: NSDictionary?
    var characterGrid:Array<Array<String>>?
    
    func parseJson(jsonString:String) {
        let dicConfig:NSDictionary = try! JSONSerialization.jsonObject(with: jsonString.data(using: String.Encoding.utf8)!, options: []) as! NSDictionary
        
        word = dicConfig.value(forKey: "word") as? String
        sourceLang = dicConfig.value(forKey: "source_language") as? String
        targetLang = dicConfig.value(forKey: "target_language") as? String
        characterGrid = dicConfig.value(forKey: "character_grid") as? Array<Array<String>>
        wordLocations = dicConfig.value(forKey: "word_locations") as? NSDictionary
    }
    
    func reset() {
        arrConfirmedResults.removeAll()
    }
    
    func confirm(result: String) -> Bool {
        if let item = wordLocations?.value(forKey: result) {
            if (!arrConfirmedResults.contains(item as! String)) {
                arrConfirmedResults.append(item as! String)
            }
            return true
        }
        
        return false;
    }
    
    func isGameOver() -> Bool {
        return arrConfirmedResults.count >= (wordLocations?.allKeys.count)!
    }
}
