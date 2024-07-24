import raylib

type ThemeColors* = object
    # Neutral colors - backgrounds, borders, text, etc.
    NeutralDarkest*: Color
    NeutralDark*: Color
    NeutralMedium*: Color
    NeutralLight*: Color
    NeutralLightest*: Color

    # Primary colors - for controls, text, highlights, etc.
    AccentDark*: Color
    AccentMedium*: Color
    AccentLight*: Color

const defaultThemeColors* = ThemeColors(
    # Neutral colors - backgrounds, borders, text, etc.
    NeutralDarkest: getColor(0x1b1a25ff'u32), #1b1a25
    NeutralDark: getColor(0x414a53ff'u32), #414a53
    NeutralMedium: getColor(0x717f82ff'u32), #717f82
    NeutralLight: getColor(0xabb6b4ff'u32), #abb6b4
    NeutralLightest: getColor(0x1e1e1eff'u32), #ebf0ec

    # Primary colors - for controls, text, highlights, etc.
    AccentDark: getColor(0x556e05ff'u32), #556e05
    AccentMedium: getColor(0x92b034ff'u32), #92b034
    AccentLight: getColor(0xd3f860ff'u32), #d3f860
)

var currentThemeColors = defaultThemeColors

# PANEL

proc guiPanel*(rec: Rectangle) =
    ## Draws a panel (background)

    let x = rec.x.int32
    let y = rec.y.int32
    let width = rec.width.int32
    let height = rec.height.int32

    drawRectangle(x, y, width, height, currentThemeColors.NeutralMedium)
    drawRectangle(x + 1, y + 1, width - 2, height - 2, currentThemeColors.NeutralLight)

# BUTTON

type
    ButtonState = enum
        Idle, Focused, Pressed, Disabled

    ButtonColors = tuple
        border: Color
        fill: Color
        text: Color

proc updateButtonColors(): array[ButtonState, ButtonColors] =
    result[ButtonState.Idle] = (
        border: currentThemeColors.NeutralDark,
        fill: currentThemeColors.NeutralMedium,
        text: currentThemeColors.NeutralDarkest,
    )
    result[ButtonState.Focused] = (
        border: currentThemeColors.AccentLight,
        fill: currentThemeColors.NeutralMedium,
        text: currentThemeColors.AccentLight,
    )
    result[ButtonState.Pressed] = (
        border: currentThemeColors.AccentLight,
        fill: currentThemeColors.AccentDark,
        text: currentThemeColors.AccentLight,
    )
    result[ButtonState.Disabled] = (
        border: currentThemeColors.NeutralMedium,
        fill: currentThemeColors.NeutralLight,
        text: currentThemeColors.NeutralMedium,
    )

var buttonColors: array[ButtonState, ButtonColors] = updateButtonColors()

proc guiButton*(label: string, rec: Rectangle, disabled = false): bool =
    ## Draws a button with a label.
    ## Returns true if the button was clicked.
    
    let x = rec.x.int32
    let y = rec.y.int32
    let width = rec.width.int32
    let height = rec.height.int32
    
    # Evaluate button state
    var state = if disabled: Disabled else: Idle
    if not disabled:
        let mousePos = getMousePosition()
        let mouseX = mousePos.x.int32
        let mouseY = mousePos.y.int32
        if mouseX >= x and mouseX <= x + width and mouseY >= y and mouseY <= y + height:
                if isMouseButtonDown(Left) or isMouseButtonReleased(Left):
                    state = Pressed
                else:
                    state = Focused
    
    # Draw button
    let ( border, fill, text ) = buttonColors[state]

    drawRectangle(x, y, width, height, border)
    drawRectangle(x + 1, y + 1, width - 2, height - 2, fill)
    drawText(label, x + 10, y + 10, 20, text)

    # Return true only once after mouse button is released while on the ui element.
    return state == Pressed and isMouseButtonReleased(Left)


proc setThemeColors*(colors: ThemeColors) =
    ## Sets the theme colors and updates all color cache.
    currentThemeColors = colors
    buttonColors = updateButtonColors()