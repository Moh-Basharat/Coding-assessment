//
//  AcronymsViewModelTests.swift
//  AcronymsTests
//
//  Created by Mohammad on 22/03/22.
//

import XCTest
@testable import Acronyms

private class AcronymDataProviderMock: AcronymDataProvider {
    var error: Error?
    var response: AcronymServiceResponse?
    var queryString: String?
    func fetchData(query: String) async {
        queryString = query
        self.response = AcronymServiceResponse(results: [AcronymServiceResponse.Result(longForm: "Fake Acronym1"),
                                                         AcronymServiceResponse.Result(longForm: "Fake Acronym1")],
                                               acronym: "fa")
    }
}

private class BindableObjectMock: BindableObject {
    var isReloadDataCalled = false
    func reloadData() {
        isReloadDataCalled = false
    }
    func showDisplayError(message: String) {
    }
}

class AcronymsViewModelTests: XCTestCase {

    private var subject: AcronymsViewModel!
    private var dataProviderMock: AcronymDataProviderMock!
    private var bindableObject: BindableObjectMock!
    
    override func setUp() {
        super.setUp()
        dataProviderMock = AcronymDataProviderMock()
        subject = AcronymsViewModel(service: AcronymDataProviderMock())
        bindableObject = BindableObjectMock()
        subject.bind(withObject: bindableObject)
    }
    
    func test_fetchData_ifSearchQueryNil_returnNoReloadData() {
        subject.searchText = nil
        XCTAssertFalse(bindableObject.isReloadDataCalled)
        XCTAssertNil(dataProviderMock.queryString)
        XCTAssertNil(dataProviderMock.response)
    }
    
    func test_fetchData_ifSearchQuerySingleChar_returnNoReloadData() {
        subject.searchText = "H"
        XCTAssertFalse(bindableObject.isReloadDataCalled)
        XCTAssertNil(dataProviderMock.queryString)
        XCTAssertNil(dataProviderMock.response)
    }
    
    func test_fetchData_ifValidSearchQueryAvailable_return_ReloadDataCalled() {
        subject.searchText = "Hm"
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            XCTAssertTrue(self.bindableObject.isReloadDataCalled)
            XCTAssertEqual(self.dataProviderMock.queryString, "sf=Hm")
            XCTAssertTrue(self.dataProviderMock.response?.results.isEmpty == false)
        }
    }
    
    override func tearDown() {
        dataProviderMock = nil
        subject = nil
        bindableObject = nil
        super.tearDown()
    }

}
