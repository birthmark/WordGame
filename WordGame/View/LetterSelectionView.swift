//
//  LetterSelectionView.swift
//  WordGame
//
//  Created by xiaog on 2018/6/22.
//  Copyright © 2018年 xiaog. All rights reserved.
//

import UIKit

protocol LetterSelectionDelegate {
    func selectWordLocation(location: String) -> Bool
}

class LetterSelectionView: UIView {

    var arrLetterViews:Array<LetterView> = Array.init()
    var rows:Int?
    var columns:Int?
    var delegate:LetterSelectionDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(gameData: Array<Array<String>>) {
        self.removeAllSubviews()
        self.arrLetterViews.removeAll()
        
        rows = gameData.count
        columns = gameData.first?.count
        let itemSize = (kScreenW-CGFloat(columns!)+1) / CGFloat(columns!);
        
        for row in 0..<rows! {
            for column in 0..<columns! {
                let view = LetterView.init(frame: CGRect.zero)
                view.width = itemSize
                view.height = itemSize
                view.left = CGFloat(column) * itemSize + CGFloat(column)
                view.top = CGFloat(row) * itemSize + CGFloat(row)
                view.value = gameData[row][column]
                view.tag = row*rows!+column
                addSubview(view)
                arrLetterViews.append(view)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        arrLetterViews.removeAll()
        let touch = touches.first!
        let point = touch.location(in: self)
        if let letterView = viewForPoint(point: point) {
            if (!arrLetterViews.contains(letterView)) {
                arrLetterViews.append(letterView)
                letterView.isSelected = true
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let point = touch.location(in: self)
        if let letterView = viewForPoint(point: point) {
            if (!arrLetterViews.contains(letterView)) {
                arrLetterViews.append(letterView)
                letterView.isSelected = true
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        calculateLocation()
        for item in arrLetterViews {
            item.isSelected = false
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for item in arrLetterViews {
            item.isSelected = false
        }
    }
    
    private func calculateLocation() {
        var arrLoactions: Array<String> = Array.init()
        
        //sort by tag
        arrLetterViews.sort { (item1, item2) -> Bool in
            return item1.tag < item2.tag
        }
        
        for item in arrLetterViews {
            arrLoactions.append(item.location(columns: columns!))
        }
        
        let location:String = arrLoactions.joined(separator: ",")
        if (delegate?.selectWordLocation(location: location))! {
            for item in arrLetterViews {
                item.isHighlighted = true
            }
        }
    }
    
    func viewForPoint(point: CGPoint) -> LetterView? {
        for item in subviews {
            if (item.frame.insetBy(dx: 0, dy: 0).contains(point)) {
                return item as? LetterView
            }
        }
        return nil
    }
}
