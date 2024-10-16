#!/bin/sh

rm types.db assoc.db
qhash -l index.db | while read id link name; do
	test -f $id/type || continue
	cat $id/type | while read type; do
		test ! -z "$type" || continue;
		typeid="`qhash -g "$type" types.db`"
		if test -z "$typeid"; then
			typeid="`qhash -p "$type" types.db`"
		fi
		echo "-p\"$id:$typeid\""
	done | xargs -I {} qhash -m1 {} assoc.db >/dev/null
done
