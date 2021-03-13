import XCTest
@testable import Naumen

class NaumenTests: XCTestCase {
    
    private var vc: ViewController!
    
    override func setUp() {
        vc = ViewController()
    }
    
    override func setUpWithError() throws {
    }
    
    override func tearDownWithError() throws {
    }
    
    func testExample() throws {
        vc.viewDidLoad()
        
        let delay = XCTestExpectation()
        delay.isInverted = true
        
        let result = XCTWaiter.wait(for: [delay], timeout: 1)
        switch(result) {
        case .completed:
            XCTAssertNotNil(vc.tableView.storage.list?.items)
        default:
            XCTFail("Too long loading!")
        }
    }
    
    func testPerformanceExample() throws {
        self.measure {
        }
    }
}
