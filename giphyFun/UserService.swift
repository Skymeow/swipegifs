
import Foundation
import FirebaseAuth.FIRUser
import FirebaseDatabase

struct UserService {
    static func create(_ firUser: FIRUser, username: String, completion: @escaping (User?) -> Void) {
        let userAttrs = ["username": username]
//        let ref = Database.database().reference().child("users").child(firUser.uid)
        let ref = DatabaseReference.toLocation(.showUser(uid: firUser.uid))
   
        ref.setValue(userAttrs) { (error, ref) in
        if let error = error {
            assertionFailure(error.localizedDescription)
            return completion(nil)
        }
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let user = User(snapshot: snapshot)
            completion(user)
       
        })
      }
   }
    
    static func show(forUID uid: String, completion: @escaping (User?) -> Void) {
//        let ref = Database.database().reference().child("users").child(uid)
        let ref = DatabaseReference.toLocation(.showUser(uid: uid))
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let user = User(snapshot: snapshot) else {
                return completion(nil)
            }
            completion(user)
        })
    }
    
    // to fetch all thee posts belongs to a user
    static func getGifs(for user: User, completion: @escaping ([Gif]) -> Void) {
        let ref = Database.database().reference().child("gifs").child(user.uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion([])
            }
            
            let gifs = snapshot.reversed().flatMap(Gif.init)
            completion(gifs)
            print(gifs)
        })
    }
    
    static func usersExcludingCurrentUser(completion: @escaping ([User]) -> Void) {
        let currentUser = User.current
        let ref = Database.database().reference().child("users")
        
        // convert all children snapshot into user using failable initializer
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                else { return completion([]) }
            
            let users =
                snapshot
                    .flatMap(User.init)
                    .filter { $0.uid != currentUser.uid }
            
            // the dispatchGroup will notify us when all aysnc tasks are finished
            let dispatchGroup = DispatchGroup()
            users.forEach { (user) in
                dispatchGroup.enter()
                
                FollowService.isUserFollowed(user) { (isFollowed) in
                    user.isFollowed = isFollowed
                    dispatchGroup.leave()
                }
            }
            dispatchGroup.notify(queue: .main, execute: {
                completion(users)
            })
        })
    }
    
}
