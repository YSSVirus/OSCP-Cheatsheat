if [[ $# -eq 3 ]]; then
	file=$1
	start=$2
	end=$3
	cat $file | awk '{print substr($0, 1, length($0)-'$end')}' | sed 's/'$start'\(.*\)/\1/'
else
	echo "Need more or less arguments"
	echo "Example: word_regex.sh unformatted_list.txt <how_many_letters_to_take_off_the_front_of_every_word(has to be in periods)> how_many_letters_to_take_off_the_end_of_every_word>"
	echo "Example: word_regex.sh unformatted_list.txt ... 5"
fi
