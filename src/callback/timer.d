import core.thread;

import action;

shared class Timer : LedCallback
{
    override string getName()
    {
        return "timer";
    }

    override void action()
    {
        while (1)
        {
            Thread.sleep(dur!("seconds")(1));
            send(ownerTid, LED_UPDATE.TOGGLE);
        }
    }
}
