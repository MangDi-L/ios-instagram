# 📷 인스타그램

## 📖 목차
1. [소개](#-소개)
2. [파일 tree](#-파일-tree)
3. [타임라인](#-타임라인)
4. [실행 화면](#-실행-화면)
5. [고민한 점](#-고민한-점)
6. [트러블 슈팅](#-트러블-슈팅)
7. [참고 링크](#-참고-링크)

## 🌱 소개 
`Mangdi`가 만든 `인스타그램 클론 앱` 입니다.  
클론 앱을 그저 똑같이 만들지말고 알고있던 지식을 동원해서 더 진화된 앱을 만들자는 생각으로  
구조변경 및 추가기능을 넣었습니다.  
(FireStore Rule로 username유일성보장, 프로필편집기능, 게시물수정 및 삭제, like게시글모아보기, 등등...)  
(자세한 내용은 아래 고민한점, 트러블슈팅에서)  

이번 클론앱 프로젝트를 통해 실제로 서비스하는앱을 따라만들면서 갖가지 정보들을 습득하는 좋은 계기가 되었습니다.  
[Udemy 인스타그램클론 링크](https://www.udemy.com/course/instagram-firestore-app-clone-swift-5-ios-14-mvvm/?couponCode=24T7MT72224)
  
  
- **KeyWords**
  - `UITabBarController`, `UICollectionViewController`, `NotificationCenter`
  - `UISearchController`, `UISearchBarDelegate`, `UISearchResultsUpdating`
  - `Firebase`, `SDWebImage`, `JGProgressHUD`, `PHPickerViewControllerDelegate`


## 💻 개발환경 및 라이브러리
[![swift](https://img.shields.io/badge/swift-5.10-orange)]()
[![xcode](https://img.shields.io/badge/Xcode-15.4-blue)]()

## 🛒 사용 기술 스택
|UI구현|아키텍처|의존성관리도구|라이브러리
|:--:|:--:|:--:|:--:|
|UIKit|MVVM|CocoaPods|SwiftLint|

## 🧑🏻‍💻 팀원
|<img src="https://avatars.githubusercontent.com/u/49121469" width=160>|
|:--:|
|[Mangdi](https://github.com/MangDi-L)|

## 🌲 파일 tree

```
.
├── Instagram
│   ├── GoogleService-Info.plist
│   ├── Instagram
│   │   ├── API
│   │   │   ├── AuthService.swift
│   │   │   ├── CommentService.swift
│   │   │   ├── ImageUploader.swift
│   │   │   ├── NotificationService.swift
│   │   │   ├── PostService.swift
│   │   │   └── UserService.swift
│   │   ├── AppDelegate.swift
│   │   ├── Controller
│   │   │   ├── Authentication
│   │   │   │   ├── LoginController.swift
│   │   │   │   ├── RegistrationController.swift
│   │   │   │   └── ResetPasswordController.swift
│   │   │   ├── CommentController.swift
│   │   │   ├── FeedController.swift
│   │   │   ├── ImageSelectorController.swift
│   │   │   ├── MainTabController.swift
│   │   │   ├── NotificationController.swift
│   │   │   ├── ProfileController.swift
│   │   │   ├── ProfileEditController.swift
│   │   │   ├── ProfileNameEditController.swift
│   │   │   ├── SearchController.swift
│   │   │   └── UploadPostController.swift
│   │   ├── Info.plist
│   │   ├── Model
│   │   │   ├── Comment.swift
│   │   │   ├── Notification.swift
│   │   │   ├── Post.swift
│   │   │   └── User.swift
│   │   ├── SceneDelegate.swift
│   │   ├── Utils
│   │   │   ├── Constants.swift
│   │   │   └── Extentions.swift
│   │   ├── View
│   │   │   ├── CommentCell.swift
│   │   │   ├── CommentInputAccessoryView.swift
│   │   │   ├── CustomTextField.swift
│   │   │   ├── FeedCell.swift
│   │   │   ├── InputTextView.swift
│   │   │   ├── NotificationCell.swift
│   │   │   ├── Profile
│   │   │   │   ├── ProfileCell.swift
│   │   │   │   └── ProfileHeader.swift
│   │   │   ├── ProfileEditCell.swift
│   │   │   └── UserCell.swift
│   │   ├── ViewController.swift
│   │   └── ViewModel
│   │       ├── AuthenticationViewModel.swift
│   │       ├── CommentViewModel.swift
│   │       ├── NotificationViewModel.swift
│   │       ├── PostViewModel.swift
│   │       ├── ProfileHeaderViewModel.swift
│   │       └── UserCellViewModel.swift
```
 
## ⏰ 타임라인

<details>
<summary>2024년 05월 25일 ~ 7월 10일</summary>

- 약 1.5개월 기간동안 프로젝트 진행
- 자세한 내용은 Commit내역에 있습니다.
</details>

    
## 📱 실행 화면

|가입시 중복이메일 및 중복username확인(batman@gmail, batman유저네임은 이미 있음)|로그인|피드탭,검색탭,팔로잉(피드탭엔 자신 및 팔로우한사람의 포스트만 보여짐)|
|:--:|:--:|:--:|
|<img width="50%" src="https://github.com/user-attachments/assets/c7964e01-b906-4556-9c7c-12cf9a776aeb">|<img width="100%" src="https://github.com/user-attachments/assets/ee8ba1f5-9ca1-447b-b97a-6d4676164e10">|<img width="80%" src="https://github.com/user-attachments/assets/047fee55-f241-4df7-883b-62004994cf6f">|

|Post생성,like,comment,프로필이미지변경|username변경(유일성보장)|Post수정|
|:--:|:--:|:--:|
|<img width="100%" src="https://github.com/user-attachments/assets/25a597a9-619c-4d77-ab6a-7320ccd50dce">|<img width="100%" src="https://github.com/user-attachments/assets/4b19a063-0c39-4b49-a52a-45ea810f328b">|<img width="100%" src="https://github.com/user-attachments/assets/c4237fa2-f05e-4c5c-9bf8-ecd405d0e07e">|

|다른계정으로로그인,Notification맞팔로우,Post삭제|
|:--:|
|<img width="80%" src="https://github.com/user-attachments/assets/79cd9e3a-eeaf-4612-b61b-79e348c54f63">|


동영상버전입니다.  
[가입시 중복이메일 및 중복username확인(batman@gmail, batman유저네임은 이미 있음)](https://github.com/user-attachments/assets/e8db364e-16e8-41f5-b145-b2d2b523e90f)  
[로그인](https://github.com/user-attachments/assets/ccbd21ca-5636-4b47-acb5-ec43357b3e26)  
[피드탭,검색탭,팔로잉(피드탭엔 자신 및 팔로우한사람의 포스트만 보여짐)](https://github.com/user-attachments/assets/c625f20c-f80f-48f3-9c45-1702e415dad3)  
[Post생성,like,comment,프로필이미지변경](https://github.com/user-attachments/assets/db780caa-dda5-4bbb-ab5e-d29cc543692a)  
[username변경(유일성보장)](https://github.com/user-attachments/assets/90a8a6e2-e512-4360-a825-7790052ede7b)  
[Post수정](https://github.com/user-attachments/assets/3daed181-e57f-41a7-91b0-fbd1e5ed4761)  
[다른계정으로로그인,Notification맞팔로우,Post삭제](https://github.com/user-attachments/assets/d06c965a-ec7d-4e0c-8546-6cf285ab7452)  








## 👀 고민한 점


- **포스팅 및 갖가지 일을 행할때마다 프로필이 갱신되도록 구현하는것과 FireStore Database요청 횟수에 따른 비용청구에 대한 고민**  

  - 강의에서는 포스팅할때 FireStore에 입력되는 정보를 생으로 입력하게했.
  - 이렇게하면 문제점이 나중에 포스팅의 주인이 프로필 이미지를 바꾼다던가, 이름을 바꿧을때 바뀐 내용이 표시되지않고 생으로 입렵된정보가 여전히 표시된다는 문제가 있다.
  - 이 점을 해결하기위해 유저정보가 담긴 UID를 가지고있도록 해서 Post에 대한 정보 요청마다 해당 UID정보를가진 유저정보를 받도록 구현했다.
  - 그런데 강사가 생으로 입력하던 방법을 택했던 이유가 FireStore Database에서 데이터 요청횟수에 따라서 비용이 청구되기때문에 Post횟수가 많으면 많아질수록 User정보 여러개도 같이 요청되어 이 부분이 염려되어서 생으로 정보를 입력했다고 한다.
  - 결국 비용을 신경쓸것인지 아니면 코드의 효율을 더 좋게할것인지 선택이었다.
  - FireStore데이터비용 기준에 대해 찾아보다가 데이터비용을 지불할만큼 요청횟수가 그리많지않을것임을 확신했고 앱을 실제로 상용화했을때에도 후자의 방식으로 했을것이 분명하기때문에 미리 실전연습을 한다 쳐서 결국 후자의 방식을 택했다.
  - <img width="100%" src="https://github.com/user-attachments/assets/dab79a86-9206-41c6-b7c9-cb4517be0a94">
  - 위 사진으로 post가 생으로 username 및 프로필이미지정보를 가지고있지않고 ownerUid를 가지고있어 호출시 그때마다 ownerUid의 유저정보를 토대로 username 및 프로필이미지정보를 가져온다.



    
## ❓ 트러블 슈팅

- **API호출로 받아온 포스트가 누락되는 이슈**
  
  ```swift
  static func fetchPosts(completion: @escaping([Post]) -> Void) {
        COLLECTION_POSTS.getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            var posts: [Post] = []
            
            documents.forEach { document in
                var post = Post(postId: document.documentID, dictionary: document.data())
                
                UserService.fetchUser(uid: post.ownerUid) { user in
                    post.postUser = user
                    posts.append(post)
                    
                    if document == documents.last {
                        posts.sort { post1, post2 in
                            return post1.timestamp.seconds > post2.timestamp.seconds
                        }
                        
                        completion(posts)
                    }
                }
            }
        }
    }
  ```  

  - 위 코드에서 잘못된점이 completion을 호출할때 if문으로 조건문을 붙이면 안된다는것을 알게되었다.
  - 비동기로 작동하는 코드이기때문에 if 조건문에 부합한 상황이어도 아직 데이터를 다 못불러들이고 completion을 호출하기 때문에 받아온 데이터는 늘 이상할수밖에 없었던것이다.
  - 처음 코드를 작성할때 왜 저렇게 if문으로 completion을 호출하게되었냐면
  - API호출로 Post정보를 다 받아오는 그 타이밍때 시간대별로 정렬하여 completion으로 전달할 생각이엇는데 정보를 다 받아오는 때를 if 조건문으로 재려고 했었다.
  - 결국은 조건문을 붙인것이 이번 오류의 원인이었다.
  - 비동기의 작동방식은 알고있었지만 이번 경험으로 비동기 코드를 작성할때 어떤점을 조심해야하는지 확실하게 알게된것같다.

  ```swift
  static func fetchPosts(completion: @escaping([Post]) -> Void) {
        COLLECTION_POSTS.getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            var posts: [Post] = []
            
            documents.forEach { document in
                var post = Post(postId: document.documentID, dictionary: document.data())
                posts.append(post)
                
                if document == documents.last {
                    posts.sort { post1, post2 in
                        return post1.timestamp.seconds > post2.timestamp.seconds
                    }
                    
                    for (index, post) in posts.enumerated() {
                        UserService.fetchUser(uid: post.ownerUid) { user in
                            posts[index].postUser = user
                            completion(posts)
                        }
                    }
                }
            }
        }
    }
  ```

    

- **가입 및 프로필편집때 username유일성 보장하도록 중복검사기능도입할때 Cloud Firestore Rule이슈**  
  - Firebase에서 기본적으로 이메일의 중복검사기능은 제공되지만 자체적으로 생성한 username같은경우 유일성을 보장하려면 본인이 직접 설정해야한다.
  - 중복검사를하는 코드를 다 짜고 실행해봤더니 `missing or insufficient permissions.` 이 오류가 계속 떴다.
  - 이 오류가 뜬 원인은 Firestore Database에 설정한 규칙 문제였다.
  - 중복검사를 하는 로직이 기존 모든 사용자들의 정보를 받아와서 같은 이름이 있는지 확인하는데 모든 사용자들의 정보를 불러올때 설정한 규칙때문에 오류가 발생했다.
  - `allow read, write: if request.auth != null;` 이게 설정해놓은 규칙인데 사용자가 인증된 상태에서만 읽고쓰기가 가능하다.
  - 가입할때는 당연히 로그인하지않은상황이라 읽을수도, 쓸수도 없다. 이때는 그냥 `allow read, write: if true;` 이렇게 바꿔주면 어디서든지 읽고 쓰기가 가능하지만 보안이 뻥 뚫린 상태라 테스트할때에만 통하는 방법이고 실제 서비스를 할 상황이면 보안을 신경쓰면서 해야하기때문에 이 방법은 좋지못하다. 그래서 어떻게 해야할까 고민하다가
  - 가입할때 데이터를 가져와서 중복검사만 하기때문에 write는 필요없고 read만 필요한상황이라 `allow read: if true;` `allow write: if request.auth != null;` 이렇게 규칙을 바꾸었다. 하지만 이것도 여전히 좋지않은 방법이다.
  - 조금더 찾아보니 아래 링크와 같이 규칙들을 다양한 조건와 함께 제시할수가 있다는 걸 알았다.
  - [Firebase-rules공식문서1](https://firebase.google.com/docs/rules/rules-language?hl=ko#cloud-firestore), [Firebase-rules공식문서2](https://firebase.google.com/docs/firestore/security/rules-conditions?hl=ko), [Custom Usernames in Firebase](https://fireship.io/lessons/custom-usernames-firebase/), [Get to know Colud Firestore](https://www.youtube.com/watch?v=eW5MdE3ZcAw&list=PLl-K7zZEsYLluG5MCVEzXAQ7ACZBCuZgZ&index=6)
  - 개인적으로 링크4번 영상을 통해 배운게 가장 크다. 이것들을 보고 배우고 써먹는데 2~3일은 걸린것같다.
  - 처음 이것들을 봤을때는 뭐가먼지 엄청 헷갈렸고 대충 구현하고 넘어가려했는데 그게 잘 안되어서 처음부터 차근차근 공식문서를 찾아보고 배우고 결국 내것으로 만들게 되어서 성취감을 느꼈다.
  - 삽질의흔적들..![삽질의흔적들..](https://github.com/user-attachments/assets/a28859eb-93db-4a1d-bbb3-25b5c9cacc0b)


## 🔗 참고 링크
[Firebase-rules공식문서1](https://firebase.google.com/docs/rules/rules-language?hl=ko#cloud-firestore)  
[Firebase-rules공식문서2](https://firebase.google.com/docs/firestore/security/rules-conditions?hl=ko)  
[Custom Usernames in Firebase](https://fireship.io/lessons/custom-usernames-firebase/)  
[Get to know Colud Firestore](https://www.youtube.com/watch?v=eW5MdE3ZcAw&list=PLl-K7zZEsYLluG5MCVEzXAQ7ACZBCuZgZ&index=6)

---

[🔝 맨 위로 이동하기](#-인스타그램)


---
