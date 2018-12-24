# Open Source Artzy&#8482; Camera

The Open Source <a href="http://www.artzyapp.com">Artzy&#8482; </a> Camera is an ARKit super-starter project created by <a href="http://www.delasign.com">Delasign</a> that features an AR multi-media recorder, 3 AR samples, a library of free metal shaders and special effects, illustrator files and maya files.

<img src="https://s3.amazonaws.com/www.artzyapp.com/images/opensourceHero.png" width=100% />

# Sharing is caring.

If you create anything, please share it on Instagram and tag <a href="https://www.instagram.com/artzyapp/">@artzyapp</a> along with #artzy.


# Getting started
Download the repo and print the three images in the "GettingStarted" folder. These are the three AR samples that come with the project.

After printing, open the app and place your phone infront of the images to experience the three samples.

# Ok, I want to start creating.
I recommend reading up on AR and ARKit before becoming familiar with how the samples were created. These are found in the "HowItWasMade" folder, which includes the files that were used and the corresponding images.

If you have any questions please email questions to : artzy@delasign.com

# Recommended reading

For all posts ever, please visit <a href="http://www.oscardelahera.com/blog">my blog.</a>

<b>Apple Documentation</b>:

- <a href="https://developer.apple.com/documentation/arkit">ARKit</a>
- <a href="https://developer.apple.com/documentation/arkit/building_your_first_ar_experience">Building your first ARKit Experience</a>


- <a href="https://developer.apple.com/documentation/arkit/arworldtrackingconfiguration">AR World Tracking Configuration</a>
- <a href="https://developer.apple.com/documentation/arkit/understanding_world_tracking_in_arkit">Understanding World Tracking in ARKit</a>

- <a href="https://developer.apple.com/documentation/arkit/arreferenceimage">ARReferenceImages</a>
- <a href="https://developer.apple.com/documentation/arkit/arimageanchor">ARImageAnchor</a>
- <a href="https://developer.apple.com/documentation/arkit/recognizing_images_in_an_ar_experience">Recognizing Images in an AR Experience</a>


- <a href="https://developer.apple.com/documentation/arkit/arframe">ARFrame</a>
- <a href="https://developer.apple.com/documentation/arkit/arcamera">ARCamera</a>


- <a href="https://developer.apple.com/documentation/scenekit">SceneKit</a>
- <a href="https://developer.apple.com/documentation/scnnode">SCNNode</a>
- <a href="https://developer.apple.com/documentation/scnprogram">SCNProgram</a>
- <a href="https://developer.apple.com/documentation/scenekit/scntechnique">SCNTechnique</a>

<b>ARKit Theory</b>:

- <a href="https://medium.com/ar-tips-and-tricks/arkit-theory-the-point-cloud-image-recognition-ar-ready-images-true-scale-the-renderer-and-e1508398dd4">The Point Cloud, Image Recognition, AR Ready Images, True Scale, The Renderer and Nodes</a>
- <a href="https://medium.com/ar-tips-and-tricks/arkit-theory-vertices-metal-shaders-uv-mapping-and-scnprograms-445e9fc4c53f">Vertices, Metal Shaders, UV Mapping and SCNProgram’s.</a>
- <a href="https://medium.com/ar-tips-and-tricks/arkit-theory-arcamera-point-of-view-81e1fe7088e5">ARCamera POV.</a>
- <a href="https://medium.com/ar-tips-and-tricks/arkit-theory-an-introduction-to-scntechniques-710e024bc91e">Intro to SCNTechniques.</a>


# Sample projects

The repository comes with three opensource AR samples, which are detailed below.

## 'local' by <a href="https://www.instagram.com/adamfu/">adamfu</a> x delasign

This project features a double neon glow - the word glows in blue, whilst the halo glows in red.

For tutorials on how this was created please read the following:

<b>Geometry</b>:

