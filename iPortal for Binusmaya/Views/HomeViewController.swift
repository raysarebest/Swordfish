//
//  HomeViewController.swift
//  iPortal for Binusmaya
//
//  Created by Kevin Yulias on 26/08/19.
//  Copyright © 2019 Kevin Yulias. All rights reserved.
//

import AsyncDisplayKit

class HomeViewController: ASViewController<ASDisplayNode> {
    var homeViewComponents = HomeViewComponents()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
    }
    
    func setupUI () {
        let origin = CGPoint(x: 0, y: Screen.safeAreaTop)
        let size = CGSize(width: Screen.width, height: Screen.height)
        
        let scrollNode = ASScrollNode()
        scrollNode.automaticallyManagesSubnodes = true
        scrollNode.automaticallyManagesContentSize = true
        scrollNode.frame = CGRect(origin: origin, size: size)

        scrollNode.scrollableDirections = .init(arrayLiteral: [.up, .down])
        
        scrollNode.layoutSpecBlock = { node, constrainedSize -> ASLayoutSpec in
            return self.getScrollNodeLayoutSpecBlock()
        }
        
        let wrapperViewNode = ASDisplayNode()
        wrapperViewNode.frame = CGRect(origin: origin, size: size)
        wrapperViewNode.addSubnode(scrollNode)
        
        self.view.addSubnode(wrapperViewNode)
    }
    
    func getScrollNodeLayoutSpecBlock () -> ASLayoutSpec {
        let scrollNodeWrapper = ASStackLayoutSpec.vertical()
        scrollNodeWrapper.style.width = ASDimensionMakeWithPoints(Screen.width)
        scrollNodeWrapper.style.height = ASDimensionMakeWithPoints(Screen.height)
        
        scrollNodeWrapper.children = [
            self.homeViewComponents.getProfileBar(),
            self.homeViewComponents.getScheduleBar(),
            self.homeViewComponents.getPaymentBar(),
            self.homeViewComponents.getTaskBar(),
            self.homeViewComponents.getGradeBar(),
        ]
        
        return scrollNodeWrapper
    }
}
