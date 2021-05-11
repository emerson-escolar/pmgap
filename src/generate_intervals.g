Display(IntervalRepns(A));;

if computeseq then
    for height in RecNames(IntervalRepns(A)) do
        for I in IntervalRepns(A).(height) do
            Display(AlmostSplitSequence(I));
        od;
    od;
fi;
