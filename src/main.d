import action;
import cli;
import keyboard;
import timer;
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

    auto allCallbacks = getAllCallbacks();
    foreach (callback; args.callbacks)
    {
        foreach (c; allCallbacks)
        {
            if (c.getName() == callback)
                spawn(&c.action);
        }
    }

    while (1)
    {
        auto update = receiveOnly!(LED_UPDATE);
        final switch (update) with (LED_UPDATE)
        {
        case SWITCH_ON:
            //led.state.switchOff();
            led.state.switchOn();
            break;
        case SWITCH_OFF:
            led.state.switchOff();
            break;
        case TOGGLE:
            led.state.toggle();
            break;
        }

        led.state.update();
    }
}
