import raylib
import slapdash

# ----------------------------------------------------------------------------------------
# Global Variables Definition
# ----------------------------------------------------------------------------------------

const
    screenWidth = 800
    screenHeight = 450

# ----------------------------------------------------------------------------------------
# Program main entry point
# ----------------------------------------------------------------------------------------

proc main =
    # Initialization
    # --------------------------------------------------------------------------------------

    initWindow(screenWidth, screenHeight, "slapdash demo")
    defer: closeWindow()

    setTargetFPS(60)
    
    
    # --------------------------------------------------------------------------------------
    while not windowShouldClose():
        # Update
        # ------------------------------------------------------------------------------------
        

        # ------------------------------------------------------------------------------------
        # Draw
        # ------------------------------------------------------------------------------------

        beginDrawing()
        clearBackground(RayWhite)

        guiPanel(Rectangle(x: 90, y: 90, width: 220, height: 190))
        if guiButton("Click me!", Rectangle(x: 100, y: 100, width: 200, height: 40)):
          drawText("You clicked me!", 100, 150, 20, LightGray)
        if guiButton("Disabled", Rectangle(x: 100, y: 200, width: 200, height: 40), disabled = true):
          drawText("You can't click me!", 100, 250, 20, LightGray)

        endDrawing()

        # ------------------------------------------------------------------------------------
    # De-Initialization
    # --------------------------------------------------------------------------------------
  
main()