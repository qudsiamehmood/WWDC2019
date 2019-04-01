
/*:
 ## Sketch And Learn

 
 ### Introduction
 A simple learning view which recognise the handwritten alphabet and show the country name start with this alphabet, using Machine Learning capabilities of
 recognizing hand written alphabet, using Apple API's CoreML and Vision.

 
 ### Usage
This scene can be run by using play button at the bottom of the editor window. Open live view in the assistant editor to use all the features.
 
 
 ### Features
* User can draw the alphabet in the canvas.
* User can clear the canvas for redrawing.
* User view the countries stating with written alphabet by using Done button.
 

 ### CoreML Model
I create my own custom ML model by using createML. I trained the model by using different images of all alphabets. My training data include almost 420 pictures of alphabets.
 
### Idea Behind This
 Idea behind making this scene is everyone have cellphones now a days and we experience many of children using their guardience phone they watch different video , cartoons or play games. To increase the productivity at the same time to make your child learn new things , this scene prefectly goes with this idea. In which there is a canvas you can learn by drawing an alphabet and learn countries names at the same time.
 
*/



import UIKit
import PlaygroundSupport

let controller = MainViewController()
PlaygroundPage.current.liveView = controller

