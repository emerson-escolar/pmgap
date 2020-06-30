SetPackageInfo(rec(PackageName := "pmgap",
                   Subtitle := "Persistence Modules in GAP",
                   Version := "0.1.0",
                   PackageDoc := rec(BookName := "pmgap",
                                     SixFile := "doc/manual.six"),
                   Dependencies := rec(GAP := "4.11",
                                       NeededOtherPackages := [["QPA", "1.30"], ["json", "2.0.1"]],
                                       SuggestedOtherPackages := []),
                   AvailabilityTest := ReturnTrue,
                   Status := "dev",
                   Date := "30/06/2020",
                   Persons := [rec(LastName := "Escolar",
                                   FirstNames := "Emerson",
                                   IsAuthor := true,
                                   IsMaintainer := true)]));