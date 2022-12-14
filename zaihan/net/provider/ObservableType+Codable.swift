import Foundation
import RxSwift
import Moya

public extension ObservableType where Element == Response {

    func mapObject<T: Codable>(_ type: T.Type, _ path: String? = nil) -> Observable<T> {
        return flatMap { response -> Observable<T> in
            return Observable.just(try response.mapObject(type, path: path))
        }
    }

    func mapArray<T: Codable>(_ type: T.Type, _ path: String? = nil) -> Observable<[T]> {
        return flatMap { response -> Observable<[T]> in
            return Observable.just(try response.mapArray(type, path: path))
        }
    }
}
