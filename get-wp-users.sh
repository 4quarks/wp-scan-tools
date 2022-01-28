#!/bin/bash

curl https://$1/wp-json/wp/v2/users | jq . > users_info.json

total_pos_user=$(cat users_info.json | jq length);
echo "Total Users Found: "  $total_pos_user;
all_users=()
for i in $(eval echo {0..$((total_pos_user -1))});
do
  echo "-------- NEW USER ---------";
  test=$(cat users_info.json | jq .[$i]);
  for tag in id name slug description;
    do
      result=$(echo $test | jq . |  grep -Po "\""$tag""\"': *\K"*[^"]*' | sed 's/[",]//g';);
      echo  "$tag" "$result";
      if [ $(echo "$tag") = "slug" ];
        then
          all_users+=( "$result" );
      fi;
    done;
done;

echo "---------------------------"
echo "** List Users **";
printf '%s\n' "${all_users[@]}";
printf '%s\n' "${all_users[@]}" > users
