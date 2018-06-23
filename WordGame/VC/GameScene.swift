//
//  GameScene.swift
//  WordGame
//
//  Created by xiaog on 2018/6/22.
//  Copyright © 2018年 xiaog. All rights reserved.
//

import UIKit
import YogaKit

class GameScene: UIViewController, LetterSelectionDelegate {
    
    var labelWord:UILabel?
    var labelHint:UILabel?
    var letterContainer:LetterSelectionView?
    var btnNext: UIButton?
    var loadingActivity: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.color(hexValue: 0x4eb2f0)
        
        setupViews()
        setupListeners()
        fetchGameConfig()
    }
    
    func setupViews() {
        labelWord = UILabel.init(frame: CGRect.zero)
        self.view.addSubview(labelWord!)
        labelWord?.textColor = UIColor.white
        labelWord?.font = UIFont.systemFont(ofSize: 32)

        labelHint = UILabel.init(frame: CGRect.zero)
        self.view.addSubview(labelHint!)
        labelHint?.textColor = UIColor.white
        labelHint?.font = UIFont.systemFont(ofSize: 18)
        
        letterContainer = LetterSelectionView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenW, height: kScreenW))
        self.view.addSubview(letterContainer!)
        letterContainer?.delegate = self;
        letterContainer?.backgroundColor = UIColor.white
        
        btnNext = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 140, height: 50))
        self.view.addSubview(btnNext!)
        btnNext?.setTitle("NEXT GAME", for: .normal)
        btnNext?.isHidden = true
        btnNext?.layer.borderColor = UIColor.white.cgColor
        btnNext?.layer.borderWidth = 1.0
        btnNext?.setCorner(cornerRadius: 10)
        
        loadingActivity = UIActivityIndicatorView.init(frame: self.view.bounds)
        self.view.addSubview(loadingActivity!)
        loadingActivity?.activityIndicatorViewStyle = .gray
    }
    
    func layoutSubviews() {
        labelWord?.top = 44
        labelWord?.centerX = self.view.width/2
        labelHint?.top = (labelWord?.bottom)!+10
        labelHint?.centerX = (labelWord?.centerX)!
        letterContainer?.top = (labelHint?.bottom)!+20
        btnNext?.top = (letterContainer?.bottom)!+24.0;
        btnNext?.centerX = self.view.width/2
    }
    
    func setupListeners() {
        btnNext?.addTarget(self, action: #selector(startGame), for: .touchUpInside)
    }
    
    @objc func startGame() {
        let gameItem = GameConfig.shared.nextGame()
        labelWord?.text = gameItem.word
        labelWord?.sizeToFit()
        
        labelHint?.text = "\(gameItem.sourceLang ?? "") To \(gameItem.targetLang ?? "")"
        labelHint?.sizeToFit()
        
        letterContainer?.setupViews(gameData: gameItem.characterGrid!)
        btnNext?.isHidden = true
        layoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutSubviews()
    }
    
    func fetchGameConfig() {
        loadingActivity?.startAnimating()
        DispatchQueue.global().async {
            
            if let gameConfig = try? NSString.init(contentsOf: URL.init(string:kConfigUrl )!, encoding: String.Encoding.utf8.rawValue) {
                DispatchQueue.main.async {
                    self.loadingActivity?.stopAnimating()
                    GameConfig.shared.loadGame(config: gameConfig as String)
                    self.startGame()
                }
            } else {
                DispatchQueue.main.async {
                    self.loadingActivity?.stopAnimating()
                    NSLog("Game error!")
                }
            }
        }
    }
    
    func selectWordLocation(location: String) -> Bool {
        NSLog("selected word location: \(location)")
        let item = GameConfig.shared.gameItem()
        if (item.confirm(result: location)) {
            if (item.isGameOver()) {
                //game over
                btnNext?.isHidden = false
            }
            return true
        }
        
        return false
    }
}

