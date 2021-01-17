//
//  ViewController.swift
//  CryptoRatesAF
//
//  Created by Владимир Беляев on 17.01.2021.
//

import UIKit
import Alamofire

final class RatesViewController: UIViewController {

    // MARK: - Properties
    var rates: [Rate] = []
    var connectionObservation: NSKeyValueObservation!
    @objc let connectionService = ConnectionCheck.shared
    private let url: URL = Endpoint.rates(currency: "usd", itemAmount: 100).url
    
    // MARK: - Subviews
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.refreshControl = UIRefreshControl()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.textColor = .label
        label.text = "Please, check your internet connection!"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        onViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadRates()
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension RatesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: RateTableViewCell.identifier,
                for: indexPath) as? RateTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: rates[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Private methods
extension RatesViewController {
    private func onViewDidLoad() {
        setupSuperView()
        setupNavigationController()
        addSubviews()
        setupConstraints()
        setupTableView()
        setupErrorLabel()
        setupObserve()
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(errorLabel)
    }
    
    private func setupObserve() {
        connectionObservation = observe(\.connectionService.isWorking, options: [.new, .initial]) {[unowned self] (vc, change) in
            guard let isWorking = change.newValue else { return }
            
            DispatchQueue.main.async {
                if isWorking {
                    self.errorLabel.isHidden = true
                    self.tableView.isHidden = false
                    self.loadRates()
                } else {
                    self.errorLabel.isHidden = false
                    self.tableView.isHidden = true
                }
            }
        }
    }
    
    private func setupConstraints() {
        // errorLabel
        NSLayoutConstraint.activate([
            errorLabel.widthAnchor.constraint(equalToConstant: 300),
            errorLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            errorLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
        // tableView
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 76
        tableView.register(UINib(nibName: "RateTableViewCell", bundle: nil), forCellReuseIdentifier: RateTableViewCell.identifier)
        tableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    private func setupSuperView() {
        view.backgroundColor = .white
    }
    
    private func setupErrorLabel() {
        errorLabel.isHidden = true
    }
    
    private func setupNavigationController() {
        navigationController?.navigationBar.topItem?.title = "Rates"
    }
    
    private func loadRates() {
        AF.request(url)
          .validate()
          .responseDecodable(of: [Rate].self) { (response) in
            guard let rates = response.value else { return }
            self.rates = rates
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @objc private func refresh() {
        loadRates()
        tableView.refreshControl?.endRefreshing()
    }
}
