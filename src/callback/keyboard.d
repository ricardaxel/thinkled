import std.algorithm;
import std.array;
import std.concurrency;
import std.file;
import std.stdio;
import std.string;

import action;
import input_event_d;
import input;

shared class Keyboard : LedCallback 
{
    override string getName() {
        return "keyboard";
    }

    override void action()
    {
        const string kbdEventFilename = getKeyboardEventFileName();
        File kdbEventFile = File(kbdEventFilename, "r");

        foreach (ubyte[input_event.sizeof] buffer; kdbEventFile.byChunk(input_event.sizeof))
        {
            InputEvent event = InputEvent.fromRawBytes(buffer);
            if (event.isKeyEvent())
            {
                synchronized
                {
                    if (event.isKeyRelease())
                        send(ownerTid, LED_UPDATE.SWITCH_ON);
                    else if (event.isKeyPress())
                        send(ownerTid, LED_UPDATE.SWITCH_OFF);
                }
            }
        }
    }

private:

    /// get filename of keyboard event
    /// (with the form '/dev/input/inputX')
    static string getKeyboardEventFileName()
    {

        const string content = readText(DEVICES_FILENAME);
        const string[] devices = content.split("\n\n");

        string keyboardDevice;
        foreach (device; devices)
        {
            if (device.canFind("keyboard"))
            {
                keyboardDevice = device;
                break;
            }
        }

        string event;
        foreach (line; keyboardDevice.split("\n"))
        {
            if (line[0] == 'H') // handler
                event = line.strip.split(" ")[$ - 1];
        }

        assert(event[0 .. 5] == "event");
        return "/dev/input/" ~ event;
    }

    // https://unix.stackexchange.com/questions/74903/explain-ev-in-proc-bus-input-devices-data
    enum DEVICES_FILENAME = "/proc/bus/input/devices";
}
