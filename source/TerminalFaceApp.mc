import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class TerminalFaceApp extends Application.AppBase {
    
    var appSetting = {
        "isConsoleDetailShown" => true,
        "isConsoleLabelShown" => true,
        "consoleDeviceName" => "user",
        "consoleUserName" => "Jc",
        "consoleCommand" => "now",
        "dateFormatOption" => 0,
        "dateOrderOption" => 0,
        "stepViewOption" => 1,
        "flrsViewOption" => 0,
        "isColorated" => true,
        "isCentered" => true,
        "isBtShown" => false,
        "isHRShown" => true,
    };

    var appSettingKeys = [
        "isConsoleDetailShown",
        "isConsoleLabelShown",
        "consoleDeviceName",
        "consoleUserName",
        "consoleCommand",
        "dateFormatOption",
        "dateOrderOption",
        "stepViewOption",
        "flrsViewOption",
        "isColorated",
        "isCentered",
        "isBtShown",
        "isHRShown",
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
        return [ new TerminalFaceView(appSetting) ];
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