#!/bin/sh

#qdb=$DOCUMENT_ROOT/usr/local/bin/qdb
qdb=qdb

translate() {
	iconv -f utf-8 -t ascii//TRANSLIT | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9 ]//g' | sed 's/ /_/g'
}

rm -rf /tmp/types/* types.db assoc.db 2>/dev/null || true
mkdir /tmp/types 2>/dev/null || true

$qdb -l index.db | while read link flags name; do
	test -f $link/type || continue
	cat $link/type | while read type; do
		test ! -z "$type" || continue;
		typeid="`echo $type | translate`"
 		$qdb -p "$typeid:$type" types.db >/dev/null
		echo $link >> /tmp/types/$typeid
	done
done

ls /tmp/types | while read type; do
	songs="`cat /tmp/types/$type | tr '\n' ' '`"
	$qdb -p"$type:$songs" assoc.db >/dev/null
done
