bin/transp: items/chords/src/transpose/transpose.c
	${LINK.c} -o $@ $< -ldb

mod-bin += transp
