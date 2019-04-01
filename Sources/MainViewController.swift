import Foundation
import UIKit
import Vision

public class MainViewController : UIViewController
{
    //Vission Request
    var VNRequest: VNCoreMLRequest!
    var observationHandlers = [([VNClassificationObservation]) -> Void]()
    
    // UI item on the view.
    lazy var headerLabel : UILabel = {
        let instance = UILabel()
        instance.frame = CGRect(x: 0, y: 0, width: 380, height: 100)
        instance.text = "Write an Alphabet and Learn Country Names"
        instance.textAlignment = .center
        instance.font = UIFont(name: "Futura", size: 20.0)
        instance.numberOfLines = 0
        instance.backgroundColor = UIColor(red: 251/255, green: 140/255, blue: 0/255, alpha: 1)
        instance.textColor = .black
        return instance
    }()
    
    lazy var displayCountryName : UILabel = {
        let instance = UILabel()
        instance.frame = CGRect(x: 0, y: 80, width: 380, height: 200)
        instance.text = "Hello"
        instance.textAlignment = .center
        instance.font = UIFont(name: "Futura", size: 25.0)
        instance.numberOfLines = 0
        instance.textColor = .black
        return instance
    }()
    
    // Done and Cancel Button
    lazy var doneButton : UIButton =
    {
     let instance = UIButton(type: .system)
        instance.setTitle("Done", for: .normal)
        instance.addTarget(self, action: #selector(handleDoneButton), for: .touchUpInside)
        instance.titleLabel?.font = UIFont(name: "Futura", size: 15.0)
        instance.setTitleColor(UIColor.black, for: .normal)
        instance.backgroundColor = UIColor(red: 251/255, green: 140/255, blue: 0/255, alpha: 1)
        instance.layer.borderColor = UIColor.white.cgColor
        instance.layer.borderWidth = 1
        instance.layer.cornerRadius = 5
        instance.isEnabled = true
        return instance
        
    }()
    
    lazy var clearButton : UIButton = {
        let instance = UIButton(type: .system)
        instance.setTitle("Clear", for: .normal)
        instance.addTarget(self, action: #selector(handleClearButton), for: .touchUpInside)
        instance.titleLabel?.font = UIFont(name: "Futura", size: 15.0)
        instance.setTitleColor(UIColor.black, for: .normal)
        instance.backgroundColor = UIColor(red: 251/255, green: 140/255, blue: 0/255, alpha: 1)
        instance.layer.borderColor = UIColor.white.cgColor
        instance.layer.borderWidth = 1
        instance.layer.cornerRadius = 5
        instance.isEnabled = true
        return instance
    }()
    
    //DrawingCavas for writing an Alphabet
    lazy var drawingCanvas : CanvasView =
    {
        let instance = CanvasView(frame: CGRect(x: 0, y: 360, width: 380, height: 360))
        instance.backgroundColor = .black
        return instance
    }()
    
    
    public override func loadView() {
        
        view = UIView(frame: CGRect(x: 0, y: 0, width: 350, height: 700))
        view.backgroundColor = UIColor(red: 255/255, green: 224/255, blue: 178/255, alpha: 1)
        
        view.addSubview(headerLabel)
        view.addSubview(displayCountryName)
        view.addSubview(doneButton)
        view.addSubview(clearButton)
        view.addSubview(drawingCanvas)
        
        //Setting Constraints of Done Button
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.topAnchor.constraint(equalTo: displayCountryName.bottomAnchor, constant: 10).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        //Adding Constraints For Clear Button
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.topAnchor.constraint(equalTo: displayCountryName.bottomAnchor, constant: 10).isActive = true
        clearButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        clearButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        clearButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        self.setUpVision()
    }
 
    
    @objc func handleDoneButton()
    {
        let alphabetImage = UIImage(view: drawingCanvas)
        let scaledImage = scaleImage(image: alphabetImage, toSize: CGSize(width: 299, height: 299))
        self.classify(scaledImage)
    }
    
    @objc func handleClearButton()
    {
        drawingCanvas.lines = []
        drawingCanvas.setNeedsDisplay()
        self.displayCountryName.text = "Write Something In Canvas" 
    }
    
    func scaleImage(image : UIImage ,  toSize size : CGSize) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
 
    //Setting up Vision
    func setUpVision()
    {
    do
    {
    let visionModel = try VNCoreMLModel(for: AlphabetModel().model)
    self.VNRequest = VNCoreMLRequest(model: visionModel, completionHandler: { [weak self] request, error in
    self?.processClassifications(for: request, error: error)
    })
    VNRequest.imageCropAndScaleOption = .scaleFit
    }
    catch
    {
        print("Error in loading the Model")
    }
    }
    
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                print("Unable to classify image.\n\(error!.localizedDescription)")
                return
            }
            
            let classifications = results.compactMap({$0 as? VNClassificationObservation}).filter({$0.confidence > 0.8}).map({$0.identifier})
            
            if (classifications.count > 0)
            {
               guard let alphabet = classifications.first else
            {
                return
            }
                switch alphabet
                {
                case "A":
                    self.displayCountryName.text = "A : Australia \nA: America \nA: Afganistan"
                case "B":
                    self.displayCountryName.text = "B: Bangladesh \nB: Brazil \nB:Bahrain "
                case "C":
                    self.displayCountryName.text = "C:  Canada \nC: China  \nC: Colombia"
                case "D":
                    self.displayCountryName.text = "D: Denmark \nD: Dominicia \nD: Djibouti"
                case "E":
                    self.displayCountryName.text = "E: Egypt \nE: Estonia \nE:Ethiopia"
                case "F":
                    self.displayCountryName.text = "F: France \nF: Finland \nF: Fiji"
                case "G":
                    self.displayCountryName.text = "G: Germany \nG: Geogia \nG: Guinea"
                case "H":
                    self.displayCountryName.text = "H: Hungary \nH: Honduras \nH: Haiti"
                case "I":
                    self.displayCountryName.text = "I: Iceland \nI: India \nI: Indonesia"
                case "J":
                    self.displayCountryName.text = "J: Japan \nJ: Jamacia \nJ: Jordan"
                case "K":
                    self.displayCountryName.text = "K: Kenya \nK: Kuwait \nK:Kazakhstan"
                case "L":
                    self.displayCountryName.text = "L: Lebanon \nL: Liberia \nL: Lithuania"
                case "M":
                    self.displayCountryName.text = "M: Malawi \nM: Malawi \nM: Mexico"
                case "N":
                    self.displayCountryName.text = "N: Nepal \nN: Netherland \nN: Norway"
                case "O":
                    self.displayCountryName.text = "O: Oman"
                case "P":
                    self.displayCountryName.text = "P: Pakistan \nP: Portugal \nP: Palau"
                case "Q":
                    self.displayCountryName.text = "Q: Qatar"
                case "R":
                    self.displayCountryName.text = "R: Romania \nR: Russia \nR: Rwanda"
                case "S":
                    self.displayCountryName.text = "S: Saudi Arabia \nS: Serbia \nS: Slovakia"
                case "T":
                    self.displayCountryName.text = "T: Taiwan \nT: Togo \nT:Turkey"
                case "U":
                    self.displayCountryName.text = "U: Uganda \nU: Uzbekistan \nU: Ukraine"
                case "V":
                    self.displayCountryName.text = "V: Vanuatu \nV: Venezuela \nV:Vietnam"
                case "W":
                    self.displayCountryName.text = "W: Wales"
                case "X":
                    self.displayCountryName.text = "No country name start with X :("
                case "Y":
                    self.displayCountryName.text = "Y: Yemen"
                case "Z":
                    self.displayCountryName.text = "Z: Zambia \nZ: Zimbabwe"
                default :
                    self.displayCountryName.text = "Alphabet Didn't Match"
            }
            }
            else
            {
                self.displayCountryName.text = "No Match Found"
            }
        }
    }
    
    public func classify(_ image: UIImage) {
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: CIImage(image: image)!, orientation: .up)
            do {
                try handler.perform([self.VNRequest!])
            } catch {
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
}

extension UIImage{
    convenience init(view : UIView)
    {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage : image!.cgImage!)
    }
}



