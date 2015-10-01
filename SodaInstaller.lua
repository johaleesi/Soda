
--# Demo
function demo1()
    --[[
    You only need to give an element a temporary handle (a local variable name) if it is the parent of other elements, or you need to refer to it in a callback
    
    To define an element as a child of another, just add "parent = parentName" to its constructor
    
    x,y,w,h of elements are defined relative to their parents, according to 3 rules:
    
    1. if x,y,w, or h are positive integers, they behave as normal coordinates in rectMode CORNER (ie pixels from the origin)
    
    2. if x,y,w,or h are floating point between 0 and 1, they describe proportions in CENTER mode (x,y 0.5 is centred)
    
    3. if x,y,w, or h are negative, they describe distance in pixels from the TOP or RIGHT edge, as in CORNERS mode (ie, w,h become x2,y2 rather than width and height). if x and y are negative, they also behave the same way as w,h, describing the distance between the TOP/RIGHT edge of the parent, and the TOP/RIGHT edge of the child.
    
    the above 3 rules can be mixed together in one definition. eg a button fixed to the bottom right corner of its parent with a 20 pixel border, with a variable width of a quarter of its parent's width, and a fixed height of 40 pixels, would be: x = -20, y = 20, w = 0.25, h = 40.
    
    4. How do you fix an element to the top or right edge (or, how do you write -0)? Use -0.001
      ]]
    
    --the main panel
    
    local panel = Soda.Window{ --give parent a local handle, in this case "panel", to define children
        title = "Demonstration", 
        hidden = true, --not visible or active initially
        x=0.7, y=0.5, w=0, h=0.7, 
        blurred = true, style = Soda.style.darkBlurred, --gaussian blurs what is underneath it
        shadow = true,
        shapeArgs = { corners = 1 | 2} --only round left-hand corners
    }
    
    --A menu button to show & hide the main panel
    
    local menu = Soda.MenuToggle{x = -20, y = -20, --a button to activate the above panel
    callback = function() panel:show(RIGHT) end,
    callbackOff = function() panel:hide(RIGHT) end,
    }
    
    Soda.QueryButton{ --a button to open the help readme
        parent = panel,
        x = 10, y = -10,
        callback = function() openURL("https://github.com/Utsira/Soda/blob/master/README.md", true) end
    }
    
    --three panels to hold various elements, and a segemented button to determine which panel is displayed.
    
    local buttonPanel = Soda.Frame{
        parent = panel,
        x = 20, y = 20, w = -20, h = -140, --20 pixel border on left, right, bottom
        shape = Soda.RoundedRectangle, style = Soda.style.translucent,
    }
    
    local textEntryPanel = Soda.Frame{
        parent = panel,
        x = 20, y = 20, w = -20, h = -140,
        shape = Soda.RoundedRectangle, style = Soda.style.translucent,     
    }
    
    local list = Soda.List{ --a vertically scrolling list of items
        parent = panel, 
        x = 20, y = 20, w = -20, h = -140,
        text = listProjectTabs(), -- text of list items taken from current project tabs
        callback = function (self, selected, txt) Soda.TextWindow{title = txt, textBody = readProjectTab(txt), shadow = true, closeButton = true, style = Soda.style.thickStroke, shapeArgs = {radius = 25}} end --a window for scrolling through large blocks of text
    }
    
    --a segmented button to choose between the above 3 panels:
    
    Soda.Segment{
        parent = panel,
        x = 20, y = -80, w = -20, h = 40,
        text = {"Buttons", "Text Entry", "Examine Source"}, --segment labels...
        panels = { --...and their corresponding panels
        buttonPanel, textEntryPanel, list
        }
    }
    
    --a panel for displaying profiling stats (activated by a switch in the button panel)
    
    local stats = Soda.Window{
        hidden = true,
        x = 0, y = -0.001, w = 200, h = 120,
        title = "Profiler\n\n\n", --will be overridden
      --  shapeArgs = {corners = 8},
        blurred = true, shadow = true,
        update = function(self) --update will be called every frame
            self.title = string.format("Profiler\n\nFPS: %.2f\nMem: %.2f", profiler.fps, profiler.mem)
        end
    }
    
    --the textEntry panel
    
    Soda.TextEntry{ --text entry box
        parent = textEntryPanel,
        x = 10, y = -70, w = -10, h = 40,
        title = "Nick-name:",
        default = "Ice Man",
        callback = function(self, inkey)
            Soda.Alert{
                title = inkey.."?!?\n\nWas that really your nickname?",
               style = Soda.style.darkBlurred, blurred = true,
            }
        end
    }    
    
    Soda.TextEntry{
        parent = textEntryPanel,
        x = 10, y = -130, w = -10, h = 40,
        title = "Name of 1st pet:",
        default = "Percival",
        callback = function(self, inkey)
            Soda.Alert{
              title = inkey.."!\n\u{1f63b}\u{1f436}\u{1f430}\n\nAwwww. Cute name.",
               style = Soda.style.darkBlurred, blurred = true,
            }
        end
    }
    
    Soda.DropdownList{ --a dropdown list button
        parent = textEntryPanel,
        x = 10, y = -10, w = -10, h = 40,    
        title = "County",
        text = {"London", "Bedfordshire", "Buckinghamshire", "Cambridgeshire", "Cheshire", "Cornwall and Isles of Scilly", "Cumbria", "Derbyshire", "Devon", "Dorset", "Durham", "East Sussex", "Essex", "Gloucestershire", "Greater London", "Greater Manchester", "Hampshire", "Hertfordshire", "Kent", "Lancashire", "Leicestershire", "Lincolnshire", "Merseyside", "Norfolk", "North Yorkshire", "Northamptonshire", "Northumberland", "Nottinghamshire", "Oxfordshire", "Shropshire", "Somerset", "South Yorkshire", "Staffordshire", "Suffolk", "Surrey", "Tyne and Wear", "Warwickshire", "West Midlands", "West Sussex", "West Yorkshire", "Wiltshire", "Worcestershire", "Flintshire", "Glamorgan", "Merionethshire", "Monmouthshire", "Montgomeryshire", "Pembrokeshire", "Radnorshire", "Anglesey", "Breconshire", "Caernarvonshire", "Cardiganshire", "Carmarthenshire", "Denbighshire", "Kirkcudbrightshire", "Lanarkshire", "Midlothian", "Moray", "Nairnshire", "Orkney", "Peebleshire", "Perthshire", "Renfrewshire", "Ross & Cromarty", "Roxburghshire", "Selkirkshire", "Shetland", "Stirlingshire", "Sutherland", "West Lothian", "Wigtownshire", "Aberdeenshire", "Angus", "Argyll", "Ayrshire", "Banffshire", "Berwickshire", "Bute", "Caithness", "Clackmannanshire", "Dumfriesshire", "Dumbartonshire", "East Lothian", "Fife", "Inverness", "Kincardineshire", "Kinross-shire"},    
    }
    
    --the button panel:
    
    local div = 1/8
    
    Soda.BackButton{
    parent = buttonPanel,
    x = div, y = -20}
    
    Soda.SettingsButton{
    parent = buttonPanel,
    x = div * 2, y = -20}
    
    Soda.AddButton{
    parent = buttonPanel,
    x = div * 3, y = -20}
    
    Soda.QueryButton{
    parent = buttonPanel,
    x = div * 4, y = -20}
    
    Soda.MenuButton{
    parent = buttonPanel,
    x = div * 5, y = -20}
    
    Soda.DropdownButton{
    parent = buttonPanel,
    x = div * 6, y = -20}
    
    Soda.CloseButton{
    parent = buttonPanel,
    x = div * 7, y = -20
    }
    
    Soda.Switch{ --a switch to toggle the profiler stats panel
        parent = buttonPanel,
        x = 20, y = -80,
        title = "Show profiler",
        callback = function() stats:show(LEFT) end,
        callbackOff = function() stats:hide(LEFT) end
    }
    
    Soda.Switch{
        parent = buttonPanel,
        x = 20, y = -140,
        title = "Wings stay on the plane",
        on = true
    }
    
    Soda.Switch{
        parent = buttonPanel,
        x = 20, y = -200,
        title = "Afterburners",
    }
       
    Soda.Button{
        parent = buttonPanel, 
        title = "OK", 
        x = 20, y = 20, w = 0.4, h = 40,
        callback = function() 
          --  panel:hide(RIGHT) 
         --   menu:unHighlight()
            menu:switchOff()
        end
    }
    
    Soda.Button{
    parent = buttonPanel, 
    title = "Do not press", 
    style = Soda.style.warning, 
    x = -20, y = 20, w = 0.4, h = 40, 
    callback = 
        function()
            Soda.Alert{ --an alert box with a single button
                title = "CONGRATULATIONS!\n\nYou held out "..string.format("%.2f", ElapsedTime).." seconds before\n succumbing to the irresistable\nallure of a big red button saying\n‘do not press’", 
                ok = "Here, have a medal",
                y=0.6, h = 0.3,
        
                style = Soda.style.darkBlurred, blurred = true, 
            }
        end
    }
    
end

function demo2()
     local t = ElapsedTime
    local box = --create a temporary handle "box" so that we can define other buttons as children
    Soda.Window{title = "Settings", w = 0.6, h = 0.6, blurred = true, style = Soda.style.darkBlurred} --
     --320
      --  instruction = Label(instruction, x+20, y+160, 640, 120),
     --   field = TextField(textfield, x+20, y+80, 640.0, 40, default, 1, test_Clicked),
    local menu = Soda.MenuButton{parent = box, x = 20, y= - 20, callback = function ()
        
    end}
      local   ok = Soda.Button{parent = box, title = "OK", x = 20, y = 20, w = 0.3, h = 40}
    
      local  warning = Soda.Button{parent = box, title = "Do not press", style = Soda.style.warning, x = -20, y = 20, w = 0.3, h = 40, callback = 
        function()
            Soda.Alert{title = "CONGRATULATIONS!\n\nYou held out\n"..(ElapsedTime - t).." seconds", y=0.6, style = Soda.style.darkBlurred, blurred = true, alert = true}
        end} --blurred = true, alert = true,
    
    local  choose = Soda.Segment{parent = box, text = {"Several","options", "to choose", "between"}, x=0.5, y=-60, w=0.9, h = 40} --"options", 
    
    local   switch = Soda.Switch{parent = box, title = "Wings fall off", x = 20, y = -120}
    
  local list = Soda.List{parent = box, x = -20, y = -120, w = 0.4, h=0.5, text = {"Washington", "Adams", "Jefferson", "Madison", "Monroe", "Adams", "Jackson", "Van Buren", "Harrison", "Tyler", "Polk", "Taylor", "Fillmore", "Pierce", "Buchanan", "Lincoln", "Johnson", "Grant"} }
    
    local inkey = Soda.TextEntry{parent = box, title = "Nick-name:", x=20, y=80, w=0.7, h=40} 
end


