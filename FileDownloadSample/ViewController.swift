//
//  ViewController.swift
//  FileDownloadSample
//


import UIKit

class ViewController: UIViewController, URLSessionDownloadDelegate {

    var session: URLSession?
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func downloadbutton() {
        
        if session != nil { session = nil}
        
        let sessionConfig = URLSessionConfiguration.background(withIdentifier: "download")
        sessionConfig.timeoutIntervalForRequest = 10
        
        session = URLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
        
    
        let url = URL(string: "https://cdn.icon-icons.com/icons2/1257/PNG/512/1495574271-windowssocialmedialogo_84528.png")!
        
        let downloadTask = session!.downloadTask(with: url)
        
        downloadTask.resume()
    
        showImage()
    }
    
    func getSaveDirectory() -> String {
        let fileManager = FileManager.default
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/AppInfo/"
        
        if fileManager.fileExists(atPath: path) == false {
            createDir(path: path)
        }
        return path
    }
    
    func createDir(path: String) {
        do{
            let fileManager = FileManager.default
            let url = URL(fileURLWithPath: path)
            try fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print(error)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("DidFinished")
        
        do {
            if let data = NSData(contentsOf: location) {
                //let fileExtension = location.pathExtension
                let filePath = getSaveDirectory() + "test.png"
                print(filePath)
                
                try data.write(toFile: filePath, options: .atomic)

            }
        } catch let error as NSError {
            print(error)
        }
    }
    
    func showImage() {
        
        let fileManager = FileManager.default
        let filePath = getSaveDirectory() + "test.png"
        
        if fileManager.fileExists(atPath: filePath) {
            let image = UIImage(named: filePath)
            imageView.image = image
        }
    }
}

