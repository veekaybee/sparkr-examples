#####
# Imports changelog from Spark Git repo
# git log --pretty=format:"%h %ad%x09%an%x09%s" --date=short >log.txt
# And pulls out commit lables
#####

import re
from collections import Counter

features_list=[]

regex = r"\[[A-Z]+\]" #regex to match to extract tags like [SQL]

with open("log.txt") as f:
	for line in f:
		elements = line.split("\t")
		hash_date = elements[0] #commit hash and date
		author = elements[1]
		commit_message = elements[2]
		date = hash_date[8:] #just date
		if re.search(regex, commit_message):
			match = re.search(regex, commit_message)
			print(match.group(0),date)
			date_tag = (match.group(0),date)
			features_list.append(date_tag)

print(features_list)

feature_counter = Counter(features_list)
sorted_feature_counter = sorted(feature_counter.items(), key=lambda pair: pair[1], reverse=True)

# #top_20_commits = feature_counter.most_common(40)


for i in sorted_feature_counter:
	print(i[0],i[1])
