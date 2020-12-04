#!/usr/bin/env sh


byr='\<byr:(19[2-9][0-9]|200[0-2])\>' # (Birth Year) - four digits; at least 1920 and at most 2002.
iyr='\<iyr:20(1[0-9]|20)\>' # (Issue Year) - four digits; at least 2010 and at most 2020.
eyr='\<eyr:20(2[0-9]|30)\>' # (Expiration Year) - four digits; at least 2020 and at most 2030.
hgt='\<hgt:(1([5-8][0-9]|9[0-3])cm|(59|6[0-9]|7[0-6])in)\>' # (Height) - a number followed by either cm or in:
# If cm, the number must be at least 150 and at most 193.
# If in, the number must be at least 59 and at most 76.
hcl='\<hcl:#[0-9a-f]{6}\>' # (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
ecl='\<ecl:(amb|b(lu|rn)|gr[yn]|hzl|oth)\>' # (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
pid='\<pid:[0-9]{9}\>' # (Passport ID) - a nine-digit number, including leading zeroes.
# cid (Country ID) - ignored, missing or not.

cmd="sed -nE '/./H;\$b c;/^$/b c;b;:c;{x;s/\\n/ /gm;/$byr/{/$iyr/{/$eyr/{/$hgt/{/$hcl/{/$ecl/{/$pid/p}}}}}}}' day4-input.txt"

bash -c "$cmd"
bash -c "$cmd | wc -l"
echo "$cmd | wc -l"