--# Overview
function overview(t)
    local win =Soda.Window{
        title = "Soda v"..Soda.version.." Overview",
        w = 0.97, h = 0.7,
        blurred = true, 
        shadow = true, 
        style = Soda.style.darkBlurred, 
    }
    
    local aboutPanel = Soda.Frame{
        parent = win,
        x = 10, y = 10, w = -10, h = -110, 
        shape = Soda.RoundedRectangle, style = Soda.style.translucent,
        shapeArgs = {radius = 16},
        label = { x = 0.5, y = 0.5},
        title = 
    [[Soda is a library for producing graphic user interfaces like 
    the one you are looking at now.
    
    Press the segment buttons to see some of the things Soda is 
    capable of.
    
    ]]..(t.content or "")
    }
    
    Soda.Button{
        parent = aboutPanel, 
        x = 10, y = 10, h = 40,
        title = "Online Documentation",
        callback = function() openURL("https://github.com/Utsira/Soda/blob/master/README.md", true) end
    }
   
    if t.ok then 
    Soda.Button{
        parent = aboutPanel,
        x = -10, y = 10, h = 40,
      --  shapeArgs = {radius = 16},
          style = Soda.style.warning,
        title = t.ok,
        callback = t.callback
    }
    end
    
    local buttonPanel = Soda.Frame{
        parent = win,
        x = 10, y = 10, w = -10, h = -110,
       -- shape = Soda.RoundedRectangle, style = Soda.style.translucent,
        --shapeArgs = {radius = 16}
    }
           
    local switchPanel = Soda.Frame{
        parent = win,
        x = 10, y = 10, w = -10, h = -110,
      --  shape = Soda.RoundedRectangle, style = Soda.style.translucent,
      --  shapeArgs = {radius = 16}
    }
    
    local sliderPanel = Soda.Frame{
        parent = win,
        title = "Sliders. At slow slide speeds movement becomes more fine-grained",
        x = 10, y = 10, w = -10, h = -110,
        shape = Soda.RoundedRectangle, style = Soda.style.translucent,
        shapeArgs = {radius = 16}
    }
    
    local dialogPanel = Soda.Frame{
        parent = win,
        x = 10, y = 10, w = -10, h = -110,
       -- shape = Soda.RoundedRectangle, style = Soda.style.translucent,
      --  shapeArgs = {radius = 16}
    }
    
    local textEntryPanel = Soda.Frame{
        parent = win,
        title = "Text Entry fields with a draggable cursor",
        x = 10, y = -110, w = -10, h = 0.6,
        shape = Soda.RoundedRectangle, style = Soda.style.translucent,
        shapeArgs = {radius = 16}
    }
    
    local listPanel = Soda.Frame{
        parent = win,
        title = "Vertically scrolling lists are another way of selecting one choice from many",
        x = 10, y = 10, w = -10, h = -110,
        shape = Soda.RoundedRectangle, style = Soda.style.translucent,
        shapeArgs = {radius = 16}
    }
    
    scrollPanel = Soda.TextScroll{
        parent = win,
        title = "Text Scrolls for scrolling through large bodies of text",
    
        textBody = string.rep([[
    
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus vitae massa in sem mattis ullamcorper a eget metus. Nam ac maximus nulla, vel faucibus sapien. Aenean faucibus volutpat tristique. Curabitur condimentum volutpat velit, sit amet commodo tellus placerat a. 
    
    Sed vitae metus quis mauris congue tincidunt vel sit amet lorem. Mauris lectus lorem, facilisis in dapibus et, congue quis nunc. Fusce convallis mi urna, vitae mattis felis sodales et. Aliquam et fringilla purus, eu vehicula diam. Sed facilisis mauris vitae augue sodales aliquam. In ultrices metus ut eleifend condimentum. Praesent venenatis rhoncus felis, eget vehicula orci ornare non. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Vivamus eget vulputate mauris. Pellentesque id tempus sapien.
    ]], 100),
        x = 10, y = 10, w = -10, h = -110,
        shape = Soda.RoundedRectangle, style = Soda.style.default,
        shapeArgs = {radius = 16}    
    }
    
    Soda.Segment{
        parent = win,
        x = 12, y = -60, w = -12, h = 40,
        text = {"About", "Buttons", "Switches", "Sliders", "Dialogs", "Text Entry", "Lists", "Scrolls"}, 
        panels = {aboutPanel, buttonPanel, switchPanel, sliderPanel, dialogPanel, textEntryPanel, listPanel, scrollPanel}, 
    }
    
    --button panel!
    
    local buttonPresets = Soda.Frame{
        parent = buttonPanel,
        title = "Presets for frequently-used buttons",
        x = 0, y = 0.5, w = 1, h = 0.32,
          shape = Soda.RoundedRectangle, style = Soda.style.translucent,
          shapeArgs = {radius = 16}
    }
    
    local div = 1/8
    local div2 = div/2
    
    Soda.BackButton{
    parent = buttonPresets,
    x = div2, y = 0.4}
    
    Soda.ForwardButton{
    parent = buttonPresets,
    x = div2 + div, y = 0.4}
    
    Soda.SettingsButton{
    parent = buttonPresets,
    x = div2 + div * 2, y = 0.4}
    
    Soda.AddButton{
    parent = buttonPresets,
    x = div2 + div * 3, y = 0.4}
    
    Soda.QueryButton{
    parent = buttonPresets,
    x = div2 + div * 4, y = 0.4}
    
    Soda.MenuButton{
    parent = buttonPresets,
    x = div2 + div * 5, y = 0.4}
    
    Soda.DropdownButton{
    parent = buttonPresets,
    x = div2 + div * 6, y = 0.4}
    
    Soda.CloseButton{
    parent = buttonPresets,
    x = div2 + div * 7, y = 0.4
    }
    
    local textButtons = Soda.Frame{
        parent = buttonPanel,
        title = "Text and symbol based buttons in various shapes and styles",
        x = 0, y = -0.001, w = 1, h = 0.32,
        shape = Soda.RoundedRectangle, style = Soda.style.translucent,
        shapeArgs = {radius = 16}
    }
    
    div = 1/6
    div2 = div/2
    local w = div -0.01
    
    Soda.Button{
        parent = textButtons, 
        title = "Standard", 
        x = div2, y = 0.4, w = w, h = 40,
    }
    
    Soda.Button{
        parent = textButtons, 
        title = "Dark", 
        style = Soda.style.dark,
        x = div2 + div, y = 0.4, w = w, h = 40,
    }
    
    Soda.Button{
        parent = textButtons, 
        title = "Warning", 
        style = Soda.style.warning, 
        x = div2 + div * 2, y = 0.4, w = w, h = 40, 
    }
    
    Soda.Button{
        parent = textButtons, 
        title = "Square", 
        shape = Soda.rect,
        x = div2 + div * 3, y = 0.4, w = w, h = 40,
    }
    
    Soda.Button{
        parent = textButtons, 
        title = "Lozenge", 
        shapeArgs = {radius = 20},
        x = div2 + div * 4, y = 0.4, w = w, h = 40,
    }
    
    local div3 = div/5
    local base = div2 + div * 5
    
    Soda.Button{
        parent = textButtons, 
        title = "\u{1f310}", 
        style = Soda.style.darkIcon,
        shape = Soda.ellipse,
        x = base - div3, y = 0.4, w = 40, h = 40,
    }
    
    --[[
    Soda.Button{
        parent = textButtons, 
        title = "\u{267b}", 
     --   shape = Soda.ellipse,
     --   style = Soda.style.icon,
        x = base, y = 0.4, w = 40, h = 40,
    }
      ]]
    
    Soda.Button{
        parent = textButtons, 
        title = "\u{1f374}", 
      --  shape = Soda.ellipse,
        style = Soda.style.darkIcon,
        x = base + div3, y = 0.4, w = 40, h = 40,
    }
    
    local segmentPanel = Soda.Frame{
        parent = buttonPanel,
        title = "Segmented buttons for selecting one option from many",
        x = 0, y = 0, w = 1, h = 0.32,
        shape = Soda.RoundedRectangle, style = Soda.style.translucent,
        shapeArgs = {radius = 16}
    }
    
    Soda.Segment{
        parent = segmentPanel, 
        x = 20, y = 0.4, w = -20, h = 40,
        text = {"Only one", "segmented", "button can", "be selected", "at a time"}
    }
    
    --switch panel
    
    local switches = Soda.Frame{
        parent = switchPanel,
        title = "iOS-style switches",
        x = 0, y = -10, w = 0.49, h = 0.75,
        shape = Soda.RoundedRectangle, style = Soda.style.translucent,
        shapeArgs = {radius = 16}
    }
    
    Soda.Switch{ --a switch to toggle the profiler stats panel
        parent = switches,
        x = 20, y = 0.75,
        title = "Use switches to toggle",

    }
    
    Soda.Switch{
        parent = switches,
        x = 20, y = 0.5,
        title = "...between two states",
        on = true
    }
    
    Soda.Switch{
        parent = switches,
        x = 20, y = 0.25,
        title = "...on and off",
    }
    
    local toggles = Soda.Frame{
        parent = switchPanel,
        title = "Text and preset-based toggles",
        x = -0.001, y = -10, w = 0.49, h = 0.75,
        shape = Soda.RoundedRectangle, style = Soda.style.translucent,
        shapeArgs = {radius = 16}
    }
    
    Soda.Toggle{
        parent = toggles,
        x = 20, y = 0.8, w = -20, h = 40,
        title = "Standard" 
    }
    
    Soda.Toggle{
        parent = toggles,
        x = 20, y = 0.6, w = -20, h = 40,
        shape = Soda.rect,
        title = "Square" 
    }
    
    Soda.Toggle{
        parent = toggles,
        x = 20, y = 0.4, w = -20, h = 40,
        shapeArgs = {radius = 20},
        title = "Over-rounded" 
    }
    
    Soda.MenuToggle{
        parent = toggles,
        x = 20, y = 0.2,
        on = true,
    }
    
    --[[
    local sliders = Soda.Frame{
        parent = switchPanel,
        title = "Sliders",
        x = 0.5, y = 0, w = 0.49, h = 0.32,
        shape = Soda.RoundedRectangle, style = Soda.style.translucent,
        shapeArgs = {radius = 16}
    }
      ]]
    
    --slider panel 
    
    Soda.Slider{
        parent = sliderPanel,
        title = "Integer slider",
        x = 0.5, y = 0.8, w = 300,
        min = 1000, max = 2000, start = 1500,
    }
    
    Soda.Slider{
        parent = sliderPanel,
        title = "Floating point slider (3 decimal places)",
        x = 0.5, y = 0.6, w = 400,
        min = -10, max = 10, start = 0,
        decimalPlaces = 3
    }
    
    Soda.Slider{
        parent = sliderPanel,
        title = "Slider with snap points",
        x = 0.5, y = 0.4, w = 500,
        min = -50, max = 150,
        decimalPlaces = 1,
        snapPoints = {0, 100}
    }
    
    Soda.Slider{
        parent = sliderPanel,
        title = "Make fine +/- adjustments by tapping either side of the lever",
        x = 0.5, y = 0.2, w = 0.9,
        min = -10000, max = 10000, start = 0,
        snapPoints = {0}
    }
    
    --dialog panel!
    
    local regularAlert = Soda.Frame{
        parent = dialogPanel,
        title = "Press the buttons to trigger alerts in the default style",
        x = 0, y = 0.85, w = 1, h = 0.3,
        shape = Soda.RoundedRectangle, style = Soda.style.translucent,
        shapeArgs = {radius = 16}
    }
    
    Soda.Button{
        parent = regularAlert, 
        title = "Proceed dialog", 
        x = 10, y = 0.4, w = 0.4, h = 40,
        callback = function() 
            Soda.Alert2{
                title = "A 2-button\nProceed or cancel dialog",
            }
        end
    }
    
    Soda.Button{
    parent = regularAlert, 
    title = "Alert", 
    style = Soda.style.warning, 
    x = -10, y = 0.4, w = 0.4, h = 40, 
    callback = 
        function()
            Soda.Alert{ --an alert box with a single button
                title = "A one-button\nalert", 
                y=0.6, h = 0.3,
            }
        end
    }
    
    local blurAlert = Soda.Frame{
        parent = dialogPanel,
        title = "Press the buttons to trigger alerts with dark, blurred panels",
        x = 0, y = 0.53, w = 1, h = 0.3,
        shape = Soda.RoundedRectangle, style = Soda.style.translucent,
        shapeArgs = {radius = 16}
    }
    
    Soda.Button{
        parent = blurAlert, 
        title = "Proceed dialog (blurred)", 
        x = 10, y = 0.4, w = 0.4, h = 40,
        callback = function() 
            Soda.Alert2{
                title = "A 2-button\nProceed or cancel dialog",
                style = Soda.style.darkBlurred, blurred = true, 
            }
        end
    }
    
    Soda.Button{
    parent = blurAlert, 
    title = "Alert (blurred)", 
    style = Soda.style.warning, 
    x = -10, y = 0.4, w = 0.4, h = 40, 
    callback = 
        function()
            Soda.Alert{ --an alert box with a single button
                title = "A one-button\nalert", 
                y=0.6, h = 0.3,
                style = Soda.style.darkBlurred, blurred = true, 
            }
        end
    }
    
    --text entry panel
    
    Soda.TextEntry{ --text entry box
        parent = textEntryPanel,
        x = 10, y = -50, w = -10, h = 40,
        title = "Text Entry:",
       -- default = "Some place-holder text the user overwrites",
    }    
    
    Soda.TextEntry{
        parent = textEntryPanel,
        x = 10, y = 0.45, w = -10, h = 40,
        title = "Text Entry:",
        default = "Some place-holder text the user overwrites"
    }
    
    Soda.TextEntry{
        parent = textEntryPanel,
        x = 10, y = 10, w = -10, h = 40,
        title = "Text Entry:",
        default = "Interface scrolls up if text entry is below the height of the keyboard"
    }
    
    --list panel
    
    Soda.List{
        parent = listPanel,
        x = 10, y = 10, h = -50, w = 0.45,
        text = {"Lists", "allow", "the", "user", "to", "select", "one", "option", "from", "a", "vertically", "scrolling", "list."}
    }
    
    Soda.DropdownList{
        parent = listPanel,
        x = -10, y = -110, w = 0.45, h = 40,
        title = "A numbered list",
        enumerate = true,
        text = {"Lists", "and", "dropdown lists", "can", "be", "automatically", "enumerated", "if", "you", "wish"}
    }
      
    Soda.DropdownList{
        parent = listPanel,
        x = -10, y = -50, w = 0.45, h = 40,
        title = "A dropdown list",
        text = {"Dropdown", "lists", "are", "lists", "that", "dropdown", "from", "a", "button.", "Note", "that", "the", "button", "reports", "the", "selection", "made"}
    }
end

