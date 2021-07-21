//
//  TopMoviesControllerTests.swift
//  IMDB CloneTests
//
//  Created by Konstantin Kostadinov on 21.07.21.
//

import XCTest
@testable import IMDB_Clone

class TopMoviesControllerTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTopTableViewCell() throws {
        guard let viewController = setupVC() else { return }
        XCTAssertFalse(viewController.tableView.isHidden, "Table view should be visible")
        XCTAssertFalse(viewController.segmentedControl.isHidden, "Segmented control should be visible")
        XCTAssertTrue(viewController.segmentedControl.selectedSegmentIndex == 0, "Segmented index should be 0")
        viewController.segmentedControl.selectedSegmentIndex = 1
        XCTAssertTrue(viewController.segmentedControl?.selectedSegmentIndex == 1, "Segmented index should be 1")
    }

    func testHasATableView() {
        guard let viewController = setupVC() else { return }
        XCTAssertNotNil(viewController.tableView)
    }

    func testTableViewHasDelegate() {
        guard let viewController = setupVC() else { return }
        XCTAssertNotNil(viewController.tableView.delegate)
    }

    func testTableViewConfromsToTableViewDelegateProtocol() {
        guard let viewController = setupVC() else { return }
        XCTAssertTrue(viewController.conforms(to: UITableViewDelegate.self))
        XCTAssertTrue(viewController.responds(to: #selector(viewController.tableView(_:didSelectRowAt:))))
    }

    func testTableViewHasDataSource() {
        guard let viewController = setupVC() else { return }
        XCTAssertNotNil(viewController.tableView.dataSource)
    }

    func testTableViewConformsToTableViewDataSourceProtocol() {
        guard let viewController = setupVC() else { return }
        XCTAssertTrue(viewController.conforms(to: UITableViewDataSource.self))
        XCTAssertTrue(viewController.responds(to: #selector(viewController.tableView(_:numberOfRowsInSection:))))
        XCTAssertTrue(viewController.responds(to: #selector(viewController.tableView(_:cellForRowAt:))))
        XCTAssertTrue(viewController.responds(to: #selector(viewController.tableView(_:heightForRowAt:))))
        viewController.segmentedControl.selectedSegmentIndex = 1
        XCTAssertTrue(viewController.responds(to: #selector(viewController.tableView(_:numberOfRowsInSection:))))
        XCTAssertTrue(viewController.responds(to: #selector(viewController.tableView(_:cellForRowAt:))))
    }
//
    func testTableViewCellTopMovies() {
        guard let viewController = setupVC() else { return }
        let cell = viewController.tableView(viewController.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? TopMovieTableViewCell
        let actualReuseIdentifer = cell?.reuseIdentifier
        let expectedReuseIdentifier = "topMovieCellIdentifier"
        XCTAssertEqual(actualReuseIdentifer, expectedReuseIdentifier)
    }

    func testTableViewCellTopTVs() {
        guard let viewController = setupVC() else { return }
        viewController.segmentedControl.selectedSegmentIndex = 1
        let cell = viewController.tableView(viewController.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? TopMovieTableViewCell
        let actualReuseIdentifer = cell?.reuseIdentifier
        let expectedReuseIdentifier = "topMovieCellIdentifier"
        XCTAssertEqual(actualReuseIdentifer, expectedReuseIdentifier)
    }

    func testDidSelectCellTopMovies() {
        guard let viewController = setupVC() else { return }
        viewController.tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .none)
        XCTAssertTrue(viewController.responds(to: #selector(viewController.tableView(_:didSelectRowAt:))))
        viewController.tableView.delegate?.tableView!(viewController.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
    }

    func testDidSelectCellTopTVs() {
        guard let viewController = setupVC() else { return }
        viewController.segmentedControl.selectedSegmentIndex = 1
        viewController.tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .none)
        XCTAssertTrue(viewController.responds(to: #selector(viewController.tableView(_:didSelectRowAt:))))
        viewController.tableView.delegate?.tableView!(viewController.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func setupVC() -> ViewController? {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as? ViewController else { return nil
        }
        _ = viewController.view
        return viewController
    }
}
