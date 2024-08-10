public import std.concurrency : send, ownerTid;

public import led;

shared(LedCallback)[] getAllCallbacks()
{
    import keyboard: Keyboard;
    import timer: Timer;
    import morse: Morse;

    shared keyboard = new Keyboard();
    shared timer = new Timer();
    shared morse = new Morse();

    return cast(shared(LedCallback)[]) [
        keyboard,
        timer,
        morse,
    ];
}

/// Interface that define possible actions on a led
shared interface LedCallback 
{
    string getName();
    void action();
}
