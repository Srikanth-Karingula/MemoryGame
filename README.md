MemoryGame
==========

This is a simple MemoryGame written in iOS
This application uses TJImageCache library for caching images.

Development : Xcode 5.1.1
Requirements: iPhone5 and above with iOS7(It may work in lower versions, but not tested).

Issues:
- On 3.5 inch iPhone screen, you may not Find QUIT button in GameView

About Game:
- Requires internet connection atleast for the firsttime, to load the game
- Once the game status shows "Game Loaded", select START and it loads Game View
- Game view shows 9 random images from flickr public api for 15 sec
- After 15sec images are hidden
- Now, one of the image from previous 9 images will be shown randomly at the bottom
- Select the position of the image on the grid view
- Find all 9 image positions, then game ends
- Select QUIT and come back to main screen
- If you want to play with new set of images, Select RELOAD and START game once the game is loaded



