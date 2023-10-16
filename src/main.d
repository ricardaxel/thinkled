import cli;
import input;
import input_event_d;
import keyboard;
import led;

import std.stdio;
import std.concurrency;

int main(string[] argv)
{
    auto ledRegistry = new LedRegistry();

    auto args = parseArgv(argv);

    if (args.listLeds)
    {
        ledRegistry.list();
        return 0;
    }

    Led led = ledRegistry.getLedByName(args.led);

    spawn(&catchKbdEvent);

    while (1)
    {
        auto update = receiveOnly!(LED_UPDATE);
        final switch (update) with (LED_UPDATE)
        {
        case SWITCH_ON:
            led.state.switchOff();
            break;
        case SWITCH_OFF:
            led.state.switchOn();
            break;
        }

        led.state.update();
    }
}

void catchKbdEvent()
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
