import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class TerminalFaceApp extends Application.AppBase {
    
    var appSetting = {
        "consoleUserName" => "Jp",
        "consoleCommand" => "now",
        "consoleDeviceName" => "user",
        "isBtShown" => false,
        "stepViewOption" => 0,
        "flrsViewOption" => 0,
    };

    var appSettingKeys = [
        "consoleUserName",
        "consoleCommand",
        "consoleDeviceName",
        "isBtShown",
        "stepViewOption",
        "flrsViewOption",
    ];

    function initialize() {
        updateSettings();
        AppBase.initialize();
    }

    //? onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    //? onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    //? Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {
        return [ new TerminalFaceView(appSetting) ] as Array<Views or InputDelegates>;
    }

    //? New app settings have been received so trigger a UI update
    function onSettingsChanged() as Void {
        updateSettings();
        WatchUi.requestUpdate();
    }

    function updateSettings() as Void {
        for (var i = 0; i < appSetting.size(); i++) {
            appSetting[appSettingKeys[i]] = AppBase.getProperty(appSettingKeys[i]);
        }
    }

}

function getApp() as TerminalFaceApp {
    return Application.getApp() as TerminalFaceApp;
}