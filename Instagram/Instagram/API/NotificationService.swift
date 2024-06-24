//
//  NotificationService.swift
//  Instagram
//
//  Created by mangdi on 6/24/24.
//

import Firebase

struct NotificationService {
    static func uploadNotification(toUid uid: String, type: NotificationType, post: Post? = nil) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        // 자기 자신에겐 알림 보내지 않기
        guard uid != currentUid else { return }
        
        // document ID 알아내기위해
        let docRef = COLLECTION_NOTIFICATIONS.document(uid).collection("user-notifications").document()
        
        var data: [String: Any] = ["timestamp": Timestamp(date: Date()),
                                   "uid": currentUid,
                                   "type": type.rawValue,
                                   "id": docRef.documentID]
        
        if let post = post {
            data["postId"] = post.postId
            data["postImageUrl"] = post.imageUrl
        }
        
        docRef.setData(data)
    }
    
    static func fetchNotifications(completion: @escaping([Notification]) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_NOTIFICATIONS.document(currentUid).collection("user-notifications").getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            var notifications = documents.map { Notification(dictionary: $0.data()) }
            
            notifications.sort { noti1, noti2 in
                return noti1.timestamp.seconds > noti2.timestamp.seconds
            }
            
            completion(notifications)
        }
    }
}
