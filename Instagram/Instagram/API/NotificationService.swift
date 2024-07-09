//
//  NotificationService.swift
//  Instagram
//
//  Created by mangdi on 6/24/24.
//

import Firebase
import FirebaseFirestoreInternal

struct NotificationService {
    static func uploadNotification(toUid uid: String, fromUid: String,
                                   type: NotificationType, post: Post? = nil) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        // 자기 자신에겐 알림 보내지 않기
        guard uid != currentUid else { return }
        
        // document ID 알아내기위해
        let docRef = COLLECTION_NOTIFICATIONS.document(uid).collection("user-notifications").document()
        
        var data: [String: Any] = ["timestamp": Timestamp(date: Date()),
                                   "uid": fromUid,
                                   "type": type.rawValue,
                                   "id": docRef.documentID]
        
        if let post = post {
            data["postId"] = post.postId
        }
        
        docRef.setData(data)
    }
    
    // 모든 알림 가저오기
    static func fetchNotifications(completion: @escaping([Notification]) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_NOTIFICATIONS.document(currentUid).collection("user-notifications").getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            var notifications: [Notification] = []
            
            documents.forEach { document in
                var notification = Notification(dictionary: document.data())
                
                // 모든 알림은 상대방의 유저 정보를 가지고 있음
                UserService.fetchUser(uid: notification.uid) { user in
                    notification.user = user
                    notifications.append(notification)
                    
                    if document == documents.last {
                        
                        // follow을 제외한 like, comment 타입의 알림은 Post를 받아오도록
                        fetchNotificationWithPost(notifications: notifications) { noties in
                            notifications = noties
                            notifications.sort { noti1, noti2 in
                                return noti1.timestamp.seconds < noti2.timestamp.seconds
                            }
                            completion(notifications)
                        }
                    }
                }
            }
        }
    }
    
    static func fetchNotificationWithPost(notifications: [Notification], completion: @escaping([Notification]) -> Void) {
        var notifications: [Notification] = notifications
        var indexes: [Int] = []
        
        for (index, notification) in notifications.enumerated() {
            if notification.type != .follow {
                indexes.append(index)
            }
            
            // 모든 알림의 타입이 follow인경우 completion호출
            if index == notifications.count - 1 && indexes.isEmpty {
                completion(notifications)
            }
        }
        
        for index in indexes {
            guard let postId = notifications[index].postId else { return }
            PostService.fetchPost(id: postId, isNeedPostUser: false) { post in
                notifications[index].post = post
                completion(notifications)
            }
        }
    }
}
