/*
 * Copyright (c) 2020 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import EN
import Foundation
import XCTest

final class MainRouterTests: XCTestCase {
    private let viewController = MainViewControllableMock()
    private let statusBuilder = StatusBuildableMock()
    private let moreInformationBuilder = MoreInformationBuildableMock()

    private var router: MainRouter!
    
    override func setUp() {
        super.setUp()
        
        router = MainRouter(viewController: viewController,
                            statusBuilder: statusBuilder,
                            moreInformationBuilder: moreInformationBuilder)
    }

    func test_init_setsRouterOnViewController() {
        XCTAssertEqual(viewController.routerSetCallCount, 1)
    }

    func test_attachStatus_callsBuildAndEmbed() {
        var receivedListener: StatusListener!
        statusBuilder.buildHandler = { listener in
            receivedListener = listener
            
            return StatusRoutingMock()
        }
        
        XCTAssertEqual(statusBuilder.buildCallCount, 0)
        XCTAssertEqual(viewController.embedCallCount, 0)
        
        router.attachStatus()
        
        XCTAssertEqual(viewController.embedCallCount, 1)
        XCTAssertEqual(statusBuilder.buildCallCount, 1)
        XCTAssertNotNil(receivedListener)
        XCTAssert(receivedListener === viewController)
    }
    
    func test_callAttachStatusTwice_callsBuildAndEmbedOnce() {
        var receivedListener: StatusListener!
        statusBuilder.buildHandler = { listener in
            receivedListener = listener
            
            return StatusRoutingMock()
        }
        
        XCTAssertEqual(statusBuilder.buildCallCount, 0)
        XCTAssertEqual(viewController.embedCallCount, 0)
        
        router.attachStatus()
        router.attachStatus()
        
        XCTAssertEqual(viewController.embedCallCount, 1)
        XCTAssertEqual(statusBuilder.buildCallCount, 1)
        XCTAssertNotNil(receivedListener)
        XCTAssert(receivedListener === viewController)
    }
    
    func test_attachMoreInformation_callsBuildAndEmbed() {
        var receivedListener: MoreInformationListener!
        moreInformationBuilder.buildHandler = { listener in
            receivedListener = listener
            
            return MoreInformationViewControllableMock()
        }
        
        XCTAssertEqual(moreInformationBuilder.buildCallCount, 0)
        XCTAssertEqual(viewController.embedCallCount, 0)
        
        router.attachMoreInformation()
        
        XCTAssertEqual(viewController.embedCallCount, 1)
        XCTAssertEqual(moreInformationBuilder.buildCallCount, 1)
        XCTAssertNotNil(receivedListener)
        XCTAssert(receivedListener === viewController)
    }
    
    func test_callAttachMoreInformationTwice_callsBuildAndEmbedOnce() {
        var receivedListener: MoreInformationListener!
        moreInformationBuilder.buildHandler = { listener in
            receivedListener = listener
            
            return MoreInformationViewControllableMock()
        }
        
        XCTAssertEqual(moreInformationBuilder.buildCallCount, 0)
        XCTAssertEqual(viewController.embedCallCount, 0)
        
        router.attachMoreInformation()
        router.attachMoreInformation()
        
        XCTAssertEqual(viewController.embedCallCount, 1)
        XCTAssertEqual(moreInformationBuilder.buildCallCount, 1)
        XCTAssertNotNil(receivedListener)
        XCTAssert(receivedListener === viewController)
    }
}
