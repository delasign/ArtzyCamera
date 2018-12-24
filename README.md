# Opensource Artzy Camera

The Opensource Artzy Camera is a ARKit starter project created by <a href="http://www.delasign.com">Delasign</a> that features an AR Video recorder, 3 AR samples, a library of free metal shaders and special effects, illustrator files and maya files.

# Recommended Reading

For all non-apple posts ever, please visit <a href="http://www.oscardelahera.com/blog">my blog.</a>

<b>Apple Documentation</b>:

<a href="https://developer.apple.com/documentation/arkit">ARKit</a>

<a href="https://developer.apple.com/documentation/arkit/building_your_first_ar_experience">Building your first ARKit Experience</a>


<a href="https://developer.apple.com/documentation/arkit/arworldtrackingconfiguration">AR World Tracking Configuration</a>

<a href="https://developer.apple.com/documentation/arkit/understanding_world_tracking_in_arkit">Understanding World Tracking in ARKit</a>

<a href="https://developer.apple.com/documentation/arkit/arreferenceimage">ARReferenceImages</a>

<a href="https://developer.apple.com/documentation/arkit/arimageanchor">ARImageAnchor</a>

<a href="https://developer.apple.com/documentation/arkit/recognizing_images_in_an_ar_experience">Recognizing Images in an AR Experience</a>


<a href="https://developer.apple.com/documentation/arkit/arframe">ARFrame</a>

<a href="https://developer.apple.com/documentation/arkit/arcamera">ARCamera</a>


<a href="https://developer.apple.com/documentation/scenekit">SceneKit</a>

<a href="https://developer.apple.com/documentation/scnnode">SCNNode</a>

<a href="https://developer.apple.com/documentation/scenekit/scntechnique">SCNTechnique</a>

<b>ARKit Theory</b>:

<a href="https://medium.com/ar-tips-and-tricks/arkit-theory-the-point-cloud-image-recognition-ar-ready-images-true-scale-the-renderer-and-e1508398dd4">The Point Cloud, Image Recognition, AR Ready Images, True Scale, The Renderer and Nodes</a>

<a href="https://medium.com/ar-tips-and-tricks/arkit-theory-vertices-metal-shaders-uv-mapping-and-scnprograms-445e9fc4c53f">Vertices, Metal Shaders, UV Mapping and SCNProgram’s.</a>

<a href="https://medium.com/ar-tips-and-tricks/arkit-theory-arcamera-point-of-view-81e1fe7088e5">ARCamera POV.</a>

<a href="https://medium.com/ar-tips-and-tricks/arkit-theory-an-introduction-to-scntechniques-710e024bc91e">Intro to SCNTechniques.</a>


# Sample Projects

The repository comes with three opensource AR samples:

## 'local' by adamfu x delasign

This project features a double neon glow - the word glows in blue, whilst the halo glows in red.

For tutorials on how this was created please read the following:

<b>Geometry</b>:

<a href="https://medium.com/ar-tips-and-tricks/how-to-use-an-adobe-illustrator-curve-in-maya-7e7f189e7ed8">How to use an Adobe Illustrator Curve in Maya.</a>

<a href="https://medium.com/ar-tips-and-tricks/how-to-turn-a-turn-a-simple-sketch-into-an-extruded-model-on-maya-5e9520ca5bc9">How to turn a turn a simple sketch into an extruded model on Maya</a>

<a href="https://medium.com/ar-tips-and-tricks/uv-mapping-how-to-convert-an-extruded-cylinders-uv-s-to-simple-layout-1c6f9c20f31">UV Mapping: How to Convert an Extruded Cylinder’s UV’s to Simple Layout</a>

<b>Neon</b>:

<a href="https://developer.apple.com/documentation/scenekit/scntechnique">Apple Documentation : SCNTechnique</a>

<a href="https://medium.com/ar-tips-and-tricks/arkit-theory-an-introduction-to-scntechniques-710e024bc91e">ARKit Theory: Intro to SCNTechniques.</a>

<a href="https://medium.com/ar-tips-and-tricks/how-to-create-a-glowing-neon-effect-for-a-geometry-in-arkit-through-an-scntechnique-22c70acd5f42">How to create a glowing neon effect for a geometry in ARKit through a SCN Technique</a>

<b>Files</b>:

The key parts to this working are found in *PieceOfArtzy/PieceOfArtzy.swift* line 182 -> 286, with the SCNTechnique and associated assets under the *PieceOfArtzy/SpecialEffects/GlowInTwoColors* folder.
