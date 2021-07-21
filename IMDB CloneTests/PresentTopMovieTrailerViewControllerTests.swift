//
//  PresentTopMovieTrailerViewControllerTests.swift
//  IMDB CloneTests
//
//  Created by Konstantin Kostadinov on 21.07.21.
//

import XCTest
@testable import IMDB_Clone

class PresentTopMovieTrailerViewControllerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNameRatingAndDescription() throws {
        guard let viewController = setupVC() else { return }
        let titleText = viewController.titleLabel.text ?? ""
        let yearText = viewController.yearLabel.text ?? ""
        let ratingText = viewController.ratingLabel.text ?? ""
        let descriptionText = viewController.descriptionLabel.text ?? ""
        XCTAssertTrue(titleText.contains("The Shawshank Redemption"), "Title of the movie should be 'The Shawshank Redemption'")
        XCTAssertTrue(yearText.contains( "1994"), "The year should be 1994")
        XCTAssertTrue(ratingText.contains("9.2"), "The rating should be 9.2")
        // swiftlint:disable all
        XCTAssertTrue(descriptionText.contains("Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency."), "the description should contain 'Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.'")
        // swiftlint:enable all
    }

    func testHasCollectionView() {
        guard let viewController = setupVC() else { return }
        XCTAssertNotNil(viewController.collectionView)
    }

    func testCollectionViewDelegate() {
        guard let viewController = setupVC() else { return }
        XCTAssertNotNil(viewController.collectionView.delegate)
    }

    func testCollectionViewHasDataSource() {
        guard let viewController = setupVC() else { return }
        XCTAssertNotNil(viewController.collectionView.dataSource)
    }

    func testTableViewConformsToTableViewDataSourceProtocol() {
        guard let viewController = setupVC() else { return }
        XCTAssertTrue(viewController.conforms(to: UICollectionViewDataSource.self))
        XCTAssertTrue(viewController.responds(to: #selector(viewController.collectionView(_:numberOfItemsInSection:))))
        XCTAssertTrue(viewController.responds(to: #selector(viewController.collectionView(_:cellForItemAt:))))
    }

    func testCollectionViewCellForItem() {
        guard let viewController = setupVC() else { return }
        let cell = viewController.collectionView(viewController.collectionView, cellForItemAt: IndexPath(item: 0, section: 0)) as? UICollectionViewCell
        let actualReuseIdentifer = cell?.reuseIdentifier ?? ""
        let expectedReuseIdentifier = "normalCollectionCellIdentifier"
        XCTAssertEqual(actualReuseIdentifer, expectedReuseIdentifier)
    }

    func testTrailerAction() {
        guard let viewController = setupVC() else { return }
        viewController.didTapThumbnailImage(viewController.thumbmnailImageView)
    }

//    func testDidSelectCellTopMovies() {
//        guard let viewController = setupVC() else { return }
//        viewController.collectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .none)
//        XCTAssertTrue(viewController.responds(to: #selector(viewController.collectionView(_:didSelectItemAt:))))
//        viewController.collectionView.delegate.collectionView!(viewController.collectionView, didselectItemAt: IndexPath(item: 0, section: 0))
//    }


    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func setupVC() -> PresentTopMovieTrailerViewController? {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyBoard.instantiateViewController(withIdentifier: "PresentTopMovieTrailerViewController") as? PresentTopMovieTrailerViewController else { return nil
        }
        viewController.movieId = "tt0111161"
        viewController.rating = "9.2"
        _ = viewController.view
        return viewController
    }
}
