
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
     //let ref = Database.database().reference().child("users").child(uid)
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
                    //isFollowed is false here? 
                    //make a request for each user to determine whether user is being followed by the currentuser
                    user.isFollowed = isFollowed
                    dispatchGroup.leave()
                }
            }
            dispatchGroup.notify(queue: .main, execute: {
                completion(users)
            })
        })
    }
    
    // add the following method for the livechat
    static func following(for user: User = User.current, completion: @escaping ([User]) -> Void) {
        let followingRef = Database.database().reference().child("following").child(user.uid)
        followingRef.observeSingleEvent(of: .value, with: { (snapshot) in
            //check data type
            guard let followingDict = snapshot.value as? [String : Bool] else {
                return completion([])
            }
            var following = [User]()
            let dispatchGroup = DispatchGroup()
            for uid in followingDict.keys {
                //use dispatchGroup to retrieve each user from uid and build the following array
                dispatchGroup.enter()
    
                show(forUID: uid) { user in
                    if let user = user {
                        following.append(user)
                    }
                    dispatchGroup.leave()
                }
            }
            //return the array of following after all task of dispatch group complete
            dispatchGroup.notify(queue: .main) {
                completion(following)
            }
        })
    }
    
    static func observeChats(for user: User = User.current, withCompletion completion: @escaping (DatabaseReference, [Chat]) -> Void) -> DatabaseHandle {
        let ref = Database.database().reference().child("chats").child(user.uid)
        //if DataeventType is triggered, the completion handler is executed
        //if a new message is sent and lastmes is modified, the completion handler will be executed again
        return ref.observe(.value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion(ref, [])
            }
            
            let chats = snapshot.flatMap(Chat.init)
            completion(ref, chats)
        })
    }
    
}
