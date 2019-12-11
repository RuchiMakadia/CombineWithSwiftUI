//
//  Model.swift
//  combineSwifUIDemo
//
//  Created by eHeuristic on 10/12/19.
//  Copyright © 2019 eHeuristic. All rights reserved.
//

import Foundation
import Combine

enum enum_error_type: Error {
  case parsing(description: String)
  case network(description: String)
}

class Model: ObservableObject {
    @Published var post_data = [Post]()
    @Published var error_message: String?
    
    private var searchCancellable: Cancellable? {
        didSet { oldValue?.cancel() }
    }
    deinit {
        searchCancellable?.cancel()
    }
    
   func fetch_post_data(forurl url: URL) -> AnyPublisher<[Post], enum_error_type> {
        return web_request(with: url)
    }
    
    func get_post_data(url: URL) {
    searchCancellable = fetch_post_data(forurl: url)
        .receive(on: DispatchQueue.main)
        .sink(
          receiveCompletion: { [weak self] value in
            switch value {
            case .failure(let error):
                self?.error_message = error.localizedDescription
            case .finished:
              break
            }
          },
          receiveValue: { [weak self] forecast in
            self?.post_data = forecast
        })
    }
}

struct Post: Hashable, Identifiable, Decodable {
    let id: Int
    let title: String
    let body: String
    let userId: Int
}

/*class SearchUserViewModel: ObservableObject
{
    @Published var arr_post = [Post]()
    @Published var arr_response : responce_type<Post>?
    
    private var searchCancellable: Cancellable? {
           didSet { oldValue?.cancel() }
       }
       deinit {
           searchCancellable?.cancel()
       }
    
    func call_API(url: URL){
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        //request.httpBody = parameter.stringFromHttpParameters().data(using: String.Encoding.utf8)
        searchCancellable = URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw HTTPError.statusCode
                }
                return output.data
        }
        .decode(type: responce_type<Post>.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
        .receive(on: RunLoop.main)
        .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }, receiveValue: { posts in
            self.arr_response = posts
            print(self.arr_response?.data)
        })
    }
}*/

