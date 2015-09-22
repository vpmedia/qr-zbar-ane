%MINGW_HOME%/bin/pexports -v libiconv-2.dll >libiconv-2.def
%MINGW_HOME%/bin/dlltool -D libiconv-2.dll -d libiconv-2.def -l libiconv-2.a
%MINGW_HOME%/bin/pexports -v libzbar-0.dll >libzbar-0.def
%MINGW_HOME%/bin/dlltool -D libzbar-0.dll -d libzbar-0.def -l libzbar-0.a