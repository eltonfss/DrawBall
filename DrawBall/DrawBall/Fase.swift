//
//  Fase.swift
//  DrawBall
//
//  Created by bsi ccet on 6/1/15.
//  Copyright (c) 2015 bsi ccet. All rights reserved.
//

import SpriteKit

class Fase {
    var posicaoBola : CGPoint
    var posicaoChegada : CGPoint
    var barreiras : [Barreira]
    var portais : [Portal]
    
    init() {
        posicaoChegada = CGPointMake(0, 0)
        posicaoBola = CGPointMake(0, 0)
        barreiras = []
        portais = []
    }
    
    func adicionaBarreira(inicio: CGPoint, fim: CGPoint) {
        barreiras += [Barreira(inicio: inicio, fim: fim)]
    }
    
    func adicionaPortal(ponto1: CGPoint, ponto2: CGPoint) {
        portais += [Portal(ponto1: ponto1, ponto2: ponto2)]
    }
}

class Barreira {
    var inicio : CGPoint
    var fim : CGPoint
    
    init(inicio: CGPoint, fim: CGPoint) {
        self.inicio = inicio
        self.fim = fim
    }
}

class Portal{
    var portal1 : SKSpriteNode
    var portal2 : SKSpriteNode
    
    init(ponto1: CGPoint, ponto2: CGPoint){
        portal1 = SKSpriteNode(imageNamed: "portal")
        portal1.anchorPoint = CGPointMake(0.5, 0.5)
        portal1.position = ponto1
        portal1.physicsBody = SKPhysicsBody(texture: portal1.texture, size: portal1.size)
        portal2 = SKSpriteNode(imageNamed: "portal")
        portal2.anchorPoint = CGPointMake(0.5, 0.5)
        portal2.position = ponto2
        portal2.physicsBody = SKPhysicsBody(texture: portal2.texture, size: portal2.size)
    }
}