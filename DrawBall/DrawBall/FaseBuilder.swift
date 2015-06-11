//
//  FaseBuilder.swift
//  DrawBall
//
//  Created by bsi ccet on 6/1/15.
//  Copyright (c) 2015 bsi ccet. All rights reserved.
//

import SpriteKit

class FaseBuilder {
    
    var fases : [Fase] = []
    var frame : CGRect
    let numeroDeFases = 5
    
    init(frame : CGRect){
        self.frame = frame
    }
    
    func getFase(numeroDaFase: Int) -> Fase{
        return fases[numeroDaFase-1]
    }
    
    func build() -> [Fase] {
        fases += [criaFase1()]
        fases += [criaFase2()]
        fases += [criaFase3()]
        fases += [criaFase4()]
        fases += [criaFase5()]
        return fases;
    }

    func criaFase1() -> Fase {
        var fase = Fase()
        fase.posicaoBola = CGPointMake(frame.midX - 150, frame.maxY - 40)
        fase.posicaoChegada = CGPointMake(frame.midX + 150, frame.maxY - 400)
        
        
        return fase;
    }

    func criaFase2() -> Fase {
        var fase = Fase()
        
        fase.posicaoBola = CGPointMake(frame.midX - 150, frame.maxY - 40)
        fase.posicaoChegada = CGPointMake(frame.midX + 150, frame.maxY - 400)
        fase.adicionaBarreira(CGPointMake(frame.midX, frame.maxY - 150), fim: CGPointMake(frame.midX, frame.maxY-250))
        
        return fase;
    }
    
    func criaFase3() -> Fase {
        var fase = Fase()
        fase.posicaoChegada = CGPointMake(frame.midX - 150, frame.maxY - 40)
        fase.posicaoBola = CGPointMake(frame.midX + 150, frame.maxY - 400)
        fase.adicionaBarreira(CGPointMake(frame.midX, frame.maxY - 150), fim: CGPointMake(frame.midX, frame.maxY-250))
        return fase;
    }
    
    func criaFase4() -> Fase {
        var fase = Fase()
        
        fase.posicaoBola = CGPointMake(frame.midX - 150, frame.maxY - 40)
        fase.posicaoChegada = CGPointMake(frame.midX + 150, frame.maxY - 400)
        fase.adicionaBarreira(CGPointMake(frame.midX + 100, frame.maxY - 50), fim: CGPointMake(frame.midX-100, frame.maxY-450))
        return fase;
    }
    
    func criaFase5() -> Fase {
        var fase = Fase()
        fase.posicaoBola = CGPointMake(frame.midX - 150, frame.maxY - 40)
        fase.posicaoChegada = CGPointMake(frame.midX + 150, frame.maxY - 400)
        fase.adicionaBarreira(CGPointMake(frame.minX, frame.minY), fim: CGPointMake(frame.maxX, frame.maxY))
        fase.adicionaPortal(CGPointMake(frame.midX - 150, frame.maxY - 400),ponto2: CGPointMake(frame.midX + 50, frame.maxY - 450))
        return fase;
    }
}