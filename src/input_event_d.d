import input;

/// wrapper for input_event
struct InputEvent
{
    timeval time;
    ushort type;
    ushort code;
    uint value;

    static InputEvent fromRawBytes(void[] buffer)
    {
        assert(buffer.length == input_event.sizeof);

        InputEvent ievent;
        input_event* event;
        event = cast(input_event*) buffer;

        ievent.time = event.time;
        ievent.type = event.type;
        ievent.code = event.code;
        ievent.value = event.value;

        return ievent;
    }

    bool isKeyEvent() const
    {
        return this.type == EV_KEY;
    }

    /// 'value' is the value the event carries. Either a relative change for EV_REL, 
    /// absolute new value for EV_ABS (joysticks ...), 
    //  or 0 for EV_KEY for release, 1 for keypress and 2 for autorepeat. 
    bool isKeyRelease() const
    {
        assert(this.isKeyEvent());
        return this.value == 0;
    }

    bool isKeyPress() const
    {
        assert(this.isKeyEvent());
        return this.value == 1;
    }

}
