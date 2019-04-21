//
//  TrackListController.swift
//  Test Enaza
//
//  Created by Andrew Krotov on 16/04/2019.
//  Copyright © 2019 Andrew Krotov. All rights reserved.
//

import UIKit

class TrackListController: UIViewController {
    private let trackService: TrackService = .sharedInstance
    
    private lazy var rootView = TrackListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trackService.setDelegate(self)
        
        setupTable()
        
        refreshList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view = rootView
    }
    
    @objc func refreshList() {
        trackService.requestAlbum()
        rootView.startRefresh()
    }
}

extension TrackListController: UITableViewDataSource, UITableViewDelegate {
    private func setupTable() {
        rootView.tableView.dataSource = self
        rootView.tableView.delegate = self
        
        rootView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        rootView.tableView.tableFooterView = UIView()
        
        rootView.refreshControl.addTarget(self, action: #selector(refreshList), for: .valueChanged)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackService.getTracks().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let track = trackService.getTracks()[indexPath.row]
        
        cell.textLabel?.text = track.name
        cell.imageView?.image = trackService.getThumbnail() ?? UIImage(named: "cdIcon")?.scaled(fit: CGSize(width: 42, height: 42))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        trackService.selectTrack(indexPath.row)
        navigationController?.show(PlayerController(), sender: nil)
    }
}

extension TrackListController: TrackServiceDelegate {
    func gotAlbum(_ result: Result<Bool, NetworkingError<ResponseError>>) {
        rootView.endRefresh()
        
        switch result {
        case let .success(isNotEmpty):
            rootView.showError(isNotEmpty ? nil : "Empty List")
        case let .failure(error):
            rootView.showError(error.errorDescription)
        }

        rootView.tableView.reloadData()
    }
}
