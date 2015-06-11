//
//  GameScene.swift
//  ProjetoTAES1
//
//  Created by bsi ccet on 5/14/15.
//  Copyright (c) 2015 bsi ccet. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate{

    
    struct PhysicsCategory {
        static let None : UInt32 = 0
        static let Bola : UInt32 = 0b001
        static let Chegada : UInt32 = 0b010
        static let Portal : UInt32 = 0b011
    }
    
    var faseBuilder: FaseBuilder?
    var numeroDaFase : Int = 1
    var fase : Fase?
    var bola : SKShapeNode?
    var poliLinha : [SKShapeNode] = []
    var linhas : [SKShapeNode] = []
    var index : Int = 0
    var path : CGMutablePath?
    var chegada : SKShapeNode?
    var bolaCaindo : Bool = false
    var bolaEmContatoComPortal : Bool = false
    var botaoVoltar : SKLabelNode?
    var botaoLimpar : SKLabelNode?
    var botaoDesfazer : SKLabelNode?
    var linhaCriada : Bool = false
    var pontos : [SKSpriteNode] = []
    var seta : SKSpriteNode?
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        self.backgroundColor = UIColor.whiteColor()
        //criarObjetos()
        definirFisicaDoAmbiente()
        
        criarFase()
        
        
    }
    
    func criarBotoes(){
        botaoVoltar = SKLabelNode(text: "Voltar")
        botaoVoltar!.fontSize = 20;
        botaoVoltar!.fontColor = UIColor.grayColor()
        botaoVoltar?.fontName = "Arial"
        botaoVoltar!.position = CGPointMake(frame.midX - 70, frame.minY + 120)
        self.addChild(botaoVoltar!)
        
        botaoLimpar = SKLabelNode(text: "Limpar")
        botaoLimpar!.fontSize = 20;
        botaoLimpar?.fontName = "Arial"
        botaoLimpar!.fontColor = UIColor.grayColor()
        botaoLimpar!.position = CGPointMake(frame.midX + 30, frame.minY + 120)
        self.addChild(botaoLimpar!)
        
        botaoDesfazer = SKLabelNode(text: "Desfazer")
        botaoDesfazer!.fontSize = 20;
        botaoDesfazer?.fontName = "Arial"
        botaoDesfazer!.fontColor = UIColor.grayColor()
        botaoDesfazer!.position = CGPointMake(frame.midX + 130, frame.minY + 120)
        self.addChild(botaoDesfazer!)
    }
    
    
    func criarFase(){
        faseBuilder = FaseBuilder(frame: frame)
        faseBuilder?.build()
        fase = faseBuilder?.getFase(numeroDaFase)
        criarBola(fase!.posicaoBola)
        criarChegada(fase!.posicaoChegada)
        criarBarreiras(fase!.barreiras)
        criarPortais(fase!.portais)
        criarBotoes()
        criarSeta()
    }
    
    func criarSeta(){
        seta = SKSpriteNode(imageNamed: "seta")
        seta!.anchorPoint = CGPointMake(0.5, 0.5)
        seta!.position = CGPointMake(frame.midX, frame.midY+160)
        seta!.alpha = 0.05
        seta?.size = CGSize(width: seta!.size.width, height: seta!.size.height + 50)
        self.addChild(seta!)
    }
    
    func criarPortais(portais : [Portal]){
        for portal in portais {
            
            
            portal.portal1.physicsBody?.categoryBitMask = PhysicsCategory.Portal
            portal.portal1.physicsBody?.contactTestBitMask = PhysicsCategory.None
            portal.portal1.physicsBody?.dynamic = false
            portal.portal1.physicsBody?.affectedByGravity = false
            self.addChild(portal.portal1)
            pontos.append(portal.portal1)
            
            portal.portal2.physicsBody?.categoryBitMask = PhysicsCategory.Portal
            portal.portal2.physicsBody?.contactTestBitMask = PhysicsCategory.None
            portal.portal2.physicsBody?.dynamic = false
            portal.portal2.physicsBody?.affectedByGravity = false
            self.addChild(portal.portal2)
            pontos.append(portal.portal2)
            
        }
    }

    
    func criarBarreiras(barreiras : [Barreira]){
        for barreira in barreiras{
            let linha = SKShapeNode();

            let pathLinha = CGPathCreateMutable();
            CGPathMoveToPoint(pathLinha, nil, barreira.inicio.x,barreira.inicio.y );
            CGPathAddLineToPoint(pathLinha, nil, barreira.fim.x, barreira.fim.y);
            
            linha.path = pathLinha;
            linha.strokeColor = UIColor.blackColor();
            linha.physicsBody = SKPhysicsBody(edgeChainFromPath: pathLinha)
            linhas.append(linha)
            self.addChild(linha)
        }
    }
    
    func definirFisicaDoAmbiente(){
        physicsWorld.gravity = CGVectorMake(0, -3)
        physicsWorld.contactDelegate = self
        seta?.runAction(SKAction.rotateToAngle(0, duration: 0))
    }

    
    func criarBola(posicao: CGPoint){
       
        bola = SKShapeNode(circleOfRadius: 15)
        bola!.position = posicao
        bola!.fillColor = UIColor.grayColor()
        bola!.physicsBody = SKPhysicsBody(circleOfRadius: 15)
        bola!.physicsBody!.dynamic = false
        bola!.physicsBody?.categoryBitMask = PhysicsCategory.Bola
        bola!.physicsBody?.contactTestBitMask = PhysicsCategory.Chegada | PhysicsCategory.Portal
        self.addChild(bola!)
    }
    
    func criarChegada(posicao: CGPoint){
        
        var xChegada = posicao.x
        var xChegadaFisico = xChegada + 15
        var yChegada = posicao.y
        var yChegadaFisico = yChegada + 15
        
        var rectChegada = CGRectMake(xChegada, yChegada, 30, 30)
        chegada = SKShapeNode()
        chegada!.path = CGPathCreateWithRect(rectChegada, nil)
        chegada!.strokeColor = UIColor.blackColor()
        chegada!.physicsBody = SKPhysicsBody(rectangleOfSize: rectChegada.size, center: CGPointMake(xChegadaFisico,yChegadaFisico))
        chegada!.physicsBody?.categoryBitMask = PhysicsCategory.Chegada
        chegada!.physicsBody?.contactTestBitMask = PhysicsCategory.None
        chegada!.physicsBody?.dynamic = false
        chegada!.physicsBody?.affectedByGravity = false
        self.addChild(chegada!)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            if(nodeAtPoint(location) == botaoVoltar){
                voltarBola()
            }else if(!bolaCaindo){
                if (nodeAtPoint(location) == bola!){
                    bola!.physicsBody?.dynamic = true
                    bolaCaindo = true
                }else if(nodeAtPoint(location) == botaoLimpar){
                    removerLinhas()
                }else if(nodeAtPoint(location) == botaoDesfazer){
                    removerUltimaLinha()
                }else{
                    self.path = CGPathCreateMutable()
                    CGPathMoveToPoint(path!, nil, location.x, location.y)
                    poliLinha.append(SKShapeNode(path: path))
                    poliLinha[index].strokeColor = UIColor.redColor()
                    self.addChild(poliLinha[index])
                    linhaCriada = true
                }
            }else{
                inverterGravidade()
                
            }
        }
    }
    
    func inverterSeta(){
        seta?.runAction(SKAction.rotateByAngle(CGFloat(M_PI), duration: 0.0))
    }
    
    func voltarBola(){
        bolaCaindo = false
        bola?.position = fase!.posicaoBola
        bola?.physicsBody?.dynamic = false
        definirFisicaDoAmbiente()
    }
    
    func inverterGravidade(){
        if(physicsWorld.gravity == CGVectorMake(0, -3)){
            physicsWorld.gravity = CGVectorMake(0, 3)
        }else{
            physicsWorld.gravity = CGVectorMake(0, -3)
        }
        
        inverterSeta()
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            if(linhaCriada){
                let location = touch.locationInNode(self)
                if(nodeAtPoint(location) != bola!){
                    CGPathAddLineToPoint(path, nil, location.x, location.y)
                    poliLinha[index].path = path
                }
            }
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
         for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if (linhaCriada){
                poliLinha[index].physicsBody = SKPhysicsBody(edgeChainFromPath: path)
                index++
                linhaCriada = false
            }
        }
    }
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        var a = contact.bodyA
        var b = contact.bodyB
        
        if (b.categoryBitMask == PhysicsCategory.Bola && a.categoryBitMask == PhysicsCategory.Chegada) {
            resetarCenario()
        }
        
        if(b.categoryBitMask == PhysicsCategory.Bola && a.categoryBitMask == PhysicsCategory.Portal){
                for portal in fase!.portais{
                    if(a.node == portal.portal1){
                        bola?.removeFromParent()
                        let posicao = portal.portal2.position
                        criarBola(ajustarPosicaoBolaNoPortal(portal.portal2.position))
                        bola?.physicsBody?.dynamic = true
                    }
                    if(a.node == portal.portal2){
                        bola?.removeFromParent()
                        criarBola(ajustarPosicaoBolaNoPortal(portal.portal1.position))
                        bola?.physicsBody?.dynamic = true
                    }
                }
        }

    }
    
    func ajustarPosicaoBolaNoPortal(posicao : CGPoint) -> CGPoint{
        var retorno = posicao
        retorno.x = posicao.x + 35
        return retorno
    }
    
    func resetarCenario(){
        removerTudo()
        if(numeroDaFase < faseBuilder?.numeroDeFases){
            numeroDaFase++
            criarFase()
            definirFisicaDoAmbiente()
        }else{
            //TODO
        }
    }
    
    func removerTudo(){
        bola?.removeFromParent()
        bolaCaindo = false
        chegada?.removeFromParent()
        removerLinhas()
        removerBarreiras()
        seta?.removeFromParent()
        removerPortais()
    }
    
    func removerBarreiras(){
        for linha in linhas {
            linha.removeFromParent()
        }
        linhas.removeAll(keepCapacity: false)
    }
    
    func removerLinhas(){
        for linha in poliLinha {
            linha.removeFromParent()
        }
        poliLinha.removeAll(keepCapacity: false)
        index = 0
    }
    
    func removerUltimaLinha(){
        if(poliLinha.count > 0){
            poliLinha.removeLast().removeFromParent()
            index--
        }
    }
    
    func removerPortais(){
        for portal in fase!.portais{
            portal.portal1.removeFromParent()
            portal.portal2.removeFromParent()
        }
    }
}
