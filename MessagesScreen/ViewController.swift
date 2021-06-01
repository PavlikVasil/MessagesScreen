//
//  ViewController.swift
//  MessagesScreen
//
//  Created by Павел on 01.06.2021.
//

import UIKit
import Alamofire
import Kingfisher

final class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nothingFoundLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var refreshControl = UIRefreshControl()
    private var messages: [MessageResponse] = []
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        refreshControl.addTarget(self, action: #selector(self.refreshMessages), for: .valueChanged)
        tableView.addSubview(refreshControl)
        setupTableView()
        fetchMessages {
            self.activityIndicator.stopAnimating()
        }
    }


    // MARK: - Private Methods
    
    private func setupTableView() {
      tableView.dataSource = self
      tableView.delegate = self
      tableView.layer.isHidden = true
      nothingFoundLabel.layer.isHidden = true
      registerCells()
    }
    
    private func fetchMessages(completion: @escaping (() -> ())){
        activityIndicator.startAnimating()
        if (NetworkState().isInternetAvailable) {
            let request = AF.request("https://s3-eu-west-1.amazonaws.com/builds.getmobileup.com/storage/MobileUp-Test/api.json")
            request.validate().responseDecodable(of: [MessageResponse].self){response in
                if response.response!.statusCode > 400{
                    self.showNoAnswerAlert()
                } else {
                guard let response = response.value else {return}
                self.messages = response
                self.reloadTableView()
                print(self.messages)
                    }
                }
            } else {
                self.showNoInternetAlert()
            }
            completion()
    }
    
    private func reloadTableView() {
      DispatchQueue.main.async { [weak self] in
        self?.refreshControl.endRefreshing()
        self?.activityIndicator.isHidden = true
        self?.tableView.layer.isHidden = self?.messages.isEmpty ?? true
        self?.nothingFoundLabel.layer.isHidden = !(self?.messages.isEmpty ?? true)
        
        self?.tableView.reloadData()
      }
    }
    
    private func showNoInternetAlert() {
      let alert = UIAlertController(
        title: "No internet connection",
        message: nil,
        preferredStyle: .alert)
      
      alert.addAction(UIAlertAction(
                        title: "Close",
                        style: .default,
                        handler: nil))
      
      self.present(alert, animated: true, completion: nil)
    }
    
    private func showNoAnswerAlert(){
        let alert = UIAlertController(
          title: "No connection to server. Please, try again later",
          message: nil,
          preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(
                          title: "Close",
                          style: .default,
                          handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @objc private func refreshMessages(_ sender: AnyObject) {
        fetchMessages{
            self.activityIndicator.stopAnimating()
            self.refreshControl.endRefreshing()
        }
    }
    
    // MARK: - Configure Cells
    
    private func registerCells() {
      tableView.register(UINib(nibName: "MessageTableViewCell", bundle: nil),
                         forCellReuseIdentifier: "MessageTableViewCell")
    }
    
    private func createMessageCell(indexPath: IndexPath) -> MessageTableViewCell {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell", for: indexPath) as? MessageTableViewCell else
      {
        return MessageTableViewCell()
      }
      
      let message = messages[indexPath.row]
      
      cell.configure(
        name: message.user?.nickname,
        messageText: message.message?.text,
        dateString: message.message?.receiving_date,
        imageUrlString: message.user?.avatar_url)
      
      return cell
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return createMessageCell(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 76
    }
    
}




