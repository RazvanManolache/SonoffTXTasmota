# Names provided by Tasmota firmware, absent from the host interpreter.
# These are declarations only. Compiled script closures are never executed.
var load, tasmota, Driver, serial, log, Leds, gpio
for name : ["autoexec.be", "txultimate.be", "tasmota.be"]
    var code = compile(name, "file")
    assert(type(code) == "function")
    print("Compiled without device execution:", name)
end
