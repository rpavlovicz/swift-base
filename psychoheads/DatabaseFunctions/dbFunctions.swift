//
//  dbFunctions.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/25/25.
//


//
//  DatabaseFunctions.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 3/12/23.
//

import UIKit
import Combine
import FirebaseFirestore
import FirebaseStorage

struct dbFunctions {
    
    func getThumbnail(imagePath: String) -> AnyPublisher<UIImage, Error> {
            let storageRef = Storage.storage().reference()
            let fileRef = storageRef.child(imagePath)

            return Future { promise in
                fileRef.getData(maxSize: 2 * 1024 * 1024) { data, error in
                    if let error = error {
                        promise(.failure(error))
                    } else if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            promise(.success(image))
                        }
                    } else {
                        promise(.failure(NSError(domain: "ImageDownloadError", code: -1, userInfo: nil)))
                    }
                }
            }
            .eraseToAnyPublisher()
        }
    
    
    
//    func getThumbnail(imagePath: String, completion: @escaping (UIImage?) -> Void) {
//
//        let storageRef = Storage.storage().reference()
//        let fileRef = storageRef.child(imagePath)
//        fileRef.getData(maxSize: 2 * 1024 * 1024) { data, error in
//
//            if error == nil, let data = data, let image = UIImage(data: data) {
//                DispatchQueue.main.async {
//                    completion(image)
//                }
//            } else {
//                completion(nil)
//            }
//
//        }
//
//    }
    
}