- <a href="https://medium.com/ar-tips-and-tricks/how-to-use-an-adobe-illustrator-curve-in-maya-7e7f189e7ed8">How to use an Adobe Illustrator Curve in Maya.</a>
- <a href="https://medium.com/ar-tips-and-tricks/how-to-turn-a-turn-a-simple-sketch-into-an-extruded-model-on-maya-5e9520ca5bc9">How to turn a turn a simple sketch into an extruded model on Maya</a>
- <a href="https://medium.com/ar-tips-and-tricks/uv-mapping-how-to-convert-an-extruded-cylinders-uv-s-to-simple-layout-1c6f9c20f31">UV Mapping: How to Convert an Extruded Cylinder’s UV’s to Simple Layout</a>

<b>Neon</b>:

- <a href="https://developer.apple.com/documentation/scenekit/scntechnique">Apple Documentation : SCNTechnique</a>
- <a href="https://medium.com/ar-tips-and-tricks/arkit-theory-an-introduction-to-scntechniques-710e024bc91e">ARKit Theory: Intro to SCNTechniques.</a>
- <a href="https://medium.com/ar-tips-and-tricks/how-to-create-a-glowing-neon-effect-for-a-geometry-in-arkit-through-an-scntechnique-22c70acd5f42">How to create a glowing neon effect for a geometry in ARKit through a SCN Technique</a>
- <a href="https://medium.com/ar-tips-and-tricks/a-scntechnique-requires-a-scn-model-filetype-b8cf01c93414">A SCNTechnique requires a .scn model</a>


<b>Files</b>:

The key parts to this working are found in *PieceOfArtzy/PieceOfArtzy.swift* line 182 -> 264, with the SCNTechnique and associated assets under the *PieceOfArtzy/SpecialEffects/GlowInTwoColors* folder.

<b>Extra</b>:
To see it perform an animated, timed stroke - switch the functionality in *PieceOfArtzy/PieceOfArtzy.swift* line 34.

## 'loader' by delasign

This project features a 3d stroke neon glow - it appears as though the word has been drawn.

For tutorials on how this was created please read the following:

<b>Geometry</b>:

- <a href="https://medium.com/ar-tips-and-tricks/how-to-use-an-adobe-illustrator-curve-in-maya-7e7f189e7ed8">How to use an Adobe Illustrator Curve in Maya.</a>
- <a href="https://medium.com/ar-tips-and-tricks/how-to-turn-a-turn-a-simple-sketch-into-an-extruded-model-on-maya-5e9520ca5bc9">How to turn a turn a simple sketch into an extruded model on Maya</a>
- <a href="https://medium.com/ar-tips-and-tricks/uv-mapping-how-to-convert-an-extruded-cylinders-uv-s-to-simple-layout-1c6f9c20f31">UV Mapping: How to Convert an Extruded Cylinder’s UV’s to Simple Layout</a>

<b>Neon</b>:

- <a href="https://developer.apple.com/documentation/scenekit/scntechnique">Apple Documentation : SCNTechnique</a>
- <a href="https://medium.com/ar-tips-and-tricks/arkit-theory-an-introduction-to-scntechniques-710e024bc91e">ARKit Theory: Intro to SCNTechniques.</a>
- <a href="https://medium.com/ar-tips-and-tricks/how-to-create-a-glowing-neon-effect-for-a-geometry-in-arkit-through-an-scntechnique-22c70acd5f42">How to create a glowing neon effect for a geometry in ARKit through a SCN Technique</a>
- <a href="https://medium.com/ar-tips-and-tricks/how-to-connect-custom-variables-to-scntechnique-and-associated-metal-shaders-419c6d00079f">How to connect custom variables to SCNTechniques and Associated Metal Shaders</a>
- <a href="https://medium.com/ar-tips-and-tricks/a-scntechnique-requires-a-scn-model-filetype-b8cf01c93414">A SCNTechnique requires a .scn model</a>

