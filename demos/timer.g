# NOTE:
# This file is based on the [deposited contribution](https://www.gap-system.org/Packages/Contrib/contrib.html)
# [timers.g](https://files.gap-system.org/gap44/deposit/gap/timers.g) by Steve Linton.


TIMER_MIN_RUNTIME_MS := 100;

# This function accepts as argument one function f, which must accept
# an integer n and do n repetitions of the operation to be timed.
# timer will rerun f with larger and larger n until it takes at least
# TIMER_MIN_RUNTIME_MS milliseconds and then return the average time per
# iteration in nanoseconds.

timer := function(f)
    local t,n;
    n := 1;
    t := 0;
    while true do
        GASMAN("collect");
        t := -Runtime();
        f(n);
        t := t+Runtime();

        if t > TIMER_MIN_RUNTIME_MS then
            break;
        else
            n := n * 5;
        fi;
    od;
    return Int(1000000*t/n);
end;
