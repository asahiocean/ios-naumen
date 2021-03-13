import XCTest

class NaumenUITests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
    }
    
    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
        app.navigationBars.searchFields.firstMatch.tap()
        app.firstMatch.tap()
        app.cells.firstMatch.tap()
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                // XCUIApplication().launch()
            }
        }
    }
}
