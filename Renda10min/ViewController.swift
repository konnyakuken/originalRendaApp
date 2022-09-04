//
//  ViewController.swift
//  Renda10min
//
//  Created by 若宮拓也 on 2022/08/31.
//

import UIKit
import SwiftCoroutine
import PKHUD

class ViewController: UIViewController {
    
    @IBOutlet var numLabel:UILabel!
    @IBOutlet var pokeLabel:UILabel!
    
    @IBOutlet var numButton:UIButton!
    @IBOutlet var backButton:UIButton!
    @IBOutlet var randomNumber:UIButton!
    @IBOutlet var resetButton:UIButton!
    
    
    @IBOutlet var pokeImage:UIImageView!
    
    var indicatorBackgroundView: UIView!
    var indicator: UIActivityIndicatorView!
    
    
    
    var number = 0
    var isLoading = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //request()
    }

    @IBAction func countplus(){
        if(isLoading == false){
            number += 1
            doSomething()
            //request()
            
            numLabel.text = "No."+String(number)
        }
    }
    
    @IBAction func countminus(){
        if(isLoading == false){
            if(number == 0 || number == 1){
                number = 151
                
            }else{
                number-=1
            }
            doSomething()
            numLabel.text = "No."+String(number)
        }
        
        
    }
    
    @IBAction func randomPokemon(){
        if(isLoading == false){
            number = Int.random(in: 1..<400)
            doSomething()
            numLabel.text = "No."+String(number)
        }
        
    }
    
    @IBAction func resetPokemon(){
        
        number = 1
        doSomething()
        numLabel.text = "No."+String(number)
    }
    
    //コルーチン利用考えたが、実装方針変更
    func doSomething() {
        
        let future: CoFuture<Int> = DispatchQueue.global().coroutineFuture {
            try Coroutine.delay(.seconds(1))
                    return 1
                }
        
        DispatchQueue.main.startCoroutine {
                    //self.isLoading = true
                    //let result: Int = try future.await()
                    self.request()
                    self.isLoading = false
                    //print("result:\(result)")
                }
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
                                HUD.hide()
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
        
            HUD.show(.progress)// HUDを表示
            HUD.show(.progress, onView: view)// 表示もとのviewを明示的に指定
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
