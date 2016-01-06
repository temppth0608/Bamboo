//
//  AlertMessageManager.swift
//  Bamboo
//
//  Created by 박태현 on 2016. 1. 5..
//  Copyright © 2016년 ParkTaeHyun. All rights reserved.
//

import Foundation

class AlertMessageManager {
    var title: String = ""
    var message: String = ""
    var acceptMessage: String = ""
    var buttons: [String] = []
    
    func clickNoticeButton(point: String) -> (title: String, message: String, buttons: [String]) {
        return ("포인트 10 감소 합니다.", "잔여포인트 : \(point)", ["취소", "확인"])
    }
    
    func ifLessPointThan10() -> (title: String, message: String) {
        return ("알림", "포인트가 부족합니다! 사람들이 공감할수 있는 댓글을 달아주세요~")
    }
    
    func clickCellFromUnivSearchVC(univ: String) -> (title: String, message: String) {
        return ("알림", "\(univ)로 설정하였습니다~")
    }
    
    func ifNoSelectedPhoto() -> (title: String, message: String) {
        return ("알림", "사진을 선택해주세요 :-)")
    }
    
    init() {
        
    }
    
    init(title: String) {
        self.title = title
    }
    
    init(title: String, message: String) {
        self.title = title
        self.message = message
    }
    
    init(title: String, message: String, acceptMessage: String) {
        self.title = title
        self.message = message
        self.acceptMessage = acceptMessage
    }
    
    init(title: String, message: String, acceptMessage: String, buttons: [String]) {
        self.title = title
        self.message = message
        self.acceptMessage = acceptMessage
        self.buttons = buttons
    }
}