--[==[
function splashScreen()
    local win =Soda.Window{
        title = "Soda Overview",
        w = 0.98, h = 0.7,
        blurred = true, 
        shadow = true, 
        style = Soda.style.darkBlurred, 
    }
    
    local aboutPanel = Soda.Frame{
        parent = win,
        x = 150, y = 10, w = -10, h = -50, 
        shape = Soda.RoundedRectangle, style = Soda.style.translucent,
        shapeArgs = {radius = 16},
        label = { x = 0.5, y = 0.5, text = 
    [[Soda is a library for producing graphic user interfaces like 
    the one you are looking at now.
    
    Press the segment buttons to see some of the things Soda is 
    capable of.
    
    This is a tutorial that introduces the basic features of Soda.
    
    This tutorial will gradually build an interface like this one, 
    adding elements one at a time. You will be able to navigate the 
    tutorial, and browse the extensively commented source code 
    for each step in the window in the bottom half of the screen.
    
    When you're ready, press "Begin Tutorial".
    ]]}
    }
    
    Soda.Button{
        parent = aboutPanel, 
        x = 10, y = 10, h = 40,
        title = "Online Documentation",
        callback = function() openURL("https://github.com/Utsira/Soda/blob/master/README.md", true) end
    }
    
    Soda.Button{
        parent = aboutPanel,
        x = -10, y = 10, h = 40,
      --  shapeArgs = {radius = 16},
          style = Soda.style.warning,
        title = "Begin Tutorial"
    }
    
    local buttonPanel = Soda.Frame{
        parent = win,
        x = 150, y = 10, w = -10, h = -50, 
       -- shape = Soda.RoundedRectangle, style = Soda.style.translucent,
        --shapeArgs = {radius = 16}
    }
           
    local switchPanel = Soda.Frame{
        parent = win,
        x = 150, y = 10, w = -10, h = -50, 
      --  shape = Soda.RoundedRectangle, style = Soda.style.translucent,
      --  shapeArgs = {radius = 16}
    }
    
    local dialogPanel = Soda.Frame{
        parent = win,
        x = 150, y = 10, w = -10, h = -50, 
       -- shape = Soda.RoundedRectangle, style = Soda.style.translucent,
      --  shapeArgs = {radius = 16}
    }
    
    local textEntryPanel = Soda.Frame{
        parent = win,
        title = "Text Entry fields with a draggable cursor",
        x = 150, y = 10, w = -10, h = -50, 
        shape = Soda.RoundedRectangle, style = Soda.style.translucent,
        shapeArgs = {radius = 16}
    }
    
    local listPanel = Soda.Frame{
        parent = win,
        title = "Vertically scrolling lists are another way of selecting one choice from many",
        x = 150, y = 10, w = -10, h = -50, 
        shape = Soda.RoundedRectangle, style = Soda.style.translucent,
        shapeArgs = {radius = 16}
    }
    
    local scrollPanel = Soda.TextScroll{
        parent = win,
        title = "Text Scrolls for scrolling through large bodies of text",
        textBody = string.rep([[
    
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus vitae massa in sem mattis ullamcorper a eget metus. Nam ac maximus nulla, vel faucibus sapien. Aenean faucibus volutpat tristique. Curabitur condimentum volutpat velit, sit amet commodo tellus placerat a. 
    
    Sed vitae metus quis mauris congue tincidunt vel sit amet lorem. Mauris lectus lorem, facilisis in dapibus et, congue quis nunc. Fusce convallis mi urna, vitae mattis felis sodales et. Aliquam et fringilla purus, eu vehicula diam. Sed facilisis mauris vitae augue sodales aliquam. In ultrices metus ut eleifend condimentum. Praesent venenatis rhoncus felis, eget vehicula orci ornare non. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Vivamus eget vulputate mauris. Pellentesque id tempus sapien.
    ]], 100),
        x = 150, y = 10, w = -10, h = -50, 
        shape = Soda.RoundedRectangle, style = Soda.style.translucent,
        shapeArgs = {radius = 16}    
    }
    
    --[[
    Soda.Segment{
        parent = win,
        x = 12, y = -60, w = -12, h = 40,
        text = {"About", "Buttons", "Switches", "Dialogs", "Text Entry", "Lists", "Text Scrolls"}, 
        panels = {aboutPanel, buttonPanel, switchPanel, dialogPanel, textEntryPanel, listPanel, scrollPanel}, 
    }
      ]]
    Soda.List{
        parent = win,
        x = 10, y = 10, w = 130, h = -50,
        shapeArgs = {radius = 16},--, corners = 1 | 2
        text = {"About", "Buttons", "Switches", "Dialogs", "Text Entry", "Lists", "Text Scrolls"}, 
        panels = {aboutPanel, buttonPanel, switchPanel, dialogPanel, textEntryPanel, listPanel, scrollPanel},
        defaultNo = 1
    }
    
    --button panel!
    
    local buttonPresets = Soda.Frame{
        parent = buttonPanel,
        title = "Presets for frequently-used buttons",
        x = 0, y = 0.5, w = 1, h = 0.32,
          shape = Soda.RoundedRectangle, style = Soda.style.translucent,
          shapeArgs = {radius = 16}
    }
    
    local div = 1/8
    local div2 = div/2
    
    Soda.BackButton{
    parent = buttonPresets,
    x = div2, y = 0.4}
    
    Soda.ForwardButton{
    parent = buttonPresets,
    x = div2 + div, y = 0.4}
    
    Soda.SettingsButton{
    parent = buttonPresets,
    x = div2 + div * 2, y = 0.4}
    
    Soda.AddButton{
    parent = buttonPresets,
    x = div2 + div * 3, y = 0.4}
    
    Soda.QueryButton{
    parent = buttonPresets,
    x = div2 + div * 4, y = 0.4}
    
    Soda.MenuButton{
    parent = buttonPresets,
    x = div2 + div * 5, y = 0.4}
    
    Soda.DropdownButton{
    parent = buttonPresets,
    x = div2 + div * 6, y = 0.4}
    
    Soda.CloseButton{
    parent = buttonPresets,
    x = div2 + div * 7, y = 0.4
    }
    
    local textButtons = Soda.Frame{
        parent = buttonPanel,
        title = "Text based buttons",
        x = 0, y = -0.001, w = 1, h = 0.32,
        shape = Soda.RoundedRectangle, style = Soda.style.translucent,
        shapeArgs = {radius = 16}
    }
    
    div = 1/6
    div2 = div/2
    local w = div -0.01
    
    Soda.Button{
        parent = textButtons, 
        title = "Standard", 
        x = div2, y = 0.4, w = w, h = 40,
    }
    
    Soda.Button{
        parent = textButtons, 
        title = "Dark", 
        style = Soda.style.dark,
        x = div2 + div, y = 0.4, w = w, h = 40,
    }
    
    Soda.Button{
        parent = textButtons, 
        title = "Warning", 
        style = Soda.style.warning, 
        x = div2 + div * 2, y = 0.4, w = w, h = 40, 
    }
    
    Soda.Button{
        parent = textButtons, 
        title = "Square", 
        shape = Soda.rect,
        x = div2 + div * 3, y = 0.4, w = w, h = 40,
    }
    
    Soda.Button{
        parent = textButtons, 
        title = "Lozenge", 
        shapeArgs = {radius = 20},
        x = div2 + div * 4, y = 0.4, w = w, h = 40,
    }
    
    local div3 = div/5
    local base = div2 + div * 5
    
    Soda.Button{
        parent = textButtons, 
        title = "\u{1f310}", 
        style = Soda.style.darkIcon,
        shape = Soda.ellipse,
        x = base - div3, y = 0.4, w = 40, h = 40,
    }
    
    --[[
    Soda.Button{
        parent = textButtons, 
        title = "\u{267b}", 
     --   shape = Soda.ellipse,
     --   style = Soda.style.icon,
        x = base, y = 0.4, w = 40, h = 40,
    }
      ]]
    
    Soda.Button{
        parent = textButtons, 
        title = "\u{1f374}", 
      --  shape = Soda.ellipse,
        style = Soda.style.darkIcon,
        x = base + div3, y = 0.4, w = 40, h = 40,
    }
    
    local segmentPanel = Soda.Frame{
        parent = buttonPanel,
        title = "Segmented buttons for selecting one option from many",
        x = 0, y = 0, w = 1, h = 0.32,
        shape = Soda.RoundedRectangle, style = Soda.style.translucent,
        shapeArgs = {radius = 16}
    }
    
    Soda.Segment{
        parent = segmentPanel, 
        x = 20, y = 0.4, w = -20, h = 40,
        text = {"Only one", "segmented", "button can", "be selected", "at a time"}
    }
    
    --switch panel
    
    local switches = Soda.Frame{
        parent = switchPanel,
        title = "iOS-style switches",
        x = 0, y = -10, w = 0.49, h = 0.7,
        shape = Soda.RoundedRectangle, style = Soda.style.translucent,
        shapeArgs = {radius = 16}
    }
    
    Soda.Switch{ --a switch to toggle the profiler stats panel
        parent = switches,
        x = 20, y = 0.75,
        title = "Use switches to toggle",

    }
    
    Soda.Switch{
        parent = switches,
        x = 20, y = 0.5,
        title = "...between two states",
        on = true
    }
    
    Soda.Switch{
        parent = switches,
        x = 20, y = 0.25,
        title = "...on and off",
    }
    
    local toggles = Soda.Frame{
        parent = switchPanel,
        title = "Text and preset-based toggles",
        x = -0.001, y = -10, w = 0.49, h = 0.7,
        shape = Soda.RoundedRectangle, style = Soda.style.translucent,
        shapeArgs = {radius = 16}
    }
    
    Soda.Toggle{
        parent = toggles,
        x = 20, y = 0.8, w = -20, h = 40,
        title = "Standard" 
    }
    
    Soda.Toggle{
        parent = toggles,
        x = 20, y = 0.6, w = -20, h = 40,
        shape = Soda.rect,
        title = "Square" 
    }
    
    Soda.Toggle{
        parent = toggles,
        x = 20, y = 0.4, w = -20, h = 40,
        shapeArgs = {radius = 20},
        title = "Over-rounded" 
    }
    
    Soda.MenuToggle{
        parent = toggles,
        x = 20, y = 0.2,
        on = true,
    }
    
    --dialog panel!
    local regularAlert = Soda.Frame{
        parent = dialogPanel,
        title = "Press the buttons to trigger alerts in the default style",
        x = 0, y = 0.85, w = 1, h = 0.3,
        shape = Soda.RoundedRectangle, style = Soda.style.translucent,
        shapeArgs = {radius = 16}
    }
    
    Soda.Button{
        parent = regularAlert, 
        title = "Proceed dialog", 
        x = 10, y = 0.4, w = 0.4, h = 40,
        callback = function() 
            Soda.Alert2{
                title = "A 2-button\nProceed or cancel dialog",
            }
        end
    }
    
    Soda.Button{
    parent = regularAlert, 
    title = "Alert", 
    style = Soda.style.warning, 
    x = -10, y = 0.4, w = 0.4, h = 40, 
    callback = 
        function()
            Soda.Alert{ --an alert box with a single button
                title = "A one-button\nalert", 
                y=0.6, h = 0.3,
            }
        end
    }
    
    local blurAlert = Soda.Frame{
        parent = dialogPanel,
        title = "Press the buttons to trigger alerts with dark, blurred panels",
        x = 0, y = 0.53, w = 1, h = 0.3,
        shape = Soda.RoundedRectangle, style = Soda.style.translucent,
        shapeArgs = {radius = 16}
    }
    
    Soda.Button{
        parent = blurAlert, 
        title = "Proceed dialog (blurred)", 
        x = 10, y = 0.4, w = 0.4, h = 40,
        callback = function() 
            Soda.Alert2{
                title = "A 2-button\nProceed or cancel dialog",
                style = Soda.style.darkBlurred, blurred = true, 
            }
        end
    }
    
    Soda.Button{
    parent = blurAlert, 
    title = "Alert (blurred)", 
    style = Soda.style.warning, 
    x = -10, y = 0.4, w = 0.4, h = 40, 
    callback = 
        function()
            Soda.Alert{ --an alert box with a single button
                title = "A one-button\nalert", 
                y=0.6, h = 0.3,
                style = Soda.style.darkBlurred, blurred = true, 
            }
        end
    }
    
    --text entry panel
    Soda.TextEntry{ --text entry box
        parent = textEntryPanel,
        x = 10, y = -50, w = -10, h = 40,
        title = "Text Entry:",
       -- default = "Some place-holder text the user overwrites",
    }    
    
    Soda.TextEntry{
        parent = textEntryPanel,
        x = 10, y = 0.45, w = -10, h = 40,
        title = "Text Entry:",
        default = "Some place-holder text the user overwrites"
    }
    
    Soda.TextEntry{
        parent = textEntryPanel,
        x = 10, y = 10, w = -10, h = 40,
        title = "Text Entry:",
        default = "Interface scrolls up if text entry is below the height of the keyboard"
    }
    
    --list panel
    
    Soda.List{
        parent = listPanel,
        x = 10, y = 10, h = -50, w = 0.45,
        text = {"Lists", "allow", "the", "user", "to", "select", "one", "option", "from", "a", "vertically", "scrolling", "list."}
    }
    
    Soda.DropdownList{
        parent = listPanel,
        x = -10, y = -110, w = 0.45, h = 40,
        title = "A numbered list",
        enumerate = true,
        text = {"Lists", "and", "dropdown lists", "can", "be", "automatically", "enumerated", "if", "you", "wish"}
    }
      
    Soda.DropdownList{
        parent = listPanel,
        x = -10, y = -50, w = 0.45, h = 40,
        title = "A dropdown list",
        text = {"Dropdown", "lists", "are", "lists", "that", "dropdown", "from", "a", "button.", "Note", "that", "the", "button", "reports", "the", "selection", "made"}
    }
end
  ]==]

--# Soda
Soda = {}
Soda.version = "0.5"

function Soda.setup()
    --  parameter.watch("#Soda.items")
    parameter.watch("Soda.UIoffset")
    Soda.Assets()
    Soda.theme = Soda.themes.default
    textAlign(CENTER)
    rectMode(CENTER)

end

function Soda.Assets()
    Soda.items = {} --holds all top-level ui elements (i.e. anything without a parent)
    
    Soda.darken.assets() --used to darken underlying interface elements when alert flag is set.
    
    Soda.UIoffset = 0 --used to scroll up screen when keyboard appears
end

Soda.darken = {}

function Soda.darken.assets()
    Soda.darken.m = mesh()
    local s = math.max(WIDTH, HEIGHT)
    Soda.darken.m:addRect(s/2, s/2, s, s)
    Soda.darken.m:setColors(color(0,128))
end

function Soda.darken.draw()
    pushMatrix()
    resetMatrix()
    Soda.darken.m:draw()
    popMatrix()
end

function Soda.camera()
    if not isKeyboardShowing() then
        Soda.UIoffset = Soda.UIoffset * 0.9

    end
    translate(0, Soda.UIoffset)
end

