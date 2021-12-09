SetPackageInfo(rec(PackageName := "pmgap",
                   Subtitle := "Persistence Modules in GAP",
                   Version := "0.1.0",
                   Date := "30/06/2020",
                   License := "GPL-3.0",

                   ArchiveURL := "https://github.com/emerson-escolar/pmgap/releases",
                   ArchiveFormats := "",

                   AbstractHTML := "Persistence Modules in GAP.",
                   Keywords := ["persistence", "multidimensional persistence"],

                   PackageDoc := rec(BookName := "pmgap",
                                     SixFile := "doc/manual.six",
                                     PDFFile := "doc/manual.pdf",
                                     HTMLStart := "doc/chap0.html",
                                     LongTitle := "Persistence Modules in GAP",
                                     ArchiveURLSubset := ["doc"]),
                   Dependencies := rec(GAP := "4.11",
                                       NeededOtherPackages := [["QPA", "1.31"], ["json", "2.0.1"]],
                                       SuggestedOtherPackages := []),

                   AvailabilityTest := ReturnTrue,
                   Status := "other",
                   Persons := [rec(LastName := "Escolar",
                                   FirstNames := "Emerson G.",
                                   IsAuthor := true,
                                   IsMaintainer := true,
                                   WWWHome := "https://emerson-escolar.github.io/")],

                   SourceRepository := rec(Type := "git",
                                           URL := "https://github.com/emerson-escolar/pmgap"),
                   PackageWWWHome := "https://github.com/emerson-escolar/pmgap",
                   README_URL := Concatenation(~.PackageWWWHome, "/blob/master/README.md"),
                   PackageInfoURL := Concatenation(~.PackageWWWHome, "/blob/master/PackageInfo.g"),

                   TestFile := "tst/testall.g"
                  ));
