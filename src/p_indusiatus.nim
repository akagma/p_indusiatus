import std/[
  browsers,
  encodings,
  options,
  unicode
]

import dialogs

import f_velutipes


proc main(): cint =
  var
    dirPathLineEdit = lineEdit(
      name = "dir_path_line_edit",
      text = "",
      shape = rect(0, 0, 405, 40)
    )
    dirPathBrowseButton = rectPushButton(
      name = "dir_path_browse_button",
      text = "Browse",
      tooltip = some(toolTip(
        text = "Choose dir path"
      ))
    )

    rootLayout = layout(
      name = "root_layout",
      direction = LayoutDirection.Vertical,
      bgcolor = some(WidgetColor(
        enabled: parseHtmlColor(shikkoku),
        disabled: parseHtmlColor(shikkoku),
        hover: parseHtmlColor(shikkoku)
      )),
      children =
        @[
          layout(
            name = "image_layout",
            direction = LayoutDirection.Vertical,
            children = @[
              label(
                name = "image_label",
                minSize = vec2(640, 480),
                text = "Image is displayed here.",
                bgcolor = some(defaultBackgroundColor),
                border = some(Border(width: 1, color: defaultBorderColor)),
                horizontalAlignment = HorizontalAlignment.CenterAlign
              )
            ]
          ),
          layout(
            name = "dir_path_layout",
            direction = LayoutDirection.Horizontal,
            verticalAlignment = LayoutVerticalAlignment.Center,
            children =
              @[
                label(
                  name = "dir_path_label",
                  text = "dir path:"
                ),
                dirPathLineEdit,
                dirPathBrowseButton
              ]
          ),
          layout(
            name = "button_box_layout",
            direction = LayoutDirection.Horizontal,
            verticalSizeState = WidgetSizeState.Fixed,
            children =
              @[
                layout(
                  name = "left_button_box_layout",
                  direction = LayoutDirection.Horizontal,
                  children =
                    @[
                      rectPushButton(
                        name = "help_button",
                        text = "Help",
                        tooltip = some(tooltip(
                          text = "Display online help page"
                        )),
                        onClicked = proc() =
                          echo "Launch help page"
                          openDefaultBrowser(
                            "https://github.com/akagma/p_indusiatus"
                          )
                      ),
                      rectPushButton(
                        name = "default_button",
                        text = "Set Default",
                        onClicked = proc() =
                          echo "Set default parameters"
                      ),
                      rectPushButton(
                        name = "execute_button",
                        text = "Execute",
                        onClicked = proc() =
                          echo "Execute image conversion"
                      )
                    ]
                )
              ]
          )
        ]
    )

  var
    frame: int

  let windowManager = newWindowManager(
    window = newWindow("Phallus Indusiatus - 0.2.0", ivec2(1280, 800)),
    rootWidget = rootLayout
  )

  windowManager.addImage()

  windowManager.window.onFrame = proc() =
    windowManager.updateImage()
    windowManager.display()

  dirPathBrowseButton.pushButton.onClicked = proc() =
    when defined(windows):
      dirPathLineEdit.lineEdit.text =
        chooseDir(nil)
        .convert("UTF-8", "shift_jis")
    else:
      dirPathLineEdit.lineEdit.text = chooseDir(nil)

    let position = validateUtf8(dirPathLineEdit.lineEdit.text)
    if position >= 0:
      echo "Invalid UTF-8 character at: " & $position
      dirPathLineEdit.lineEdit.text = ""

    dirPathLineEdit.lineEdit.updated = true
    echo "Set dir path to line edit: " & dirPathLineEdit.lineEdit.text 
    windowManager.updateImage()

  while not windowManager.window.closeRequested:
    inc frame
    pollEvents()
  
  0


when isMainModule:
  quit(main())