function Soda.draw(breakPoint)
    Soda.setStyle(Soda.style.default.text)
    for i,v in ipairs(Soda.items) do --draw most recent item last
        if v.kill then
            table.remove(Soda.items, i)
        else
            if v:draw(breakPoint) then return end
        end
    end
end

function Soda.touched(t)
    local tpos = vec2(t.x, t.y-Soda.UIoffset)
    for i = #Soda.items, 1, -1 do --test most recent item first
        local v = Soda.items[i] 
        if v:touched(t, tpos) then return end
    end
end

function Soda.keyboard(key)
    if Soda.keyboardEntity then
        Soda.keyboardEntity:keyboard(key)
    end
end

function Soda.orientationChanged()
    for i,v in ipairs(Soda.items) do
        v:orientationChanged()
    end
    collectgarbage()
end

--assume everything is rectMode centre (cos of mesh rect)
function Soda.parseCoord(v, len, edge)
    local half = len * 0.5
    if v==0 or v>1 then return v + half end --standard coordinate
    if v<0 then return edge - half + v end --eg WIDTH - 40
    return edge * v  --proportional
end

function Soda.parseCoordSize(loc, size, edge)
    local pos, len
    if size>1 then
        len = size --standard length coord
    elseif size>0 then
        len = math.ceil(edge * size) --proportional length
    end --nb defer if size is negative
    if len then
        local half = len * 0.5
        if loc%1==0 and loc>=0 then
            pos = loc + half --standard coord
        elseif loc<0 then
            pos = edge - half + loc --negative coord
        else
            pos = math.ceil(edge * loc) --proportional coord
        end
    else --negative size
        if loc%1==0 and loc>=0 then 
            len = edge - loc + size --loc and size describing the two edges
            pos = loc + len * 0.5
        elseif loc>0 then  --proportional loc coord
            local x2 = edge + size
            local x1 = math.ceil(edge * loc)
            len = x2 - x1
            pos = x1 + len * 0.5
          --  pos = edge * loc 
            
            --len = (x2 - pos) * 2
        else --both negative
            local x2 = edge + size
            local x1 = edge + loc
            len = x2 - x1
            pos = x1 + len * 0.5
        end
    end
    return pos, len
end

function null() end

function smoothstep(t,a,b)
    local a,b = a or 0,b or 1
    local t = math.min(1,math.max(0,(t-a)/(b-a)))
    return t * t * (3 - 2 * t)
end

function clamp(v,low,high)
    return math.min(math.max(v, low), high)
end

function lerp(v,a,b)
    return a * (1 - v) + b * v
end

function round(number, places) --use -ve places to round to tens, hundreds etc
    local mult = 10^(places or 0)
    return math.floor(number * mult + 0.5) / mult
end

--# Main
-- Soda

displayMode(OVERLAY)
displayMode(FULLSCREEN)
-- Use this as a template for your projects that have Soda as a dependency. 

function setup()
    profiler.init()
    parameter.watch("#Soda.items")
    Soda.setup()
   -- demo1() --do your setting up here
    overview{}
end

function draw()
    --do your updating here
    pushMatrix()
    Soda.camera()
    Soda.drawing()
    popMatrix()
    profiler.draw()
end

function Soda.drawing(breakPoint) 
    --in order for gaussian blur to work, do all your drawing here
    background(40, 40, 50)
    sprite("Cargo Bot:Game Area", WIDTH*0.5, HEIGHT*0.5, WIDTH, HEIGHT)
    Soda.draw(breakPoint)
end

--user inputs:

function touched(touch)
    Soda.touched(touch)
end

function keyboard(key)
    Soda.keyboard(key)
end

function orientationChanged(ori)
    Soda.orientationChanged(ori)
end

--measure performance:

profiler={}

function profiler.init(quiet)    
    profiler.del=0
    profiler.c=0
    profiler.fps=0
    profiler.mem=0
    if not quiet then
        parameter.watch("profiler.fps")
        parameter.watch("profiler.mem")
    end
end

function profiler.draw()
    profiler.del = profiler.del +  DeltaTime
    profiler.c = profiler.c + 1
    if profiler.c==10 then
        profiler.fps=profiler.c/profiler.del
        profiler.del=0
        profiler.c=0
        profiler.mem=collectgarbage("count", 2)
    end
end


--# Style
Soda.themes = {
default = { 
fill = color(255, 200)  ,stroke = color(152, 200)  ,stroke2 = color(69, 200)  , text = color(0, 97, 255)  ,
text2 = color(0)  ,warning = color(220, 0, 0)  ,darkFill = color(40, 40)  ,darkStroke = color(70, 128)  , 
darkStroke2 = color(20,20)  ,darkText = color(195, 223, 255)  }
}

Soda.style = {
    default = {
        shape = {fill = "fill",
            stroke = "stroke",
            strokeWidth = 2},
        text = {
            fill = "text",
            font = "HelveticaNeue-Light",
            fontSize = 20},
        highlight = {
            text = { fill = "fill"},
            shape = {fill = "text",},
        }
    },
    thickStroke = {shape = { strokeWidth = 10}, text = {}},
    borderless = {
        shape = {strokeWidth = 0},
        text = {fill = "fill"}},
        highlight = {shape = {}, text = {}},
    transparent = {
        shape = {noFill = true, --color(0,0),
                stroke = "darkStroke"}, --stroke = "stroke2"
        text = {fill = "fill"}, --fill = "darkText"
        highlight = { 
        shape = {fill = "darkText"},
        text = {} --fill = "stroke2"
        }
    },
    translucent = {
        shape = {fill = "darkFill", --color(255, 40),
                stroke = "stroke2"},
        text = {fill = "fill"}, -- fill = "darkText"
        highlight = { 
        shape = {},--fill = "darkText"
        text = {}--fill = "stroke2"
        }
    },
    
    warning = {
        shape = {fill = "warning",
            stroke = "stroke2",
            },
        text = {
            fill = "fill"},
        highlight = {
            shape = {fill = "fill"},
            text = { fill = "warning"}}
    },

    switch = {
        shape = {stroke = "stroke"},
        text = {fill = "fill"},
        highlight = {
             text = {fill = "fill"},
             shape = {fill = "text"}
            }
    },
    darkBlurred = {
        shape = { stroke = "darkStroke",
                fill = color(210), --this darkens the blurred section showing through
                strokeWidth = 1},
        text = { fill = "fill"},
        highlight = {
            shape = {fill = "darkText"},
            text = {fill = "stroke2"}
        }
    },
    dark = {
        shape = { stroke = "darkStroke",
                fill = "darkFill",
                strokeWidth = 1},
        text = { fill = "darkText"},
        highlight = {
            shape = {fill = "darkText"},
            text = {fill = "stroke2"}
        }
    },
    shadow = {shape = { fill = color(0, 90), stroke = color(0, 90)}}, --a special style used to produce shadows 20, 100
    textEntry = {fill = color(0), font = "Inconsolata", fontSize = 24}, --a special style for user input in text entry fields. Must be a fixed-width (monotype) font
    textBox = {font = "Inconsolata", fontSize = 16}, --fill = color(29, 61, 31, 255), 
    darkIcon = {
        shape = {noFill = true, strokeWidth = 1, stroke = "fill"}, 
        text = {fontSize = 26, 
            --font = "HelveticaNeue-Bold", 
            fill = "fill"},
        highlight = {
            shape = {fill = "text", stroke = "text"},
            text = {fill = "fill", fontSize = 26, 
                --font = "HelveticaNeue-Bold"
            }
        }
        },
    icon = {
        shape = {noFill = true, noStroke = true}, 
        text = {fontSize = 26, 
            --font = "HelveticaNeue-Bold", 
            fill = "text"},
        highlight = {
            shape = {fill = "text", noStroke = true},
            text = {fill = "fill", fontSize = 26, 
                --font = "HelveticaNeue-Bold"
            }
        }
    },
}

function Soda.setStyle(sty)
    for k,v in pairs(sty) do
        if type(v)=="string" and Soda.theme[v] then
            Soda[k](Soda.theme[v])
        else
            Soda[k](v)
        end
    end
end

function Soda.fill(v)
    fill(v)
end

function Soda.stroke(v)
    stroke(v)
end

function Soda.font(v)
    font(v)
end

function Soda.fontSize(v)
    fontSize(v)
end

function Soda.textWrap()
    
end

function Soda.strokeWidth(v)
    strokeWidth(v)
end

function Soda.noFill()
    noFill()
end

function Soda.noStroke()
    noStroke()
end

function Soda.rect(t)
  --  rect(0, 0, self.w or self.parent.w, self.h or self.parent.h)
    rect(t.x, t.y, t.w, t.h)
end

function Soda.line(t)
    local hw, hh = t.w * 0.5, t.h * 0.5
    line(t.x - hw, t.y - hh, t.x + hw, t.y + hh)
end

function Soda.ellipse(t)
    ellipse(t.x, t.y, t.w)
 --   ellipse(0, 0, self.w or self.parent.w)
end

--Soda.setup()

--[[
LEFTEDGE, TOPEDGE, RIGHTEDGE, BOTTOMEDGE = 1,2,4,8
function Soda:outline(t) --edge 1=left, 2 = top, 4 = right, 8 = bottom
  --  background(fill())
    local edge = t.edge or 15
    local s = strokeWidth() --* 0.5
    local w, h = (self.w - s) * 0.5, (self.h - s) * 0.5
    local x,y,u,v = -w, -h, w, h
    local p = {vec2(x,y), vec2(x,v), vec2(u,v), vec2(u,y)}
    for i = 0,3 do
        local f = 2^i
        if edge & f == f then
            local a,b = p[i+1], p[((i+1)%4)+1]
            line(a.x,a.y,b.x,b.y)
        end
    end
end
  ]]


--# RoundRect
local __RRects = {}
--[[
true mesh rounded rectangle. Original by @LoopSpace
with anti-aliasing, optional fill and stroke components, optional texture that preserves aspect ratio of original image, automatic mesh caching
usage: RoundedRectangle{key = arg, key2 = arg2}
required: x;y;w;h:  dimensions of the rectangle
optional: radius:   corner rounding radius, defaults to 6; 
          corners:  bitwise flag indicating which corners to round, defaults to 15 (all corners). 
                    Corners are numbered 1,2,4,8 starting in lower-left corner proceeding clockwise
                    eg to round the two bottom corners use: 1 | 8
                    to round all the corners except the top-left use: ~ 2
          tex:      texture image
            scale:  size of rect (using scale)
use standard fill(), stroke(), strokeWidth() to set body fill color, outline stroke color and stroke width
  ]]
