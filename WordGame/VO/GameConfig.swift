//
//  GameConfig.swift
//  WordGame
//
//  Created by xiaog on 2018/6/23.
//  Copyright © 2018年 xiaog. All rights reserved.
//

import Foundation
import UIKit

class GameConfig: NSObject {
    
    var current:Int = -1;
    var arrGameScenes: Array<GameItem> = Array.init()
    
    private override init() {
        super.init()
    }
    static let shared = GameConfig()
    
    func loadGame(config:String) {
        let arrConfigs:Array<String>? = config.components(separatedBy: "\n")
        
        for item in arrConfigs! {
            let gameScene = GameItem();
            gameScene.parseJson(jsonString: item)
            arrGameScenes.append(gameScene)
        }
    }
    
    func nextGame() -> GameItem {
        current = (current + 1 ) % (arrGameScenes.count);
        return arrGameScenes[current];
    }
    
    func gameItem() -> GameItem{
        return arrGameScenes[current];
    }
}
