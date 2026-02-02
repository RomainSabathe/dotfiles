// main.js - KWin script for back-and-forth desktop switching
var lastDesktop = null;

function toggleDesktop() {
    var current = workspace.currentDesktop;
    
    if (lastDesktop !== null && lastDesktop !== current) {
        workspace.currentDesktop = lastDesktop;
    }
    
    lastDesktop = current;
}

// Register the back-and-forth action
registerShortcut(
    "Desktop: Back and Forth",
    "Desktop: Back and Forth", 
    "Meta+Tab",
    toggleDesktop
);

// Register separate actions for each desktop with toggle behavior
// These create NEW shortcuts that you can assign to your preferred keys
for (var i = 1; i <= 20; i++) {
    (function(desktopNum) {
        var actionName = "Toggle Desktop " + desktopNum;
        
        var handler = function() {
            var targetDesktop = workspace.desktops[desktopNum - 1];
            if (!targetDesktop) return; // Desktop doesn't exist
            
            var current = workspace.currentDesktop;
            
            // If already on target desktop, do back-and-forth
            if (current === targetDesktop) {
                if (lastDesktop !== null && lastDesktop !== current) {
                    workspace.currentDesktop = lastDesktop;
                }
            } else {
                // Normal switch
                workspace.currentDesktop = targetDesktop;
            }
        };
        
        // Register with empty default shortcut - user assigns their preferred key
        registerShortcut(
            actionName,
            actionName,
            "",
            handler
        );
    })(i);
}

// Track desktop changes to update lastDesktop
workspace.currentDesktopChanged.connect(function (desktop) {
  var current = workspace.currentDesktop;
  lastDesktop = desktop;
});

