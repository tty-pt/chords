#!/bin/sh

translate() {
	iconv -f utf-8 -t ascii//TRANSLIT | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9 ]//g' | sed 's/ /_/g'
}

rm types.db assoc.db
qdb -l index.db | while read link flags name; do
	test -f $link/type || continue
	cat $link/type | while read type; do
		test ! -z "$type" || continue;
		typeid="`echo $type | translate`"
		qdb -p "$typeid:$type" types.db:s:s
		echo "-p\"$link:$typeid\""
	done | xargs -I {} qdb {} assoc.db:2s >/dev/null
done
