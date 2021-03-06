//
//  UnivBoard.swift
//  Bamboo
//
//  Created by 박태현 on 2015. 12. 16..
//  Copyright © 2015년 ParkTaeHyun. All rights reserved.
//

import Foundation

final class UnivBoard : ResponseObjectSerializable,  ResponseCollectionSerializable {
    
    let code: String
    let contents: String
    let regdt: String
    let imgURL: String
    let movURL: String
    let numberOfComment: Int
    let numberOfLike: Int
    var keywords: String
    var keywordArray: [String] = []
    var notice_yn : String
    var islike: String

    init?(response: NSHTTPURLResponse, representation: AnyObject) {
        self.code = representation.valueForKeyPath("b_code") as! String
        self.contents = representation.valueForKeyPath("b_contents") as! String
        self.regdt = representation.valueForKeyPath("regdt") as! String
        self.imgURL = representation.valueForKeyPath("img_url") as! String
        self.movURL = representation.valueForKeyPath("mov_url") as! String
        self.numberOfComment = Int(representation.valueForKeyPath("comment_cnt") as! String)!
        self.numberOfLike = Int(representation.valueForKeyPath("like_cnt") as! String)!
        self.keywords = representation.valueForKeyPath("keyword") as! String

        if self.keywords != "" {
            let tmpKeywordArray = keywords.characters.split{$0 == ","}.map(String.init)
            keywordArray = tmpKeywordArray
        }
        self.notice_yn = representation.valueForKeyPath("b_notice_yn") as! String
        self.islike = representation.valueForKeyPath("is_like") as! String
    }
    
    static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [UnivBoard]{
        var univBoards : [UnivBoard] = []
        
        if let univBoardArray = representation as? [[String: AnyObject]] {
            for userRepresentation in univBoardArray {
                if let univboard = UnivBoard(response: response, representation: userRepresentation) {
                    univBoards.append(univboard)
                }
            }
        }

        return univBoards
    }
    
}