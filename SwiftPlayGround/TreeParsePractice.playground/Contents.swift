//: Playground - noun: a place where people can play

import UIKit

enum TreeNodeError: Error {
    case moreThanTwoChildren
    case duplicateEdge
    case cyclePresent
    case multipleRoot
    case anyOtherError
}

public class TreeNode<T> {
    public var value: T
    
    public var left: TreeNode?
    public var right: TreeNode?
    
    public init(value: T) {
        self.value = value
    }
}

extension TreeNode: CustomStringConvertible {
    public var description: String {
        var text = "(\(value)"
        
        if let leftChild = left{
            text += "\(leftChild)"
        }
        if let rightChild = right{
            text += "\(rightChild)"
        }
        
        text += ")"
        
        return text
    }
}

extension TreeNode where T: Equatable,  T: Comparable{
    func search(_ value: T) -> TreeNode? {
        if value == self.value {
            return self
        }
        
        if let found = left?.search(value) {
            return found
        } else if let found = right?.search(value) {
            return found
        }
        
        return nil
    }
    
    public func addChild(_ node: TreeNode<T>) throws {
        
        if let leftChild = left {
            if right == nil {
                if leftChild.value > node.value {
                    right = left
                    left = node
                } else {
                    right = node
                }
            } else {
                throw TreeNodeError.moreThanTwoChildren
            }
            
        } else {
            left = node
        }
    }
}

protocol equiComparable: Comparable, Equatable{
    
}
func addChildNode(node: String, root:inout TreeNode<String>?) throws ->Bool{
    let words = node.components(separatedBy: ",")
    guard let first =  words.first, first.characters.count == 2,
        let last = words.last, last.characters.count == 2 else {
            
            throw TreeNodeError.anyOtherError
    }
    
    
    let pIndex = first.index(first.startIndex, offsetBy: 1)
    let parent = first.substring(from: pIndex)
    let cIndex = last.index(last.startIndex, offsetBy: 1)
    let child = last.substring(to: cIndex)
    
    if let rootNode = root{
        if let existingParentNode = rootNode.search(parent) {
            
            if (existingParentNode.left?.value ==  child || existingParentNode.right?.value ==  child) {
                throw TreeNodeError.duplicateEdge
            } else if (rootNode.search(child)) != nil {
                throw TreeNodeError.cyclePresent
            } else {
                try existingParentNode.addChild(TreeNode(value: child))
            }
            
        } else if rootNode.value == child { // root node will shift
            let newRootNode = TreeNode(value: parent)
            try newRootNode.addChild(rootNode)
            root = newRootNode
        } else {
            return false
        }
    } else {
        let rootNode = TreeNode(value: parent)
        try rootNode.addChild(TreeNode(value: child))
        root = rootNode
    }
    
    return true
}

func SExpression(nodes: String) -> String {
    var pendingNodes = nodes.components(separatedBy: " ")
    var root:TreeNode<String>?
    
    while pendingNodes.count > 0 {
        var linkNodeFound = false
        
        for node in  pendingNodes{
            
            do {
                let isAdded = try addChildNode(node: node, root: &root)
                if isAdded {
                    if let nodeIndex = pendingNodes.index(of: node){
                        pendingNodes.remove(at: nodeIndex)
                    }
                    
                    linkNodeFound = true
                }
                
            } catch TreeNodeError.moreThanTwoChildren {
                return "E1"
            } catch TreeNodeError.cyclePresent {
                return "E3"
            } catch TreeNodeError.duplicateEdge {
                return "E2"
            } catch _ {
                return "E5"
            }
        }
        
        
        if !linkNodeFound {
            return "E4" // no link found so multiple roots
        }
    }
    
    var output = ""
    if let rootNode = root{
        output = "\(rootNode)"
    }
    
    return output
}
//print(SExpression(nodes: "(B,D) (D,E) (A,B) (C,F) (E,G) (A,C)"))
//print(SExpression(nodes: "(DE) (C,F) (E,G) (A,C) (A,B) (B,D) (F,Z) (F,X)"))
print(SExpression(nodes: "(A,B) (A,C) (B,G) (C,H) (E,F) (B,D) (C,E) (Z,B)"))
//print(SExpression(nodes: "(A,B) (A,C) (A,D) (D,C)"))

