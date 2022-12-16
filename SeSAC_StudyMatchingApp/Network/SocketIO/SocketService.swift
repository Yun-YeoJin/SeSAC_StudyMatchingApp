//
//  SocketService.swift
//  SeSAC_StudyMatchingApp
//
//  Created by 윤여진 on 2022/12/07.
//

import Foundation

import SocketIO

class SocketService {
    static let shared = SocketService()
    
    var manager: SocketManager!
    
    var socket: SocketIOClient!
    
    private init() {
        
        manager = SocketManager(socketURL: URL(string: "http://api.sesac.co.kr:1210")!, config: [
            .log(true), // debug 가능하도록함
            .forceWebsockets(true) // websocket 전송에서 compression을 가능하게함
        ])
        
        socket = manager.defaultSocket // 디폴트로 "/" 로 된 룸
        
        // 소켓 연결 메서드(귀를 열기 전에 연결 먼저하기!)
        socket.on(clientEvent: .connect) { [weak self] data, ack in
            guard let self = self else {return}
            print("SOCKET IS CONNECTED", data, ack)
            self.socket.emit("changesocketid", UserDefaultKey.myUID)
        }
        
        // 소켓 연결 해제 메서드
        socket.on(clientEvent: .disconnect) { data, ack in
            print("SOCKET IS DISCONNECTED", data, ack)
        }

        // 소켓 채팅 듣는 메서드, sesac 이벤트로 날아온 데이터를 수신
        // 데이터 수신 -> 디코딩 -> 모델에 추가 -> 갱신
        // event의 String (서버에서 미리 약속한거)
        socket.on("chat") { dataArray, ack in
            let data = dataArray[0] as! NSDictionary
            let id = data["_id"] as! String
            let chat = data["chat"] as! String
            let otherId = data["to"] as! String
            let userId = data["from"] as! String
            let createdAt = data["createdAt"] as! String

            NotificationCenter.default.post(
                name: Notification.Name("getMessage"),
                object: self,
                userInfo: ["id": id, "chat": chat, "otherId": otherId, "createdAt": createdAt, "userId": userId]
            )
        }
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
}

enum SocketNotificationName {
    static let id = "id"
    static let chat = "chat"
    static let otherId = "otherId"
    static let userId = "userId"
    static let createdAt = "createdAt"
    static let getMessage = "getMessage"
}
