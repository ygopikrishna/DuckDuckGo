//
//  ContentViewModel.swift
//  DuckDuckGo
//
//  Created by Gopi Krishna on 11/19/19.
//  Copyright © 2019 iCreditWorks. All rights reserved.
//

import Foundation

class ContentViewModel {
  
  fileprivate var model: ContentData?
  
  func getContent(onSuccess success:@escaping () -> Void, onFailure failure:@escaping () -> Void) {
    let urlString = "http://api.duckduckgo.com/?q=simpsons+characters&format=json"
    if let url = URL(string: urlString) {
      DispatchQueue.global(qos: .background).async {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error == nil, let data = data {
                do {
                  let decoder = JSONDecoder()
                  let responseModel = try decoder.decode(ContentData.self, from: data)
                  self.model = responseModel
                  DispatchQueue.main.async {
                    success()
                  }
                } catch {
                  DispatchQueue.main.async {
                    failure()
                  }
                }
            } else {
              DispatchQueue.main.async {
                failure()
              }
            }
        }.resume()
      }
    }
  }
}

extension ContentViewModel {
    
    var heading: String? {
        return self.model?.Heading
    }
    
    var contentData: [ContentObject] {
        return self.model!.RelatedTopics
    }
    
}
