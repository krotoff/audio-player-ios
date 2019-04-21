//
//  TrackListView.swift
//  Test Enaza
//
//  Created by Andrew Krotov on 17/04/2019.
//  Copyright © 2019 Andrew Krotov. All rights reserved.
//

import UIKit

public class TrackListView: UIView {
    public lazy var tableView = UITableView()
    public lazy var refreshControl = UIRefreshControl()
    public lazy var errorLabel = UILabel()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    
        tableView.refreshControl = refreshControl
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        backgroundColor = .white
        
        errorLabel.alpha = 0
        
        layout()
    }
    
    private func layout() {
        addSubview(tableView)
        addSubview(errorLabel)
        
        tableView.fillInContainer()
        errorLabel.centerInContainer()
    }
    
    public func startRefresh() {
        if !refreshControl.isRefreshing {
            refreshControl.beginRefreshing()
        }
    }
    
    public func endRefresh() {
        refreshControl.endRefreshing()
    }
    
    public func showError(_ message: String?) {
        errorLabel.text = message
        errorLabel.alpha = message != nil ? 1 : 0
    }
}
