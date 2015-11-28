import json
import re
import operator

with open('emoji.json') as data_file:
    data = json.load(data_file)

result = {}
for element in data:
    result[element['unified']] = element['name']


# TODO: find better tags
# TODO: this script only work for unicode emojis with 5 chars in the unicode. A lot of emojis are missing !!
stringResult = "["
for key in result.keys():
    if result[key] and len(key) == 5:
        words = result[key].split()
        emoji = '\U000' + key[:5]
        emoji = emoji.decode('unicode-escape')
        stringResult += "\"" + emoji + "\":["
        for word in words:
            if word.lower() not in ['with', 'and', 'symbol']:
                stringResult += "\"" + word.lower() + "\","
        stringResult = stringResult[:-1]
        stringResult += "],"

stringResult = stringResult[:-1]
stringResult += "]"

# sorted_tags = sorted(tags.items(), key=operator.itemgetter(1))
# print(sorted_tags)
print(stringResult)
print("Opening result file")
resultFile = open('emoji.txt', 'r+')
resultFile.seek(0)
resultFile.truncate()
print("Writing result")
resultFile.write(stringResult)
print("All good.")
