#!/bin/bash

cd `dirname $0`
make -C ../
echo ""
for test in tests/Error.txt
do
	echo $test
	while read -r line
	do
		RESULT=`../push_swap $line 2>&1`
		if [ "$RESULT" != "Error" ]; then
			echo "Fail test: $line"
		fi
	done < "$test"
	echo ""
done
for test in tests/NotError.txt
do
	echo $test
	while read -r line
	do
		RESULT=`../push_swap $line 2>&1`
		if [ "$RESULT" == "Error" ]; then
			echo "Fail test: $line"
		fi
	done < "$test"
	echo ""
done
for test in tests/100_random.txt tests/500_random.txt tests/5_random.txt tests/Ordered.txt
do
	echo $test
	max=0
	min=100000
	while read -r line
	do
		RESULT=`../push_swap $line | ./checker_linux $line`
		moves=`../push_swap $line | wc -l`
		if [ "$RESULT" != "OK" ]; then
			echo -ne "$RESULT\nOn test: $line"
		fi
		if [[ $moves -gt $max ]]; then
			max=$moves
		fi
		if [[ $moves -lt $min ]]; then
			min=$moves
		fi
	done < "$test"
	echo "min = $((min)); max = $((max))"
	echo ""
done
