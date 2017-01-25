//
//  MeetupService.swift
//  MeetupAroundYou

//
//  Created by Guang on 11/27/16.
//  Copyright © 2016 Guang. All rights reserved.
//

import Foundation
import UIKit

struct Event{
    let name: String
    let yes_rsvp_count: Int
    let groupName: String
    let time: NSNumber
    let city: String
    let who: String
    var fav = false
}

extension Event {
    init?(dictionary: NSDictionary){
        guard let name = dictionary["name"] as? String,
            yes_rsvp_count = dictionary["yes_rsvp_count"] as? Int,
            groupName = dictionary["group"]!["name"] as? String,
            time = dictionary["time"] as? NSNumber,
            city = dictionary["venue"]!["city"] as? String,
            who = dictionary["group"]!["who"] as? String else { return nil }
        self.name = name
        self.yes_rsvp_count = yes_rsvp_count
        self.groupName = groupName
        self.time = time
        self.city = city
        self.who = who
    }
}

//MARK: referenced from the objc.io talk #Networking.
struct Resource<A> {
    let url: NSURL
    let parse: (NSData) -> A?
}

extension Resource {
    init(url: NSURL, parseJson: AnyObject -> A?) {
        self.url = url
        self.parse = { data in
            let json = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
            return json.flatMap(parseJson)
        }
    }
}
extension Resource {
    var cacheKey: String {
        return "cache" + String(url.hashValue) // TODO use sha1
    }
}

final class MeetupService{
    func load<A>(resource: Resource<A>, completion: (A?) -> ()){
        NSURLSession.sharedSession().dataTaskWithURL(resource.url) { data, _, _ in
            guard let data = data else {
                completion(nil)
                return
            }
            completion(resource.parse(data))
        }.resume()
    }
}
/*
final class CachedWebservice {
    let webserviec: MeetupService
    init(webservice: MeetupService) {
        self.webserviec = webservice
    }
    let cache = Cache()
    func load(_ resource: Resource<NSData>, update: (Result<NSData>) -> ()) {
        if let result = cache.load(resource) {
            print("cache hit")
            update( .success(result))
        }
        let dataResource = Resource<NSData>(url: resource.url, parse: {($0 as! NSData)})
        webserviec.load(dataResource) { result in
            
        }
    }
}

final class Cache {
    let baseURL = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
    func load<A>(resource: Resource<A>) -> A?{
        let url = baseURL.URLByAppendingPathComponent(resource.cacheKey)
        let data = try? NSData(contentsOfURL: url!)
        return data.flatMap(resource.parse)
    }
    
    func save<A>(data: NSData, for resource: Resource<A>) {
        let url = baseURL.URLByAppendingPathComponent(resource.cacheKey)
        _ = try? newValue?.write(to: url)
    }
}

public enum Result<A> {
    case success(A)
    case error(NSError)
}

extension Result {
    public init(_ value: A?, or error: NSError) {
        if let value = value {
            self = .success(value)
        } else {
            self = .error(error)
        }
    }
    
    public var value: A? {
        guard case .success(let v) = self else { return nil }
        return v
    }
}

*/
