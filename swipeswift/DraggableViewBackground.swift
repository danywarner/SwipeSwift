//
//  DraggableViewBackground.swift
//  swipeswift
//
//  Created by Daniel Warner on 12/28/15.
//  Copyright © 2015 Daniel Warner. All rights reserved.
//

import Foundation
import UIKit

class DraggableViewBackground: UIView, DraggableViewDelegate{
    
    private var cardsLoadedIndex: Int = 0
    private var loadedCards:Array<DraggableView>!
    private var exampleCardLabels: Array<String>!
    private var allCards: Array<DraggableView>!

    let MAX_BUFFER_SIZE = 2
    let CARD_HEIGHT:CGFloat = 386
    let CARD_WIDTH:CGFloat = 290

    override init(frame: CGRect){
        super.init(frame: frame)
        super.layoutSubviews()
        self.setupView()
        exampleCardLabels = ["first","second","third","fourth","last"]
        loadedCards = []
        allCards = []
        cardsLoadedIndex = 0
        self.loadCards()
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func createDraggableViewWithDataAtIndex(index: Int) -> DraggableView {
        let size = CGRectMake((self.frame.size.width - CARD_WIDTH)/2, (self.frame.size.height - CARD_HEIGHT)/2, CARD_WIDTH, CARD_HEIGHT)
        let draggableView = DraggableView(frame: size)
        draggableView.information.text = exampleCardLabels[index]
        draggableView.delegate = self
        return draggableView
        
    }
    
    func loadCards(){
        if exampleCardLabels.count > 0 {
            var numLoadedCardsCap: Int
            if exampleCardLabels.count > MAX_BUFFER_SIZE {
                numLoadedCardsCap = MAX_BUFFER_SIZE
            } else {
                numLoadedCardsCap = exampleCardLabels.count
            }
            
            for var i = 0 ; i < exampleCardLabels.count ; i++ {
                let newCard = self.createDraggableViewWithDataAtIndex(i)
                allCards.append(newCard)
                
                if i < numLoadedCardsCap {
                    loadedCards?.append(newCard)
                }
            }
            
            for var i = 0 ; i < loadedCards.count ; i++ {
                if i > 0 {
                    self.insertSubview(loadedCards[i], belowSubview: loadedCards[i-1])
                } else {
                    self.addSubview(loadedCards[i])
                }
                cardsLoadedIndex++
            }
            
        }
    }
    
    func cardSwipedLeft(card: UIView){
        loadedCards.removeAtIndex(0)
        print("here1 \(cardsLoadedIndex)")
        if cardsLoadedIndex < allCards.count {
            print("here2")
            loadedCards.append(allCards[cardsLoadedIndex])
        print("here3")
            cardsLoadedIndex++
            print("here4")
            self.insertSubview(loadedCards[MAX_BUFFER_SIZE - 1], belowSubview: loadedCards[MAX_BUFFER_SIZE - 2])
            print("here5")
        }
        
        //include own action here
    }
    
    func cardSwipedRight(card: UIView){
        loadedCards.removeAtIndex(0)
        if cardsLoadedIndex < allCards.count {
            loadedCards.append(allCards[cardsLoadedIndex])
            cardsLoadedIndex++
            self.insertSubview(loadedCards[MAX_BUFFER_SIZE - 1], belowSubview: loadedCards[MAX_BUFFER_SIZE - 2])
        }
    }
    
    func setupView(){
        self.backgroundColor = UIColor(red: 92.0/255, green: 93.0/255, blue: 95.0/255, alpha: 1.0)
    }
    
    
}