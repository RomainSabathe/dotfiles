// main.js - KWin script for back-and-forth desktop switching
var lastDesktop = null;

function toggleDesktop() {
    var current = workspace.currentDesktop;
    
    if (lastDesktop !== null && lastDesktop !== current) {
        workspace.currentDesktop = lastDesktop;
    }
    
    lastDesktop = current;
}

// Register the action
registerShortcut(
    "Desktop: Back and Forth",
    "Desktop: Back and Forth", 
    "Meta+Tab",  // Default shortcut, can be changed in System Settings
    toggleDesktop
);

// Track desktop changes to update lastDesktop
workspace.currentDesktopChanged.connect(function(desktop) {
    if (lastDesktop === null) {
        lastDesktop = desktop;
    }
});
