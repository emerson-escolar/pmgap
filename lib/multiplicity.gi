


# ********** For computing multiplicities **********

DimHomNaive := function(M,N)
    return Length(HomOverAlgebra(M,N));
end;

__MultiplicityAtIndec := function(M, I)
    local asseq, middleterm, mult, tauI;
    asseq := AlmostSplitSequence(I);
    if asseq = fail then
        # I is projective!
        middleterm := RadicalOfModule(I);
    else
        middleterm := Range(asseq[1]);
    fi;
    mult := DimHomNaive(M,I) - DimHomNaive(M, middleterm);
    if not asseq = fail then
        tauI := Source(asseq[1]);
        mult := mult + DimHomNaive(M, tauI);
    fi;
    return mult;
end;


InstallMethod(MultiplicityAtIndec,
              "for a path algebra mat module and indecomposable module",
              ReturnTrue,
              [IsPathAlgebraMatModule,
               IsIndecomposableModule],
              __MultiplicityAtIndec);
