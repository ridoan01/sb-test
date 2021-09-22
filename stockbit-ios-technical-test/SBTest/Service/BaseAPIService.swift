
import Foundation

enum ErrorResult: Error, Equatable {
    case generalError(message: String?)
    case noInternet
    case dataNil
    case parsingFailure
}

class BaseAPIService {
    func request<T: Codable>(urlString: String ,completion: ((_ result: Result<T, ErrorResult>) -> Void)? = nil) {
        
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)

		URLSession.shared.dataTask(with: request){ (data, response, error) in
            guard let data = data, error == nil else {
                completion?(.failure(ErrorResult.dataNil))
                return
            }
			
            do {
                let results = try JSONDecoder().decode(T.self, from: data)
                completion?(.success(results))
            } catch let decodingError {
                completion?(.failure(ErrorResult.generalError(message: decodingError.localizedDescription)))
            }
            
        }.resume()
    }
}

