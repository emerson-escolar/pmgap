# NOTE:
# This file is based on the [deposited contribution](https://www.gap-system.org/Packages/Contrib/contrib.html)
# [timers.g](https://files.gap-system.org/gap44/deposit/gap/timers.g) by Steve Linton.


TIMER_MIN_RUNTIME_MS := 100;

# This function accepts as argument one function f, which must accept
# an integer n and do n repetitions of the operation to be timed.
# timer will rerun f with larger and larger n until it takes at least
# TIMER_MIN_RUNTIME_MS milliseconds and then return the total time in milliseconds
# and number of iterations taken.

timer := function(f)
    local t,n;
    n := 1;
    t := 0;
    while true do
        GASMAN("collect");
        t := -Runtime();
        f(n);
        t := t+Runtime();

        if t >= TIMER_MIN_RUNTIME_MS then
            break;
        else
            n := n * 5;
        fi;
    od;
    return [t, n];
end;

#
# ns2times turns a number of microseconds into a tidy
#  human-readable string form

us2times := function(n)
    local s;
    s := "";
    if n >= 10^6 then
        Append(s, ShallowCopy(String(Int(n/10^6))));
        Append(s, "s ");
        n := n mod 10^6;
    fi;
    if n >= 10^3 then
        Append(s, ShallowCopy(String(Int(n/10^3))));
        Append(s, "ms ");
        n := n mod 10^3;
    fi;
    Append(s, ShallowCopy(String(n)));
    Append(s, "us");
    return s;
end;
