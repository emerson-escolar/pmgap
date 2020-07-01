#! @Chapter Persistence modules (representations)

#! @Section Intervals

#! @Arguments A
#! @Returns Record of dimension vectors of intervals
#! @Description
#! Computes the dimension vectors, organized by "height",
#! of the interval representations of the given
#! commutative grid path algebra A. Here, the "height" of
#! an interval is defined to be the number of rows of the
#! commutative grid its support occupies.
#!
#! The return value is a GAP Record, with heights 1, 2, ...
#! as the record names, and Lists of
#! dimension vectors (also Lists) as record components.
DeclareAttribute("IntervalDimVecs", IsCommGridPathAlgebra);

#! @Arguments A, dimension_vector_of_interval
#! @Returns interval representation
#! @Description
#! This operation builds the representation of A corresponding
#! to the dimension vector of an interval.
DeclareOperation("IntervalRepn", [IsCommGridPathAlgebra, IsCollection]);

#!
DeclareProperty("IsCommGridInterval", IsCommGridRepn);
