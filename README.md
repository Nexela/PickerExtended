# Picker Extended!  Now with pipette extension
Extended version of the picker mod by Tinyboss

### Picker ghost revivier
Hover over a ghost and use the Factorio pipette tool to pick the entity that places it. Press the pipette tool button again to revive the ghost. Reviving a ghost keeps all of its settings and module requests. Picker extended will also try and fill module slots of revived ghosts if they have requests.
Recomend using this with the same keybinds as clean cursor and pipette tool. Picker extend can also pick up selected items on the ground and put it in your hands.

![Reviver in Action](https://github.com/Nexela/PickerExtended/blob/master/web/picker-reviver.gif)

### Picker Dollies
Hover over entities and use the Picker dolly keybinds to move entities around. Entities will keep their wire connections and settings. This allows you to build your set up spaced out and when you are finished push it all together for a nice tight build. Some entities can't be shoved around. Also respect max wire distance. Data Raw Prototypes mod is needed to Move entities, Combinators can be moved without it.  Note Moving some modded entities that rely on position can cause issues.

![Dollies in Action](https://github.com/Nexela/PickerExtended/blob/master/web/picker-combinator-dolly.gif)

### Picker Entity Blueprinter
Hover over an entity and take a quick blueprint of everything in its selection area with CONTROL+Q. Blueprints are created automatically if you don't have an existing Pipette Blueprint in your inventory. Modules and recipes are stored in the blueprint. Now you can quickly blueprint your moduled beacon for fast placing! Using this keybind with nothing in your hand and nothing selected will put a blank blueprint in your hand for quick blueprinting an area. If you have a blueprint in your hand it will switch to the deconstruction planner if you have nothing selected. Blue print mirroing is Availble by holding a blueprint and pressing ALT-R, Blueprint upgrading is available using the toolbar that shows up whenever you are holding a blueprint.

![Blueprinter in Action](https://github.com/Nexela/PickerExtended/blob/master/web/picker-blueprinter.gif)

### Picker Crafter
Alt-Q on an entity and picker will try to craft that entity if you have the items in your inventory. Can be bound to Q for even quicker crafting access.

### Picker Zapper
Have an inventory full of pesky blueprints? Try dropping them on the ground by using the drop item keybind (default Z) and they will be zapped away into the nether.

![Zapper in Action](https://github.com/Nexela/PickerExtended/blob/master/web/picker-zapper.gif)

### Picker Item Count
Holding an item in your hand will show the total count of all of that item in your inventory, including car trunks. Runtime option to disable.

![Item Count in Action](https://github.com/Nexela/PickerExtended/blob/master/web/picker-item-count.gif)

### Picker Pipe Cleaner
Call a plumber on any fluidbox by selecting the pipe and pressing CONTROL+DELETE. This will loop through all connected pipes and remove the selected fluid allowing your pipes to freely flow again.

![Pipe Cleaner in Action](https://github.com/Nexela/PickerExtended/blob/master/web/picker-pipe-cleaner.gif)

### Picker Chest Contents Mover
Quickly Move the contents of once chest to another. This is a quick and dirty move. CONTROL+V on the source chest and CONTROL+V on the destination chest. Items with grids or inventories will lose their grids or inventories when transferred. Use this for bulk material only.

![Chest Copy in Action](https://github.com/Nexela/PickerExtended/blob/master/web/picker-inv-copy.gif)

### Picker Quick Repair
Hover over any damanged entity and press CONTROL+Q with nothing in your hands to grab a repair tool from your inventory.

### Picker Module Reviver
Hover over any item request proxy and press Q to search your inventory for the requested modules/items and insert them.

### Picker Auto Hide Minimap
Automatically hides the minimap when you are hovering over a logistic container. This option can be disabled in the mod settings screen.

![Minimap Hide in Action](https://github.com/Nexela/PickerExtended/blob/master/web/picker-minimap-hide.gif)

### Picker Chest Limiter
Automatically set the bar limits on newly placed chests. (Chest limiter mod)

![Chest Limiter in Action](https://github.com/Nexela/PickerExtended/blob/master/web/picker-chest-limit.gif)

### Picker Inventory Sort
Manually sort opened containers with SHIFT+E, Automatically sorts container inventories when opened if the option is enabled. Can lag big warehouses, runtime option to disable.

![Inventory Sort in Action](https://github.com/Nexela/PickerExtended/blob/master/web/picker-inventory-sort.gif)

### Picker Automatic Orphan Finder
Highlights nearby underground belts and pipes that are not connected to anything underground when hoving over belts or pipes. Can be disabled per player in mod options.

![Orphan Finder in Action](https://github.com/Nexela/PickerExtended/blob/master/web/picker-orphans.gif)

### Picker Wire Tools
Cycle between Red, Green, and Copper wires in your inventory with SHIFT+Q  for quickly working with combinators. CONTROL+DELETE to remove all wires from the entity.

![Wire Tools in Action](https://github.com/Nexela/PickerExtended/blob/master/web/picker-wire-tools.gif)

### Picker Belt Brush
With a transport or underground belt in your hand hit pad increase or decrease buttons to change the width of your belts you can place at once. Once you have reached the desired width you can press CONTROL+SHIFT+R to create a corner blueprint of that width, Pressing CONTROL+SHIFT+R again will get a mirrored copy of the corner. Pressing CONTROL+SHIFT+B will cycle through all the available balancers. Feel free to submit your own balancer design if you don't like the included ones.

Additional paste settings. Copying from an assembler to a requester chest will add the new requests to the old ones instead of clearing them. Usefull for using one requester for multiple machines.

### Picker Filter Fill
Quickly and easily set filters and adjust requests using the handy dandy filter fill toolbar, Automatically shows up whenever you open a requester chest or filterable inventory. Requester chests can be made to quickly request all items in a blueprint by putting it in the first chest slot and clicking the button, or clicking the button with a blueprint in your hand.

### Picker Belt Upgrader (soon)
Quickly upgrade a section of belt by pressing the hotkey while hovering over the old belt while holding the belt type you want to upgrade to.

### Picker Quick UG Belt
Removes belts between newly placed underground belts if they are going the same direction.

### Picker Adjustment Pad
A quick increase/decrease pad using the +/- keys or the buttons on the gui. Mods can quickly create their own adjustment pad using a remote call to get or create the window and listening for the pad changed event.

![Picker Adjustment Pad in Action](https://github.com/Nexela/PickerExtended/blob/master/web/picker-adjustment-pad.gif)

### Picker Small Fixes
-   Picker Reacher, Comes default with modestly increased reach distances. Along with startup mod options to easily change them to suit your needs.
-   Construction and Logistic robots can't be plucked from the air. Comes with startup option to enable/disable this feature.  Also fixes bots going to quickbar by default.
-   Change the default requester paste multiplier from 10 to whatever you want. Can be changed with startup options
-   Corpse timer, Adjusts the length of time that corpses stay on the map.
-   Inventory size, Set the starting size of the players inventory
-   Cheaty Lights added in for youtube/twitch videos. Turned off by default.
