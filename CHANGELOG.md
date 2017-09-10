3.0.0
Remove small tweaks to seperate mod

2.8.1
Forgot to do initial note config changed

2.8.0
Add Picker notes based on sticky notes
Bug fixes
Add more types to hide minimap

2.7.3
Forgot to uncomment something!

2.7.2
bug fixes with area.to_xxx_area

2.7.1
small bug fixes with autosort, itemcount and hotkey events
zapper now zapps all selection tools and other planners by default

2.7.0
Fix Images in readme
Add Planner Cycler
Add Last Item Blueprint, Closes #30
Add Iondicators and other QOL tweaks

2.6.1:
Only change inventory size if less than inventory size
Fast replace UG belts defaults to false
Switch to sprite buttons
Orphans are a little less aggressive and removed when the neighbour is placed
Autosorting limits put in place
Hotkey to toggle train to manual mode J
Option to enable alt-mode when joining game
Entering a train with 1 station or no stations puts the train in manual mode
Find my car alert - Ctrl-shift-j
Small fixes smaller tree hitbox
Last planner is recalled
Shift-Clicking on entities in helmod side panel will put the item in your had if you have it
Clicking on entities in helmod side panel will make a pipette blueprint of the entitie with recipe and modules.
Can Zap everything.
Seperated out the planners to its own keybind, can still be stacked.
Performance Improvments
Underground belt brush cycles between maximum and minimum distance belts.
STDLIB updates
Picker Dollies can't move players
Belt Brush underground distance can be cycled with CTRL-Shift-R
Belt Brush pipes can make max distance pipes with CTROL-SHIFT-R
Belt Brush cascading undergrounds can be made with CTRL-SHIFT-B, cycled with the same
Instant blueprint of any entity in game is availble in the blueprint toolbar with an empty blueprint
Add screenshot camera, ore eraser
Fix neighbours bug introduced by .15.13, Closes #31
Item request proxys don't block dollies, #23
Dollies move items out of the way.
Dollies "store" the entity being moved so your mouse doesn't have to stay over it

2.6.0:
Blueprinter automatic planner expanded
Now cycles through a list of blueprints and gets or creates them
Lots of small fixes and improvments
Fix Reversed locale for pickup/loot setting, Closes #21
Add Position.Incremenet and Inventory.each_reverse.
Switched Instant Blueprint to check collision box not selection.
Update Quick UG Belt to use Position.Increment, make more effecient.
Remove extra log spam from blueprint/balancers.
Fix Quick BP off center.
Fix Locale for inventory editor.
Fix Balancer replacer not working on balancer bps only.
Fix Dollies crash moving ghosts. Last user not being set in some cases.
Create placeable off grid flying text for incrememnter.
Fix last user checks in many spots
Convert to player.mod_settings in many spots.
Changelog entry
Increment Version
