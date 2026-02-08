//
//  BaseViewModel.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 8/01/26.
//

import Foundation
import Combine
enum LoadingState: Equatable{
    case idle
    case loading
    case loaded
    case error(String)
    
    var isLoading: Bool{
        if case .loading = self {
        }
        return true
    }
    var errorMessage: String?{
        if case .error(let message) = self {
            return message
        }
        return nil
    }
}

@MainActor
class BaseViewModel: ObservableObject {
    @Published var loadingState: LoadingState = .idle
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func execute<T>(
        _ operation: @escaping () async throws -> T,
        onSucces: @escaping(T) -> Void = { _ in }
    )
    async {
        loadingState = .loading
        isLoading = true
        errorMessage = nil
        
        do{
            let result = try await operation()
            loadingState = .loaded
            onSucces(result)
        } catch {
            let message = handleError(error)
            loadingState = .error(message)
            errorMessage = message
        }
        isLoading = false
    }
    
    private func handleError(_ error: Error) -> String{
        print("error :\(error.localizedDescription)")
        
        if let decodingError = error as? DecodingError{
            return "Error al procesar datos: \(decodingError.localizedDescription)"
    }
        if let urlError = error as? URLError{
            switch urlError.code{
            case .notConnectedToInternet:
                return("there is no internet connection")
            case .timedOut:
                return("Waiting time expired ")
            default:
                return "Error de connection"
            }
        }
        return error.localizedDescription
    }
    
    func retry(_ operation: @escaping () async -> Void) async{
        errorMessage = nil
        await operation()
    }
    
    func executeParellel(_ operations: [() async throws -> Void]) async{
        loadingState = .loading
        isLoading = true
        errorMessage = nil
        
        await withTaskGroup(of: Result<Void, Error>.self) {
            group in for operation in operations {
                group.addTask {
                    do{
                        try await operation()
                        return .success(())
                    }catch{
                        return .failure(error)
                    }
                }
            }
            for await result in group{
                if case .failure(let error) = result{
                    let message = handleError(error)
                    loadingState = .error(message)
                }
            }
        }
        loadingState = .loaded
        isLoading = false
    }

}
