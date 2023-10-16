public import std.concurrency : send, ownerTid;

public import led;

shared(LedCallback)[] getAllCallbacks()
{
    import keyboard: Keyboard;
    import timer: Timer;

    shared keyboard = new Keyboard();
    shared timer = new Timer();

    return cast(shared(LedCallback)[]) [
        keyboard,
        timer,
    ];
}

/// Interface that define possible actions on a led
shared interface LedCallback 
{
    string getName();
    void action();
}
