//
//  ViewController.swift
//  Renda10min
//
//  Created by 若宮拓也 on 2022/08/31.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var numLabel:UILabel!
    @IBOutlet var pokeLabel:UILabel!
    
    @IBOutlet var numButton:UIButton!
    
    @IBOutlet var pokeImage:UIImageView!
    
    var number = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //request()
    }

    @IBAction func countplus(){
        number += 1
        request()
        
        numLabel.text = String(number)
    }
    
    func request() {
            guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(number)/") else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data {
                    let pokemon = try! JSONDecoder().decode(PokemonData.self, from: data)
                    dump(pokemon)
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, _) in
                        if granted {
                            DispatchQueue.main.async {
                                self.pokeLabel.text = String(pokemon.name)
                                let imageUrl:UIImage = self.getImageByUrl(url: pokemon.sprites.front_default.absoluteString)
                                self.pokeImage.image = imageUrl
                            }
                        }
                    }
                    //let imageUrl:UIImage = self.getImageByUrl(url:String(contentsOf: pokemon.sprites.front_default))
                    //self.pokeImage.image = UIImage(URL: imageUrl)
                }
            })
            task.resume()
    }
    
    
    private func showImage(imageView: UIImageView, url: String) {
            let url = URL(string: url)
            do {
                let data = try Data(contentsOf: url!)
                let image = UIImage(data: data)
                pokeImage.image = image
            } catch let err {
                print("Error: \(err.localizedDescription)")
            }
    }
    
    func getImageByUrl(url: String) -> UIImage{
        let url = URL(string: url)
        do {
            let data = try Data(contentsOf: url!)
            return UIImage(data: data)!
        } catch let err {
            print("Error : \(err.localizedDescription)")
        }
        return UIImage()
    }
}

struct PokemonData: Codable {
    let name: String
    let species: Species
    let sprites: Sprites
    
}

struct Species: Codable {//デコード、エンコード設定
        var name: String
        var url: URL
}

struct Sprites: Codable{
    var front_default: URL
}