<b>Stroke</b>:
The key parts to this working are found in *PieceOfArtzy/PieceOfArtzy.swift* line 66 -> 92. The amount of the letter that must be shown at any given instance has to be programmed in order for the camera to be able to capture it. For a non-capturable version and how to take it from there to the latest version, please read:

- <a href="https://medium.com/ar-tips-and-tricks/a-free-stroke-metal-shader-on-a-timer-for-arkit-ios-11-4-12-8c69cbcaae80">Free Stroke Metal Shader on a Timer</a>

- <a href="https://medium.com/ar-tips-and-tricks/arkit-tutorial-how-to-attach-custom-variables-to-a-metal-shader-its-associated-scnprogram-6f34cf436978">ARKit Tutorial: How to attach Custom Variables to a Metal Shader & its associated SCNProgram through a TimedStroke Shader iOS 12.</a>

- <a href="https://medium.com/ar-tips-and-tricks/how-to-connect-custom-variables-to-scntechnique-and-associated-metal-shaders-419c6d00079f">How to connect custom variables to SCNTechniques and Associated Metal Shaders</a>


<b>Files</b>:

The key parts to this working are found in *PieceOfArtzy/PieceOfArtzy.swift* line 264 -> 312, with the SCNTechnique and associated assets under the *PieceOfArtzy/SpecialEffects/Glow* folder.


## 'hand' by delasign

This project features an outline of a hand that animates to show you the peace sign.

For tutorials on how this was created please read the following:

<b>Geometry</b>:

- <a href="https://medium.com/ar-tips-and-tricks/how-to-use-an-adobe-illustrator-curve-in-maya-7e7f189e7ed8">How to use an Adobe Illustrator Curve in Maya.</a>
- <a href="https://medium.com/ar-tips-and-tricks/how-to-turn-a-turn-a-simple-sketch-into-an-extruded-model-on-maya-5e9520ca5bc9">How to turn a turn a simple sketch into an extruded model on Maya</a>
- <a href="https://medium.com/ar-tips-and-tricks/uv-mapping-how-to-convert-an-extruded-cylinders-uv-s-to-simple-layout-1c6f9c20f31">UV Mapping: How to Convert an Extruded Cylinder’s UV’s to Simple Layout</a>

<b>Animation</b>:
Please note that the key to this is to only rotate the joints.

- <a href="https://medium.com/ar-tips-and-tricks/how-to-create-an-animation-in-maya-and-make-it-work-in-scenekit-or-arkit-477333e5503c">How to make an animtion in Maya that works in SceneKit or ARKit.</a>

- <a href="https://www.youtube.com/watch?v=Fcl1fs7Bn_M">Maya Weight Painting Tutorial</a>

<b>Files</b>:

The key parts to this working are found in *PieceOfArtzy/PieceOfArtzy.swift* line 41 -> 59.


# Shader library
If you are new to Shaders please read this: <a href="https://medium.com/ar-tips-and-tricks/arkit-theory-vertices-metal-shaders-uv-mapping-and-scnprograms-445e9fc4c53f">Vertices, Metal Shaders, UV Mapping and SCNProgram’s.</a>

The current shader library can be found in *PieceOfArtzy/Shaders* and includes:

- Color Shader
- Texture Shader
- Stroke Shader
- Backwards Stroke Shader
- Timed Stroke Shader
- Timed Backwards Stroke Shader
- Fade In Color Shader
- Fade In Texture Shader



# License
MIT License

Copyright (c) 2018 Delasign LLC.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

## Artzy&#8482; Logo

Created by <a href="https://www.instagram.com/adamfu/">AdamFu</a> under the and licensed under the <a href="https://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</a>.

<img src="https://camo.githubusercontent.com/70da218c8e50defea0d35ba13cd2fd8b1b068190/68747470733a2f2f63646e2e737465656d6974696d616765732e636f6d2f44516d56534837687874336e757944784e5264575542554274665231315479764c784d314631433476595735557a472f4445524543484f532e6a7067" />


