I Don't Think It's a UFO, Aloysius. It's Got Teeth!

Project created by Kat for CS50

A short video presentation of the game can be found here: https://youtu.be/upJTQGy6DnU
class.lua by Matthias Richter, Animation.lua by Colton Ogden  
pewpew code adapted from https://yal.cc/love2d-shooting-things/  
home.png is a vector graphic included with Serif's Affinity Designer  
Additional code inspiration & ideas from the incredibly helpful Love2d forums

IDTIAUFOAIGT is a side-scrolling 2d thrill ride of an adventure in outer space.  
One might say the greatest adventure one might ever hope to encounter.  
That one person is obviously wrong, as this game is a pretty straight forward and simple game.  

You control Aloysius as you try to reach the house at the far right of the map with your brother Mortimer.  
Aloysius is controlled with the left and right arrows for movement and space bar to jump.  
Mortimer follows Aloysius and wil begin jumping and moving towards Aloysius if they get too far apart.  
A prominently-toothed UFO scans back and forth across the sky and will use a tractor beam to abduct Mort if he is below it.  
Aloysius can throw beans at the UFO by pressing enter to disrupt the tractor beam and save his brother.  
The beans are automatically aimed at the UFO's position without leading the target,
so it is best to fire when the UFO is stationary. Points are awarded for hitting the UFO with beans, and 
for reaching the home at the end of the level.

The game lasts for 10 worlds, each of which are procedurally generated and get longer as the game progresses.  
Collisions are handled by Love2D's physics simulation and xy positions for collidables not attached to any 
bodies in the simulation (i.e. the home, UFO, and beans).

Classes were used for the main elements in the world (the UFO, Aloysius & Mortimer, and the home). Many of the
functions used throughout have been placed in a separate utility file to keep the code a little cleaner.
