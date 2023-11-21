//
//  Enumerations.swift
//  DemoMovies
//
//  Created by Kenneth Cluff on 11/21/23.
//

import Foundation



enum MovieError: Error, LocalizedError, CustomStringConvertible {
    case badURL(description: String)
    case networkError(description: String)
    case parsingError(description: String)
    case noError
    
    public var errorDescription: String? {
        let retValue: String
        switch self {
        case .badURL(description: let errorString):
            retValue = NSLocalizedString("Bad URL - \(errorString)", comment: "")
            
        case .networkError(description: let errorString):
            retValue = NSLocalizedString("Network - \(errorString)", comment: "")
            
        case .parsingError(description: let errorString):
            retValue = NSLocalizedString("Parsing - \(errorString)", comment: "")
            
        case .noError:
            retValue = "No error"
        }
        return retValue
    }

    public var description: String {
        let retValue: String
        switch self {
        case .badURL(description: let error):
            retValue = "Bad URL - \(error)"
            
        case .networkError(description: let error):
            retValue = "Network - \(error)"
            
        case .parsingError(description: let error):
            retValue = "Parsing - \(error)"
        
        case .noError:
            retValue = "No error"
        }
        return retValue
    }
}


enum MovieSort: CaseIterable {
    case titleAlpha
    case rating
    case releaseDate
    
    var text: String {
        let retValue: String
        switch self {
        case .rating:
            retValue = "Rating"
        case .titleAlpha:
            retValue = "Alphabetic"
        case .releaseDate:
            retValue = "Release Date"
        }
        
        return retValue
    }
}