function Soda.RoundedRectangle(t) 
    local s = t.radius or 8
    local c = t.corners or 15
    local w = math.max(t.w+1,2*s)
    local h = math.max(t.h,2*s)
    local hasTexture = 0
    if t.tex then hasTexture = 1 end
    local label = table.concat({w,h,s,c,hasTexture},",")
    
    if not __RRects[label] then
        local rr = mesh()
        rr.shader = shader(rrectshad.vert, rrectshad.frag)

        local v = {}
        local no = {}

        local n = math.max(3, s//2)
        local o,dx,dy
        local edge, cent = vec3(0,0,1), vec3(0,0,0)
        for j = 1,4 do
            dx = 1 - 2*(((j+1)//2)%2)
            dy = -1 + 2*((j//2)%2)
            o = vec2(dx * (w * 0.5 - s), dy * (h * 0.5 - s))
            --  if math.floor(c/2^(j-1))%2 == 0 then
            local bit = 2^(j-1)
            if c & bit == bit then
                for i = 1,n do
                    
                    v[#v+1] = o
                    v[#v+1] = o + vec2(dx * s * math.cos((i-1) * math.pi/(2*n)), dy * s * math.sin((i-1) * math.pi/(2*n)))
                    v[#v+1] = o + vec2(dx * s * math.cos(i * math.pi/(2*n)), dy * s * math.sin(i * math.pi/(2*n)))
                    no[#no+1] = cent
                    no[#no+1] = edge
                    no[#no+1] = edge
                end
            else
                v[#v+1] = o
                v[#v+1] = o + vec2(dx * s,0)
                v[#v+1] = o + vec2(dx * s,dy * s)
                v[#v+1] = o
                v[#v+1] = o + vec2(0,dy * s)
                v[#v+1] = o + vec2(dx * s,dy * s)
                local new = {cent, edge, edge, cent, edge, edge}
                for i=1,#new do
                    no[#no+1] = new[i]
                end
            end
        end
        -- print("vertices", #v)
        --  r = (#v/6)+1
        rr.vertices = v
        
        rr:addRect(0,0,w-2*s,h-2*s)
        rr:addRect(0,(h-s)/2,w-2*s,s)
        rr:addRect(0,-(h-s)/2,w-2*s,s)
        rr:addRect(-(w-s)/2, 0, s, h - 2*s)
        rr:addRect((w-s)/2, 0, s, h - 2*s)
        --mark edges
        local new = {cent,cent,cent, cent,cent,cent,
        edge,cent,cent, edge,cent,edge,
        cent,edge,edge, cent,edge,cent,
        edge,edge,cent, edge,cent,cent,
        cent,cent,edge, cent,edge,edge}
        for i=1,#new do
            no[#no+1] = new[i]
        end
        rr.normals = no
        --texture
        if t.tex then
            rr.shader.fragmentProgram = rrectshad.fragTex
            rr.texture = t.tex
            local t = {}
            local ww,hh = w*0.5, h*0.5
          --  local aspect = vec2(w,h) --vec2(w * (rr.texture.width/w), h * (rr.texture.height/h))
            
            for i,v in ipairs(rr.vertices) do
                t[i] = vec2((v.x + ww)/w, (v.y + hh)/h)
            end
            rr.texCoords = t
        end
        local sc = 1/math.max(2, s)
        rr.shader.scale = sc --set the scale, so that we get consistent one pixel anti-aliasing, regardless of size of corners
        __RRects[label] = rr
    end
    __RRects[label].shader.fillColor = color(fill())
    if strokeWidth() == 0 then
        __RRects[label].shader.strokeColor = color(fill())
    else
        __RRects[label].shader.strokeColor = color(stroke())
    end

    if t.resetTex then
        __RRects[label].texture = t.resetTex
        t.resetTex = nil
    end
    local sc = 0.25/math.max(2, s)
    __RRects[label].shader.strokeWidth = math.min( 1 - sc*3, strokeWidth() * sc)
    pushMatrix()
    translate(t.x,t.y)
    scale(t.scale or 1)
    __RRects[label]:draw()
    popMatrix()
end

rrectshad ={
vert=[[
uniform mat4 modelViewProjection;

attribute vec4 position;

//attribute vec4 color;
attribute vec2 texCoord;
attribute vec3 normal;

//varying lowp vec4 vColor;
varying highp vec2 vTexCoord;
varying vec3 vNormal;

void main()
{
    //  vColor = color;
    vTexCoord = texCoord;
    vNormal = normal;
    gl_Position = modelViewProjection * position;
}
]],
frag=[[
precision highp float;

uniform lowp vec4 fillColor;
uniform lowp vec4 strokeColor;
uniform float scale;
uniform float strokeWidth;

//varying lowp vec4 vColor;
varying highp vec2 vTexCoord;
varying vec3 vNormal;

void main()
{
    lowp vec4 col = mix(strokeColor, fillColor, smoothstep((1. - strokeWidth) - scale * 0.5, (1. - strokeWidth) - scale * 1.5 , vNormal.z)); //0.95, 0.92,
     col = mix(vec4(col.rgb, 0.), col, smoothstep(1., 1.-scale, vNormal.z) );
   // col *= smoothstep(1., 1.-scale, vNormal.z);
    gl_FragColor = col;
}
]],
fragTex=[[
precision highp float;

uniform lowp sampler2D texture;
uniform lowp vec4 fillColor;
uniform lowp vec4 strokeColor;
uniform float scale;
uniform float strokeWidth;

//varying lowp vec4 vColor;
varying highp vec2 vTexCoord;
varying vec3 vNormal;

void main()
{
    vec4 pixel = texture2D(texture, vTexCoord) * fillColor;
    lowp vec4 col = mix(strokeColor, pixel, smoothstep(1. - strokeWidth - scale * 0.5, 1. - strokeWidth - scale * 1.5, vNormal.z)); //0.95, 0.92,
    // col = mix(vec4(0.), col, smoothstep(1., 1.-scale, vNormal.z) );
    col *= smoothstep(1., 1.-scale, vNormal.z);
    gl_FragColor = col;
}
]]
}

--# Blur
Soda.Gaussian = class() --a component for nice effects like shadows and blur
--Gaussian blur
--adapted by Yojimbo2000 from http://xissburg.com/faster-gaussian-blur-in-glsl/ 

function Soda.Gaussian:setImage()
    local p = self.parent
    
    local ww,hh = p.w * self.falloff, p.h * self.falloff -- shadow image needs to be larger than the element casting the shadow, in order to capture the blurry shadow falloff
    self.ww, self.hh = ww,hh
 
    local d = math.max(ww, hh)
    local blurRad = smoothstep(d, math.max(WIDTH, HEIGHT)*1.5, 60) * 1.5
    local aspect = vec2(d/ww, d/hh) * blurRad --work out the inverse aspect ratio
   -- print(p.title, "aspect", aspect)

    local downSample = 0.25 

    local dimensions = vec2(ww, hh) * downSample --down sampled
    
    local blurTex = {} --images
    local blurMesh = {} --meshes
    for i=1,2 do --2 passes, one for horizontal, one vertical
        blurTex[i]=image(dimensions.x, dimensions.y)
        local m = mesh()
        m.texture=blurTex[i]
        m:addRect(dimensions.x/2, dimensions.y/2,dimensions.x, dimensions.y)
        m.shader=shader(Soda.Gaussian.shader.vert[i], Soda.Gaussian.shader.frag)
      --  blurred[i].shader.am = falloff
        m.shader.am = aspect
        blurMesh[i] = m
    end
    local imgOut = image(dimensions.x, dimensions.y)
    pushStyle()
    pushMatrix()
    setContext(blurTex[1])

    scale(downSample)

    self:drawImage()
    popMatrix()
    popStyle()   
    
    setContext(blurTex[2])
    blurMesh[1]:draw() --pass one
    setContext(imgOut)
    blurMesh[2]:draw() --pass two, to output
    setContext()

    return imgOut
end

function Soda.Gaussian:draw()
    local p = self.parent
    self.mesh:setRect(1, p.x + self.off, p.y - self.off, self.ww, self.hh)
    self.mesh:draw()
end

---------------------------------------------------------------------------

Soda.Blur = class(Soda.Gaussian)

function Soda.Blur:init(t)
    self.parent = t.parent
    self.falloff = 1
    self.off = 0
    self:setMesh()
  --  self.image = image(self.parent.w * 0.25, self.parent.h * 0.25)
  --  self.draw = self.setMesh --
end

function Soda.Blur:draw() end

function Soda.Blur:setMesh() 
   --     self.draw = null
    self.image = self:setImage()
    self.parent.shapeArgs.tex = self.image
    self.parent.shapeArgs.resetTex = self.image
end

function Soda.Blur:drawImage()
    pushMatrix()

    translate(-self.parent:left(), -self.parent:bottom())
 
    Soda.drawing(self.parent) --draw all elements to the blur image, with the parent set as the breakpoint (so that the parent window itself does not show up in the blurred image)
    popMatrix()
end

---------------------------------------------------------------------------

Soda.Shadow = class(Soda.Gaussian)

function Soda.Shadow:init(t)
    self.parent = t.parent

     self.falloff = 1.3
    self.off = math.max(2, self.parent.w * 0.015, self.parent.h * 0.015)
   -- print(self.parent.title, "offset", self.off)
    self.mesh = mesh()
    self.mesh:addRect(0,0,0,0)
    self:setMesh()
end

function Soda.Shadow:setMesh()
    self.mesh.texture = self:setImage()
   -- self.mesh:setRect(1, self.parent.x + self.off,self.parent.y - self.off,self.ww, self.hh)   --nb, rect is set in draw function, for animation purposes
end

function Soda.Shadow:drawImage()
    pushStyle()
    pushMatrix()

    translate((self.ww-self.parent.w)*0.45, (self.hh-self.parent.h)*0.45)
    self.parent:drawShape(Soda.style.shadow)
    popMatrix()

    popStyle()
end

Soda.Gaussian.shader = {
vert = { -- horizontal pass vertex shader
[[
uniform mat4 modelViewProjection;
uniform vec2 am; // ammount of blur, inverse aspect ratio (so that oblong shapes still produce round blur)
attribute vec4 position;
attribute vec2 texCoord;
 
varying vec2 vTexCoord;
varying vec2 v_blurTexCoords[14];
 
void main()
{
    gl_Position = modelViewProjection * position;
    vTexCoord = texCoord;
    v_blurTexCoords[ 0] = vTexCoord + vec2(-0.028 * am.x, 0.0);
    v_blurTexCoords[ 1] = vTexCoord + vec2(-0.024 * am.x, 0.0);
    v_blurTexCoords[ 2] = vTexCoord + vec2(-0.020 * am.x, 0.0);
    v_blurTexCoords[ 3] = vTexCoord + vec2(-0.016 * am.x, 0.0);
    v_blurTexCoords[ 4] = vTexCoord + vec2(-0.012 * am.x, 0.0);
    v_blurTexCoords[ 5] = vTexCoord + vec2(-0.008 * am.x, 0.0);
    v_blurTexCoords[ 6] = vTexCoord + vec2(-0.004 * am.x, 0.0);
    v_blurTexCoords[ 7] = vTexCoord + vec2( 0.004 * am.x, 0.0);
    v_blurTexCoords[ 8] = vTexCoord + vec2( 0.008 * am.x, 0.0);
    v_blurTexCoords[ 9] = vTexCoord + vec2( 0.012 * am.x, 0.0);
    v_blurTexCoords[10] = vTexCoord + vec2( 0.016 * am.x, 0.0);
    v_blurTexCoords[11] = vTexCoord + vec2( 0.020 * am.x, 0.0);
    v_blurTexCoords[12] = vTexCoord + vec2( 0.024 * am.x, 0.0);
    v_blurTexCoords[13] = vTexCoord + vec2( 0.028 * am.x, 0.0);
}]],
-- vertical pass vertex shader
 [[
uniform mat4 modelViewProjection;
uniform vec2 am; // ammount of blur
attribute vec4 position;
attribute vec2 texCoord;
 
varying vec2 vTexCoord;
varying vec2 v_blurTexCoords[14];
 
void main()
{
    gl_Position = modelViewProjection * position;
    vTexCoord = texCoord;
    v_blurTexCoords[ 0] = vTexCoord + vec2(0.0, -0.028 * am.y);
    v_blurTexCoords[ 1] = vTexCoord + vec2(0.0, -0.024 * am.y);
    v_blurTexCoords[ 2] = vTexCoord + vec2(0.0, -0.020 * am.y);
    v_blurTexCoords[ 3] = vTexCoord + vec2(0.0, -0.016 * am.y);
    v_blurTexCoords[ 4] = vTexCoord + vec2(0.0, -0.012 * am.y);
    v_blurTexCoords[ 5] = vTexCoord + vec2(0.0, -0.008 * am.y);
    v_blurTexCoords[ 6] = vTexCoord + vec2(0.0, -0.004 * am.y);
    v_blurTexCoords[ 7] = vTexCoord + vec2(0.0,  0.004 * am.y);
    v_blurTexCoords[ 8] = vTexCoord + vec2(0.0,  0.008 * am.y);
    v_blurTexCoords[ 9] = vTexCoord + vec2(0.0,  0.012 * am.y);
    v_blurTexCoords[10] = vTexCoord + vec2(0.0,  0.016 * am.y);
    v_blurTexCoords[11] = vTexCoord + vec2(0.0,  0.020 * am.y);
    v_blurTexCoords[12] = vTexCoord + vec2(0.0,  0.024 * am.y);
    v_blurTexCoords[13] = vTexCoord + vec2(0.0,  0.028 * am.y);
}]]},
--fragment shader
frag = [[precision mediump float;
 
uniform lowp sampler2D texture;
 
varying vec2 vTexCoord;
varying vec2 v_blurTexCoords[14];
 
void main()
{
    gl_FragColor = vec4(0.0);
    gl_FragColor += texture2D(texture, v_blurTexCoords[ 0])*0.0044299121055113265;
    gl_FragColor += texture2D(texture, v_blurTexCoords[ 1])*0.00895781211794;
    gl_FragColor += texture2D(texture, v_blurTexCoords[ 2])*0.0215963866053;
    gl_FragColor += texture2D(texture, v_blurTexCoords[ 3])*0.0443683338718;
    gl_FragColor += texture2D(texture, v_blurTexCoords[ 4])*0.0776744219933;
    gl_FragColor += texture2D(texture, v_blurTexCoords[ 5])*0.115876621105;
    gl_FragColor += texture2D(texture, v_blurTexCoords[ 6])*0.147308056121;
    gl_FragColor += texture2D(texture, vTexCoord         )*0.159576912161;
    gl_FragColor += texture2D(texture, v_blurTexCoords[ 7])*0.147308056121;
    gl_FragColor += texture2D(texture, v_blurTexCoords[ 8])*0.115876621105;
    gl_FragColor += texture2D(texture, v_blurTexCoords[ 9])*0.0776744219933;
    gl_FragColor += texture2D(texture, v_blurTexCoords[10])*0.0443683338718;
    gl_FragColor += texture2D(texture, v_blurTexCoords[11])*0.0215963866053;
    gl_FragColor += texture2D(texture, v_blurTexCoords[12])*0.00895781211794;
    gl_FragColor += texture2D(texture, v_blurTexCoords[13])*0.0044299121055113265;
}]]
}



--# FRAME
Soda.Frame = class() --the master class for all UI elements. 

function Soda.Frame:init(t)
    t.shapeArgs = t.shapeArgs or {}
    t.style = t.style or Soda.style.default
    if not t.label and t.title then
        t.label = {x=0.5, y=-10}
    end
    self:storeParameters(t)
 
    self.callback = t.callback or null --triggered on action completion
    self.update = t.update or null --triggered every draw cycle.
    
    --null = function() end. ie no need to test if callback then callback()
    
    self.child = {} --hold any children

    self:setPosition()

    self.mesh = {} --holds additional effects, such as shadow and blur
    if t.blurred then
        self.mesh[#self.mesh+1] = Soda.Blur{parent = self}
        self.shapeArgs.tex = self.mesh[#self.mesh].image
        self.shapeArgs.resetTex = self.mesh[#self.mesh].image
    end
    if t.shadow then
        self.mesh[#self.mesh+1] = Soda.Shadow{parent = self}
    end
    
    if t.parent then
        t.parent.child[#t.parent.child+1] = self --if this has a parent, add it to the parent's list of children
    else
        table.insert( Soda.items, self) --no parent = top-level, added to Soda.items table
    end
    
    self.inactive = self.hidden --elements that are defined as hidden (invisible) are also inactive (untouchable) at initialisation
end

function Soda.Frame:storeParameters(t)
    self.parameters = {}
    for k,v in pairs(t) do
        
        if k =="label" or k=="shapeArgs" then
            self[k] = {}
            self.parameters[k] = {}
            for a,b in pairs(v) do
                self[k][a] = b
                self.parameters[k][a] = b
            end
        else
            self.parameters[k] = v
            self[k] = v
        end
        
    end
end

function Soda.Frame:setPosition() --all elements defined relative to their parents. This is recalculated when orientation changes
    local t = self.parameters
    local edge = vec2(WIDTH, HEIGHT)
    if self.parent then
        edge = vec2(self.parent.w, self.parent.h)
    end
    
    self.x, self.w = Soda.parseCoordSize(t.x or 0.5, t.w or 0.4, edge.x)
    self.y, self.h = Soda.parseCoordSize(t.y or 0.5, t.h or 0.3, edge.y)
    if t.label then
        self.label.w, self.label.h = self:getTextSize()
        
        self.label.x = Soda.parseCoord(t.label.x,self.label.w,self.w)
        self.label.y = Soda.parseCoord(t.label.y,self.label.h,self.h)

    end
    if self.shapeArgs then
        local s = self.shapeArgs
        s.w = t.shapeArgs.w or self.w
        s.h = t.shapeArgs.h or self.h

        s.x = Soda.parseCoord(t.shapeArgs.x or 0, s.w, self.w)
        s.y = Soda.parseCoord(t.shapeArgs.y or 0, s.h, self.h)
    end
end

function Soda.Frame:getTextSize(sty, tex)
    pushStyle()
    Soda.setStyle(Soda.style.default.text)
    Soda.setStyle(sty or self.style.text)
    local w,h = textSize(tex or self.title)
    popStyle()
    return w,h
end

function Soda.Frame:show(direction)
    self.hidden = false --so that we can see animation
    if direction then --animation
        self:setPosition()
        local targetX = self.x
        if direction==LEFT then
            self.x = - self.w * 0.5
        elseif direction==RIGHT then
            self.x = WIDTH + self.w * 0.5
        end
        tween(0.4, self, {x=targetX}, tween.easing.cubicInOut, function() self.inactive=false end) --user cannot touch buttons until animation completes
    else --no animation
        self.inactive = false
    end
    if self.shapeArgs and self.shapeArgs.tex then self.shapeArgs.resetTex = self.shapeArgs.tex end --force roundedrect to switch texture (because two rects of same dimensions are cached as one mesh)
end

function Soda.Frame:hide(direction)
    self.inactive=true --cannot touch element during deactivation animation
    if direction then
        local targetX
        if direction==LEFT then
            targetX = - self.w * 0.5
        elseif direction==RIGHT then
            targetX = WIDTH + self.w * 0.5
        end
        tween(0.4, self, {x=targetX}, tween.easing.cubicInOut, function() self.hidden = true end) --user cannot touch buttons until animation completes
    else
        self.hidden = true
    end
end

function Soda.Frame:toggle(direction)
    if self.inactive then self:show(direction)
    else self:hide(direction)
    end
end

function Soda.Frame:draw(breakPoint)
    if breakPoint and breakPoint == self then return true end
    if self.hidden then return end
    self:update()
    if self.alert then
        Soda.darken.draw() --darken underlying interface elements
    end
    
    for i = #self.mesh, 1, -1 do
        self.mesh[i]:draw() --draw shadow
    end
    
    local sty = self.style
    if self.highlighted and self.highlightable then
        sty = self.style.highlight or Soda.style.default.highlight
    end
    pushMatrix()
    pushStyle()
    
    translate(self:left(), self:bottom())
    if self.shape then
        self:drawShape(sty)
    end
     Soda.setStyle(sty.text)
    self:drawContent()
    --pushStyle()
    if self.label then
        
        --Soda.setStyle(Soda.style.default.text)
       
        
        text(self.title, self.label.x, self.label.y)
        
    end
    if self.content then
        textWrapWidth(self.w * 0.9)
        text(self.content, self.w * 0.5, self.h * 0.6)
        textWrapWidth()
    end
   -- popStyle()
    
    for i, v in ipairs(self.child) do --nb children are drawn with parent's transformation
        --[[
        local ok, err = xpcall(function()  v:draw(breakPoint) end, function(trace) return debug.traceback(trace) end)
        if not ok then print(v.title, err) end
        ]]
        if v.kill then
            table.remove(self.child, i)
        else
            if v:draw(breakPoint) then return true end
        end
    end
    popMatrix()
    popStyle()
end

function Soda.Frame:drawContent() end --overridden by subclasses

function Soda.Frame:drawShape(sty)
  --  pushStyle()
    --Soda.setStyle(Soda.style.default.shape)
    Soda.setStyle(sty.shape)
    self.shape(self.shapeArgs)
   -- popStyle()
end

function Soda.Frame:bottom()
    return self.y - self.h * 0.5
end

function Soda.Frame:top()
    return self.y + self.h * 0.5
end

function Soda.Frame:left()
    return self.x - self.w * 0.5
end

function Soda.Frame:right()
    return self.x + self.w * 0.5
end

function Soda.Frame:keyboardHideCheck() --put this in touch began branches of end nodes (buttons, switches, things unlikely to have children)
    if Soda.keyboardEntity and Soda.keyboardEntity~=self then
        hideKeyboard()
        Soda.keyboardEntity = nil
    end
end

function Soda.Frame:touched(t, tpos)
    if self.inactive then return end
    local trans = tpos - vec2(self:left(), self:bottom()) --translate the touch position
    for i = #self.child, 1, -1 do --children take priority over frame for touch
        local v = self.child[i]
        if not v.inactive and v:touched(t, trans) then 
            return true 
        end
    end
  --  if self.alert then return true end --or self:pointIn(tpos.x, tpos.y) 
    return self.alert
end

function Soda.Frame:selectFromList(child) --method used by parents of selectors. 
    if child==self.selected then --pressed the one already selected
        if self.noSelectionPossible then
            child.highlighted = false
            self.selected = nil
        end
    else
        if self.selected then 
            self.selected.highlighted = false 
            --[[
            for i,v in ipairs(self.child) do
                if v~=child then v.highlighted = false end
            end
              ]]
            if self.selected.panel then self.selected.panel:hide() end
        end
        self.selected = child
        child.highlighted = true
        if child.panel then child.panel:show() end
        tween.delay(0.1, function() self:callback(child, child.title) end) --slight delay for list animation to register before panel disappears
    end
end

function Soda.Frame:pointIn(x,y)
    return x>self:left() and x<self:right() and y>self:bottom() and y<self:top()
end

function Soda.Frame:orientationChanged()
    self:setPosition()
    
    for _,v in ipairs(self.mesh) do
        v:setMesh()
    end
    
    for _,v in ipairs(self.child) do
        v:orientationChanged()
    end
end


--# Button
Soda.Button = class(Soda.Frame) --one press, activates on release

function Soda.Button:init(t)
    t.shape = t.shape or Soda.RoundedRectangle
    t.label = t.label or { x=0.5, y=0.5}
    t.highlightable = true
    Soda.Frame.init(self, t)
end

function Soda.Button:touched(t, tpos)
    if t.state == BEGAN then
        if self:pointIn(tpos.x, tpos.y) then
            self.highlighted = true
            self.touchId = t.id
            self:keyboardHideCheck()
            return true
        end
    elseif self.touchId and self.touchId == t.id then
        if t.state == MOVING then
            if not self:pointIn(tpos.x, tpos.y) then --if a touch begins within the element, but then drifts off it, it is cancelled. ie the user can change their mind. This is the same as on iOS.
                self.highlighted = false
                self.touchId = nil
                return true
            end
        else --ended
            self:callback()
            self.highlighted = false
            self.touchId = nil
            return true
        end
    end
   -- return Soda.Frame.touched(self, t, tpos) --a button shouldn't have children
end

----- Some button factories:

function Soda.MenuButton(t)
    t.title = "\u{2630}" --the "hamburger" menu icon
    t.w, t.h = 40, 40
    t.style = t.style or Soda.style.darkIcon
    return Soda.Button(t)
end

function Soda.BackButton(t)
    t.title = "\u{ff1c}" -- full-width less-than symbol. alt \u{276e}
    --[[
    if  t.direction == RIGHT then
        t.title = "\u{ff1e}" --greater-than, in case you need a right-facing back button. alt \u{276f}
    end
      ]]
    t.w, t.h = 40, 40
    t.style = t.style or Soda.style.darkIcon
    return Soda.Button(t)
end

function Soda.ForwardButton(t)
    t.title = "\u{ff1e}" --greater-than, in case you need a right-facing back button. alt \u{276f}
    t.w, t.h = 40, 40
    t.style = t.style or Soda.style.darkIcon
    return Soda.Button(t)
end

function Soda.CloseButton(t)
    t.title = "\u{2715}" --multiplication X 
    t.w, t.h = 40, 40
    t.style = t.style or Soda.style.darkIcon
    return Soda.Button(t)
end

function Soda.DropdownButton(t)
    t.title = "\u{25bc}" --down triangle
    t.w, t.h = 40, 40
    t.style = t.style or Soda.style.darkIcon
    return Soda.Button(t)
end

function Soda.SettingsButton(t)
    t.title = "\u{2699}" -- the "gear" icon
    t.w, t.h = 40, 40
    t.style = t.style or Soda.style.darkIcon
    t.shape = t.shape or Soda.ellipse
    return Soda.Button(t)
end

function Soda.AddButton(t)
    t.title = "\u{253c}" -- the "add" icon
    t.w, t.h = 40, 40
    t.style = t.style or Soda.style.darkIcon
    t.shape = t.shape or Soda.ellipse
    return Soda.Button(t)
end

function Soda.QueryButton(t)
    t.title = "?" --full-width ? \u{ff1f}
    t.w, t.h = 40, 40
    t.style = t.style or Soda.style.darkIcon
    t.shape = t.shape or Soda.ellipse
    return Soda.Button(t)
end

--# Toggle
Soda.Toggle = class(Soda.Button) --press toggles on/ off states

function Soda.Toggle:init(t)
    Soda.Button.init(self,t)
    self:toggleSettings(t)
end

function Soda.Toggle:toggleSettings(t)
    self.on = t.on or false    
    self.callback = t.callback or null
    self.callbackOff = t.callbackOff or null
    if self.on then 
        self:switchOn() 
    else
        self:switchOff()
    end
end

function Soda.Toggle:switchOn()
    self.on = true
    self.highlighted = true
    self:callback()
end

function Soda.Toggle:switchOff()
    self.on = false
    self.highlighted = false
    self:callbackOff()
end

function Soda.Toggle:touched(t, tpos)   
    if t.state == BEGAN then
        if self:pointIn(tpos.x, tpos.y) then
            self.touchId = t.id
            self:keyboardHideCheck()
            return true
        end
    elseif self.touchId and self.touchId == t.id then
        if t.state == MOVING then
            if not self:pointIn(tpos.x, tpos.y) then --cancelled
                self.touchId = nil
                
                return true
            end
        else --ended     
            self.touchId = nil
            self.on = not self.on
            if self.on then 
                self:switchOn() 
                
            else 
                self:switchOff() 
                
            end
            return true
        end
        
    end
   -- return Soda.Frame.touched(self, t, tpos) ---switch shouldn't have children
end

----- Some toggle factories:

function Soda.MenuToggle(t)
    t.title = "\u{2630}" --the "hamburger" menu icon
    t.w, t.h = 40, 40
    t.style = t.style or Soda.style.darkIcon
    return Soda.Toggle(t)
end



--# Switch
Soda.Switch = class(Soda.Toggle) --an iOS-style switch with a lever that moves back and forth

function Soda.Switch:init(t)

    local tw,_ = textSize(t.title or "")
   -- t.w, t.h = 120+tw,40

    Soda.Frame.init(self, {parent = t.parent, x = t.x, y=t.y, w = 120+tw, h = 40, on = t.on or false, style = t.style or Soda.style.switch, shape = Soda.RoundedRectangle, shapeArgs = {w = 70, h = 36, radius = 18, x = 0, y = 2}, highlightable = true, label = {x=80, y=0.5} , title = t.title})

    self.knob = Soda.Knob{parent = self, x = 0, y = 0.5, w=40, h=40, shape = Soda.ellipse, style = Soda.style.switch, shadow = true}
    
    self:toggleSettings(t)
end

function Soda.Switch:switchOn()
    Soda.Toggle.switchOn(self)
    self.knob:highlight() 
end

function Soda.Switch:switchOff()
    Soda.Toggle.switchOff(self)
    self.knob:unHighlight() 
end

--animates the switch handle flicking back and forth

Soda.Knob = class(Soda.Frame) 

function Soda.Knob:setPosition()
    Soda.Frame.setPosition(self)
    self.offX = self.x - 2
    self.onX = self.x+32
    if self.parent.on then self.x = self.onX end
end

function Soda.Knob:highlight()
    if self.tween then tween.stop(self.tween) tween.stop(self.tween2) end
    
    self.tween = tween(0.4, self, {x=self.onX}, tween.easing.cubicOut)
    local p = self.parent
    p.shapeArgs.scale = 1
    local t1 = tween(0.1, p.shapeArgs, {scale = 0.7}, tween.easing.cubicIn, function() p.highlighted = true end)
    local t2 = tween(0.3, p.shapeArgs, {scale = 1 }, tween.easing.cubicOut)
    self.tween2 = tween.sequence(t1, t2)

end

function Soda.Knob:unHighlight()
    if self.tween then tween.stop(self.tween) tween.stop(self.tween2) end

    self.tween = tween(0.4, self, {x=self.offX}, tween.easing.cubicOut)
        local p = self.parent
    p.shapeArgs.scale = 1
    local t1 = tween(0.1, p.shapeArgs, {scale = 0.7}, tween.easing.cubicIn, function() p.highlighted = false end)
    local t2 = tween(0.3, p.shapeArgs, {scale = 1 }, tween.easing.cubicOut)
    self.tween2 = tween.sequence(t1, t2)

end

--# Slider
Soda.Slider = class(Soda.Frame)

function Soda.Slider:init(t)
  --  t.shape = Soda.line
    t.w = t.w or 300
    t.h = 60
    t.style = Soda.style.switch
    self.value = t.start or t.min
    self.value = clamp(self.value, t.min, t.max)
    self.decimalPlaces = t.decimalPlaces or 0

    t.label = {x = 0, y = -0.001}
  --  t.shapeArgs = {x = 0, y = 20, h = 0}

    Soda.Frame.init(self, t)
    self.sliderLen = self.w - 40
    self.shapeArgs.w = self.sliderLen
    self.snapPoints = t.snapPoints or {}
    --calculate snap positions
    self.snapPos = {}
    for i,v in ipairs(self.snapPoints) do
        self.snapPos[i] = 20 + self:posFromValue(v)
    end
    self.range = self.max - self.min
  self.snapStep = lerp(5 / self.sliderLen, 0, self.range)
    self.knob = Soda.SliderKnob{
        parent = self, 
        x = 0, y = 0, w=35, h=35, 
        shape = Soda.ellipse, 
        style = Soda.style.switch, 
       -- highlightable = true,
        shadow = true
    }
    self.knob.x = 20 + self:posFromValue()
    
    self.valueLabel = Soda.Frame{
        parent = self,
        style = Soda.style.switch,
        x = -0.001, y = -0.001,
        title = string.format("%."..self.decimalPlaces.."f", self.value),
        label = {x = -0.001, y = -0.001}
    }
    
end

function Soda.Slider:posFromValue(val)
    local val = val or self.value
    return ((val - self.min)/(self.max-self.min)) * self.sliderLen
end

function Soda.Slider:valueFromPos(x)
    
    self.value = round(lerp((x - 20) / self.sliderLen, self.min, self.max), self.decimalPlaces)
   for _,v in ipairs(self.snapPoints) do
      if math.abs(self.value - v) < self.snapStep then
        self.value = v 
    --[[
    for i,v in ipairs(self.snapPos) do 
        if math.abs(x - v) < 5 then 
            self.value = self.snapPoints[i] ]]
            self.knob.x = 20 + self:posFromValue()
        end
    end
      

    if self.decimalPlaces == 0 then self.value = math.tointeger( self.value ) end
  --  self.title = tostring(self.value)
    self.valueLabel.title = string.format("%."..self.decimalPlaces.."f", self.value) --tostring(self.value)
end

function Soda.Slider:drawContent()
    local x, y = self:posFromValue() + 20, 20
--  Soda.setStyle(Soda.style.switch.shape)
    pushStyle()
    stroke(Soda.themes.default.text)
    strokeWidth(2)
    line(20, y, x,y)
    noStroke()
    fill(Soda.themes.default.text)
    for i,v in ipairs(self.snapPos) do
        if v > x then 
            --Soda.setStyle(Soda.style.switch.shape) 
            fill(Soda.themes.default.stroke)
        end
     --   line(v,y-10,v,y+10)
        ellipse(v,y,8)
    end
 --   Soda.setStyle(Soda.style.switch.shape)
    stroke(Soda.themes.default.stroke)
    strokeWidth(2)
    line(x, y, self.w-20,y)
    popStyle()
end
--[[
function Soda.Slider:draw()
    
end

function Soda.Slider:draw()
    -- Codea does not automatically call this method
end
]]
function Soda.Slider:touched(t, tpos)
   if Soda.Frame.touched(self, t, tpos) then return true end
  --  Soda.Frame.touched(self, t, tpos)
    if t.state == ENDED and self:pointIn(tpos.x, tpos.y) then
        if tpos.x < self:left() + self.knob.x then
            self.value = math.max(self.min, self.value - 1 )
        else
            self.value = math.min(self.max, self.value + 1)
        end
        --  self.label.text = tostring(self.value)
        self.knob.x = 20 + self:posFromValue()
        self.valueLabel.title = tostring(self.value)
        self:callback(self.value)
    end
    
end

Soda.SliderKnob = class(Soda.Frame)

function Soda.SliderKnob:touched(t, tpos)
    if t.state == BEGAN then
        if self:pointIn(tpos.x, tpos.y) then
            self.touchId = t.id
            self.highlighted = true
            self:keyboardHideCheck()
            return true
        end
    elseif self.touchId and self.touchId == t.id then
        
        self.x = clamp(self.x + t.deltaX * math.min(1, (t.deltaX * 0.5)^ 2),20,20 + self.parent.sliderLen)
        self.parent:valueFromPos(self.x)
        if t.state == ENDED then    
            self.touchId = nil
            self.highlighted = false   
            self.parent:callback(self.parent.value)   
        end
        return true
    end

end

--# TextEntry
Soda.TextEntry = class(Soda.Frame)

function Soda.TextEntry:init(t)
    t.shape = Soda.RoundedRectangle
    t.label = {x=10, y=0.5} 
    Soda.Frame.init(self, t)
    
    self.offset = vec2(self.label.w + 15, (self.h-self.label.h)*0.5) --bottom corner of text-entry (because left-aligned text needs to be drawn in CORNER mode)
    
    self.characterW = self:getTextSize(Soda.style.textEntry, "a") --width of a character (nb fixed-width font only, because this massively simplifies creation of touchable text)
    
    self:inputString(t.default or "")
end

function Soda.TextEntry:inputString(txt)
    self.input = {} --table containing each character
    local capacity = (self.w - self.offset.x - 10)//self.characterW --how many characters can fit in the text box
    self.start = math.max(1, txt:len() + 1 - capacity) --the start position of the displayed text, this increases if text width is greater than box width
    for letter in txt:gmatch(".") do --populate input table with contents of txt
        self.input[#self.input+1]=letter
    end
    self.cursor = #self.input+1 --cursor = insertion point for self.input
    self.cursorPos = (self.cursor-self.start) * self.characterW --relative x coords of cursor 
    self.text = table.concat(self.input, "", self.start)
    self.textW = self:getTextSize(Soda.style.textEntry, self.text)
end

function Soda.TextEntry:draw(breakPoint)
    Soda.Frame.draw(self, breakPoint)
    local x = self:left() + self.offset.x
    local y = self:bottom() + self.offset.y
    pushStyle()

    if Soda.keyboardEntity and Soda.keyboardEntity == self then
        if not isKeyboardShowing() then --end of text entry
            Soda.keyboardEntity = nil 
            tween.delay(0.001, function() self:callback(self:output()) end ) --because callback is in draw loop, delay it until end of draw
        end
        local h = 0.3 --0.25
        if CurrentOrientation == LANDSCAPE_LEFT or CurrentOrientation == LANDSCAPE_RIGHT then h = 0.4 end --0.35
        local typewriter = math.max(0, (HEIGHT * h) - y)
        Soda.UIoffset = Soda.UIoffset + (typewriter - Soda.UIoffset) * 0.1
        if (ElapsedTime/0.25)%2<1.3 then
            noStroke()
            fill(0, 201, 255, 200)
            rect(x+self.cursorPos+1,self.y,3,30)
        end
    end
        
    Soda.setStyle(Soda.style.textEntry)
--  Soda.setStyle(self.style.text)

    textAlign(LEFT)
    textMode(CORNER)
    text(self.text, x, y)
     popStyle()
end

function Soda.TextEntry:output()
    return table.concat(self.input)
end

function Soda.TextEntry:touched(t, tpos)
    if self:pointIn(tpos.x, tpos.y) then
        if Soda.keyboardEntity and Soda.keyboardEntity == self then
            --select text, move cursor
            local tp = tpos.x - (self:left() + self.offset.x)
            
          --  if tp<=self.textW then
              --  print("char", self.characterW)
                self.cursor = math.tointeger(self.start + ((math.min(tp, self.textW) + self.characterW * 0.5)//self.characterW) )
            --  print("tp",tp,"cursorPos",self.cursorPos, "cursor", self.cursor)
             self:getCursorPos()
           -- self.cursorPos = self.cursor * self.characterW
          --  end
        else
            if not isKeyboardShowing() then showKeyboard() end
            Soda.keyboardEntity = self
            --[[
            local off = (HEIGHT * 0.4 ) - self.label.y
            if off> 0 then
            tween(0.5, Soda, {UIoffset = off} )
        end
            ]]
        end
        return true

    end
end

function Soda.TextEntry:getCursorPos() --this method works with non-fixed width too
    local beforeCursor = table.concat(self.input, "", self.start, self.cursor-1)
    self.cursorPos = self:getTextSize(Soda.style.textEntry, beforeCursor)
end

function Soda.TextEntry:keyboard(key)
    if key == RETURN then
      --  tween(0.5, Soda, {UIoffset = 0} )
        hideKeyboard() --hide keyboard triggers end of text input event in TextEntry:draw()
    elseif key == BACKSPACE then
        if #self.input>0 and self.cursor>1 then
            table.remove(self.input, self.cursor-1)
            self.cursor = self.cursor - 1    
            self.start = math.max(1, self.start - 1  )    
        end
    else
        table.insert(self.input, self.cursor, key)
        self.cursor = self.cursor + 1
    end
   -- self.text = table.concat(self.input, "", self.start)
    
    if self.textW + self.characterW > self.w - self.offset.x - 10 then
       self.start = self.start + 1 
        
    end
    self.text = table.concat(self.input, "", self.start)
    self.textW = self:getTextSize(Soda.style.textEntry, self.text)
   -- self:getCursorPos()
    self.cursorPos = ((self.cursor - self.start)) * self.characterW
end


--# Selector
Soda.Selector = class(Soda.Button) --press deactivates its siblings

function Soda.Selector:touched(t, tpos)
    if t.state == BEGAN then
        if self:pointIn(tpos.x, tpos.y) then
            self.touchId = t.id
            self:keyboardHideCheck()
            return true
        end
    elseif self.touchId and self.touchId == t.id then
        if t.state == ENDED and self:pointIn(tpos.x, tpos.y) then
    
            self:keyboardHideCheck()
            self:callback()
            self.touchId = nil
            --  self.highlighted = true
            self.parent:selectFromList(self)
            return true
        end
    end
end

--# Segment
Soda.Segment = class(Soda.Frame) --horizontally segmented set of selectors

function Soda.Segment:init(t)   
    t.h = t.h or 40
    Soda.Frame.init(self, t)
   -- self.mesh = {}
    local n = #t.text
    local w = 1/n
  --  local ww = 0.85/n --1/(n+0.5)
    local defaultNo = t.defaultNo or 1 --default to displaying the left-most panel
    for i=1,n do
        local shape = Soda.RoundedRectangle
        local corners, panel
        if i==1 then corners = 1 | 2
        elseif i==n then corners = 4 | 8
        else
            shape = Soda.rect
        end
        local x = (i-0.5)*w
        if t.panels then
            panel = t.panels[i]
            panel:hide() --hide the panel by default
        end
        local this = Soda.Selector{parent = self, idNo = i, title = t.text[i], x = x, y = 0.5, w = w+0.002, h=t.h, shape = shape, shapeArgs={corners=corners}, panel = panel}  --self.h * 0.5, w++0.004
        
        if not t.noSelectionPossible and i==defaultNo then 
            self:selectFromList(this)
            --[[
            this.highlighted = true
            self.selected = this
            if this.panel then this.panel:show() end
              ]]
        end
        
    end
end


--# Scroll
Soda.Scroll = class(Soda.Frame) --touch methods for scrolling classes, including distinguishing scroll gesture from touching a button within the scroll area, and elastic bounce back

function Soda.Scroll:init(t)
    self.scrollHeight = t.scrollHeight
    self.scrollVel = 0
    self.scrollY = 0
    self.touchMove = 1
    Soda.Frame.init(self,t)
end

function Soda.Scroll:updateScroll()
    
    local scrollH = math.max(0, self.scrollHeight -self.h)
    if self.scrollY<0 then 
      --  self.scrollVel = self.scrollVel +   math.abs(self.scrollY) * 0.005
        self.scrollY = self.scrollY * 0.7
    elseif self.scrollY>scrollH then
        self.scrollY = self.scrollY - (self.scrollY-scrollH) * 0.3
    end
    if not self.touchId then
        self.scrollY = self.scrollY + self.scrollVel
        self.scrollVel = self.scrollVel * 0.94
    end
end

function Soda.Scroll:touched(t, tpos)
    if self.inactive then return end
    if self:pointIn(tpos.x, tpos.y) then
        
        if t.state == BEGAN then
            self.scrollVel = t.deltaY
            self.touchId = t.id
            self.touchMove = 0
            self:keyboardHideCheck()
        elseif self.touchId and self.touchId == t.id then
            self.touchMove = self.touchMove + math.abs(t.deltaY) --track ammount of vertical motion
            if t.state == MOVING then
                self.scrollVel = t.deltaY
                self.scrollY = self.scrollY + t.deltaY
                
            else --ended
                self.touchId = nil
            end
    
        end
        if self.touchMove<10 then --only test selectors if this touch was not a scroll gesture
            local off = tpos - vec2(self:left(), self:bottom() + self.scrollY)
            for _, v in ipairs(self.child) do --children take priority over frame for touch
                if v:touched(t, off) then return true end
            end
        end
        return true
    end
    return self.alert
end


--# ScrollShape
Soda.ScrollShape = class(Soda.Scroll) --scrolling inside a shape, eg a rounded rectangle

function Soda.ScrollShape:init(t)
    t.h = t.h or math.min(HEIGHT*0.8, #t.text * 20)
    t.shape = Soda.RoundedRectangle 
  --  self:storeParameters(t)
  --  self:setPosition()

    Soda.Scroll.init(self, t)
    
    self.image = image(self.w, self.h)
    setContext(self.image) background(255) setContext()
    self.shapeArgs.radius = t.shapeArgs.radius or 6
    self.shapeArgs.tex = self.image
    self.shapeArgs.resetTex = self.image
    
end

function Soda.ScrollShape:orientationChanged()
    Soda.Frame.orientationChanged(self)
    self.image = image(self.w, self.h)
   -- setContext(self.image) background(255) setContext()
    self.shapeArgs.tex = self.image
    self.shapeArgs.resetTex = self.image
end

function Soda.ScrollShape:draw(breakPoint)
    if breakPoint and breakPoint==self then return true end
    if self.hidden then return end
    
    if self.alert then
        Soda.darken.draw()
    end
    for i = #self.mesh, 1, -1 do
        self.mesh[i]:draw()
    end
      
    self:updateScroll()

    if not breakPoint then
        --  tween.delay(0.001, function() self:drawImage() end)
        setContext(self.image)
        background(120, 120) --40,40 self.style.shape.stroke
        
        pushMatrix()
        resetMatrix()
        --if self.blurred then sprite(self.mesh[1].image, self.w*0.5, self.h*0.5, self.w, self.h) end
        translate(0, self.scrollY)
        self:drawImage()
        popMatrix()
        setContext()
    end
 
    pushMatrix()
    translate(self:left(), self:bottom())
    self:drawShape(self.style)
    popMatrix()
end

function Soda.ScrollShape:drawImage()

    for _, v in ipairs(self.child) do
        v:draw()
    end
    
    --[[
    if breakPoint then
    -- setContext(breakPoint.mesh[1].image)
    -- setContext(breakPoint.image)
    breakPoint.image()
else
    ]]

end





--# TextScroll
Soda.TextScroll = class(Soda.Scroll) --smooth scrolling of large text files (ie larger than screen height)

function Soda.TextScroll:init(t)
   -- t.shape = t.shape or Soda.rect
    self.characterW, self.characterH = self:getTextSize(Soda.style.textBox, "a")
    Soda.Scroll.init(self, t)
    
    self:clearString()
    self:inputString(t.textBody)
end

function Soda.TextScroll:clearString()
    self.lines = {}
  --  self.chunk = {}
    self.cursorY = 0
    self.scrollHeight = 0    
end

function Soda.TextScroll:inputString(txt)
    --split text into lines and wrap them
  --  local lines = {}
    self.chunk = {}
    local boxW = (self.w//self.characterW)-2 --how many characters can we fit in?
    for lin in txt:gmatch("[^\n\r]+") do
      --  local prefix = ""
        while lin:len()>boxW do --wrap the lines
            self.lines[#self.lines+1] = lin:sub(1, boxW)
            lin = lin:sub(boxW+1) 
          --  prefix = "  "    
        end
        self.lines[#self.lines+1] = lin
    end
    self.scrollHeight = #self.lines * self.characterH
    
    --put lines back into chunks of text, 10 lines high each
    local n = #self.lines//10
    for i = 0,n do
        local start = (i * 10)+1
        local stop = math.min(#self.lines, start + 9) --nb concat range is inclusive, hence +9
        self.chunk[#self.chunk+1] = {y = self.h - (stop * self.characterH), text = table.concat(self.lines, "\n", start, stop)} --self.cursorY + 
    end
  --  print(#self.lines, #self.chunk)
   -- self.cursorY = self.scrollHeight
end

function Soda.TextScroll:drawContent()
    
    self:updateScroll()
    pushStyle()
    Soda.setStyle(Soda.style.textBox)
    textMode(CORNER)
    textAlign(LEFT)
    --[[

    translate(self:left(),self:bottom())--+self.scrollY
    self:drawShape(Soda.style.default)
      ]]
        pushMatrix()
        local mm = modelMatrix()
    translate(10, self.scrollY)

    clip(mm[13]+10, mm[14]+10, self.w-20, self.h-20) --nb translate doesnt apply to clip. (idea: grab transformation from current model matrix?) --self.parent:left()+self:left(),self.parent:bottom()+self:bottom()
    
    --calculate which chunks to draw
    local lineStart = math.max(1, math.ceil(self.scrollY/self.characterH))
    local chunkStart = math.ceil(lineStart * 0.1)
    -- if CurrentOrientation == PORTRAIT or CurrentOrientation == PORTRAIT_UPSIDE_DOWN then d
    local n = math.min(#self.chunk, chunkStart + 5)
    for i = chunkStart, n, 1 do
        text(self.chunk[i].text, 0, self.chunk[i].y)
    end
    clip()
    popStyle()
  popMatrix()
    
end


--# List
Soda.List = class(Soda.ScrollShape)

function Soda.List:init(t)
    if type(t.text)=="string" then --can also accept a comma-separated list of values instead of a table
        local tab={}
        for word in t.text:gmatch("(.-),%s*") do
            tab[#tab+1] = word
        end
        t.text = tab
    end
    t.scrollHeight = #t.text * 40
    t.h = math.min(t.h or t.scrollHeight, t.scrollHeight)
    Soda.ScrollShape.init(self, t)
    for i,v in ipairs(t.text) do
        local number = ""
        if t.enumerate then number = i..") " end
        
        if t.panels then
            panel = t.panels[i]
            panel:hide() --hide the panel by default
        end
        
        local item = Soda.Selector{parent = self, idNo = i, title = number..v, label = {x = 10, y = 0.5}, style = t.style, shape = Soda.rect, highlightable = true, x = 0, y = -0.001 - (i-1)*40, w = 1, h = 42, panel = panel} --label = { text = v, x = 0, y = 0.5}, title = v,Soda.rect
        if t.defaultNo and i==t.defaultNo then
          --  item.highlighted = true
            self:selectFromList(item)
        end
    end
end

function Soda.List:clearSelection()
    if self.selected then self.selected.highlighted = false end
    self.selected = nil
end

--- a factory for dropdown lists

function Soda.DropdownList(t)
    local this = Soda.Button{
        parent = t.parent, x = t.x, y = t.y, w = t.w, h = t.h,
        title = "\u{25bc} "..t.title..": Select from list",
        label = {x = 10, y = 0.5}
    }

    local callback = t.callback or null

    this.list = Soda.List{
        parent = t.parent,
        hidden = true,
        x = t.x, y = this:bottom() - t.parent.h, w = t.w, h = this:bottom(),
        text = t.text,    
        defaultNo = t.defaultNo,  
        enumerate = t.enumerate,
        callback = function(self, selected, txt) 
            this.title = "\u{25bc} "..t.title..": "..txt
            this:setPosition() --to recalculate left-justified label
            self:hide() 
            callback(self, selected, txt)
        end
    } 
    
    this.clearSelection = function() 
        this.list:clearSelection() 
        this.title = "\u{25bc} "..t.title..": Select from list"
        this:setPosition() --to recalculate left-justified label
    end
    --add clear list method (...perhaps this should be a class, not a wrapper?)
    
    this.callback = function() this.list:toggle() end --callback has to be outside of constructor only when two elements' callbacks both refer to each-other.
    
    return this
end


--# Windows
--factories for various window types

function Soda.Window(t)
    t.shape = t.shape or Soda.RoundedRectangle
    t.shapeArgs = t.shapeArgs or {}
    t.shapeArgs.radius = 25
    t.label = t.label or {x=0.5, y=-15}
    
    local callback = t.callback or null
    local this = Soda.Frame(t)
    
    if t.ok then
        local title = "OK"
        if type(t.ok)=="string" then title = t.ok end
        Soda.Button{parent = this, title = title, x = -10, y = 10, w = 0.3, h = 40, callback = function() this.kill = true callback() end} --style = Soda.style.transparent,blurred = t.blurred,
    end
    
    if t.cancel then
        local title = "Cancel"
        if type(t.cancel)=="string" then title = t.cancel end
        Soda.Button{parent = this, title = title, x = 10, y = 10, w = 0.3, h = 40, callback = function() this.kill = true end,  style = Soda.style.warning} 
    end
   -- t.shadow = true
    return this
end

function Soda.Window2(t)
    t.shape = t.shape or Soda.RoundedRectangle
    t.shapeArgs = t.shapeArgs or {}
    t.shapeArgs.radius = 25
    t.style = t.style or Soda.style.thickStroke
    t.label = {x=0.5, y=-10}
 --   t.shadow = true
    return Soda.Frame(t)
end

function Soda.TextWindow(t)
    t.x = t.x or 0.5 
    t.y = t.y or 20
    t.w = t.w or 700
    t.h = t.h or -20
    
    local this = Soda.Window2(t)
    
    local scroll = Soda.TextScroll{
       -- parent = t.parent,
       -- label = {x=0.5, y=-10, text = t.title},
      --    shape = t.shape or Soda.RoundedRectangle,
     --   shapeArgs = t.shapeArgs,
     --   shadow = t.shadow,
     --   style = t.style,
     parent = this,
      x = 10, y = 10, w = -10, h = -10,
     --   x = t.x or 0.5, y = t.y or 20, w = t.w or 700, h = t.h or -20,
        textBody = t.textBody,
    }  
    
    this.inputString = function(_, ...) scroll:inputString(...) end
    this.clearString = function(_, ...) scroll:clearString(...) end
    --pass the textscroll's method to the enclosing wrapper (make this a subclass, not a wrapper)
    
    if t.closeButton then
        Soda.CloseButton{
            parent = this,
            x = -5, y = -5,
            style = Soda.style.icon,
            shape = Soda.ellipse,
            callback = function() this.kill = true end  
        }
        end
    return this
end

function Soda.Alert2Dark(t)
    local this = Soda.Window{title = t.title, h = 0.2, blurred = true}
    
    local ok = Soda.Button{parent = this, title = t.ok or "OK", x = 0, y = 0, w = 0.5, h = 50, style = Soda.style.dark, shape = Soda.outline, shapeArgs = {edge = TOPEDGE | RIGHTEDGE}} --style = Soda.style.transparent,blurred = true --{edgeX = LEFT, edgeY = 1, r = 25}
    
    local cancel = Soda.Button{parent = this, title = t.cancel or "Cancel", x = 0.75, y = 0, w = 0.5, h = 50, style = Soda.style.dark, shape = Soda.outline, shapeArgs = {edge = TOPEDGE}, callback = function() this.kill = true end} --style = Soda.style.transparent,{edgeX = RIGHT, edgeY = 1, r = 25}
    return this
end

--[[
function Soda.Alert2(t)
    local this = Soda.Frame{h = 0.25} --, edge = ~BOTTOMEDGE
     
    this.mesh = {
        Soda.Mesh{parent = this, shape = Soda.roundedRect, style = Soda.style.default, shapeArgs = {r = 25}, label = {x=0.5, y=0.6, text = t.title}}}
    
    this.mesh[2] = Soda.Shadow{parent = this}
    
    local ok = Soda.Button{parent = this, title = t.ok or "OK", x = 0.251, y = 0, w = 0.5, h = 50, shapeArgs = {r = 25, edge = LEFTEDGE | BOTTOMEDGE}} --style = Soda.style.transparent,blurred = true --{edgeX = LEFT, edgeY = 1, r = 25}
    local cancel = Soda.Button{parent = this, title = t.cancel or "Cancel", x = 0.748, y = 0, w = 0.5, h = 50, shapeArgs = {r = 25, edge = RIGHTEDGE | BOTTOMEDGE}, callback = function() this.kill = true end} --style = Soda.style.transparent,{edgeX = RIGHT, edgeY = 1, r = 25}
    return this
end
  ]]

function Soda.Alert2(t)
    t.h = t.h or 0.25
    t.shadow = true
    t.label = {x=0.5, y=0.6}
    t.alert = true  --if alert=true, underlying elements are inactive and darkened until alert is dismissed
    local callback = t.callback or null
    
    local this = Soda.Window(t) 
    
    local proceed = Soda.Button{parent = this, title = t.ok or "Proceed", x = 0.749, y = 0, w = 0.5, h = 50, shapeArgs = {corners = 8, radius = 25}, callback = function() this.kill = true callback() end,  style = Soda.style.transparent} --style = Soda.style.transparent,blurred = t.blurred,
    
    local cancel = Soda.Button{parent = this, title = t.cancel or "Cancel", x = 0.251, y = 0, w = 0.5, h = 50, shapeArgs = {corners = 1, radius = 25}, callback = function() this.kill = true end,  style = Soda.style.transparent} 
    
    return this
end

function Soda.Alert(t)
    t.h = t.h or 0.25
    t.shadow = true
    t.label = {x=0.5, y=0.6}
    t.alert = true  --if alert=true, underlying elements are inactive and darkened until alert is dismissed
    local this = Soda.Window(t) 
    local callback = t.callback or null
    local ok = Soda.Button{parent = this, title = t.ok or "OK", x = 0, y = 0, w = 1, h = 50, shapeArgs = {corners = 1 | 8, radius = 25}, callback = function() this.kill = true callback() end,  style = Soda.style.transparent} --style = Soda.style.transparent,blurred = t.blurred,
    return this
end

