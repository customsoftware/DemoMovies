//
//  DemoMoviesTests.swift
//  DemoMoviesTests
//
//  Created by Kenneth Cluff on 11/21/23.
//

import XCTest
import Combine
@testable import DemoMovies

// I built this unit test to test the operation of the engine prior to building out the rest of the app.
//  This just makes sure the engine works, so I don't have to mess with it once I start on the UI

final class DemoMoviesTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    private let formatter: NumberFormatter = NumberFormatter()
    private let fetchEngine = DataEngine()
    private var returnedMovieList: MovieList?
    private var returnedError: MovieError?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        cancellables = []
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFetchingMovieList() async throws {
        // How we wait for the results
        let expectation = self.expectation(description: "Getting declination")
        let theAnswer = "The Creator"
        
        fetchEngine.fetchMovieList()
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let decError):
                    self?.returnedError = decError
                }
                
                expectation.fulfill()
            } receiveValue: { [weak self] result in
                self?.returnedMovieList = result
            }
            .store(in: &cancellables)

        // Wait for something to happen
        await fulfillment(of: [expectation], timeout: 4)
       
        if let anError = returnedError {
            print(anError.localizedDescription)
        }
        XCTAssertEqual(returnedMovieList?.results.first?.original_title, theAnswer)
    }
    
    func testFetchMovieArt() async throws {
//        let expectation = self.expectation(description: "Getting artwork")
        let aMovieID = 670292
        
//        do {
            try fetchEngine.fetchMoviePoster(movieID: aMovieID)
//            expectation.fulfill()
//        } catch let error {
//            print(error.localizedDescription)
//            expectation.fulfill()
//        }
        // Wait for something to happen
//        await fulfillment(of: [expectation])
      
    }
}
