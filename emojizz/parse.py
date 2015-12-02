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
emojiArray = "["
for key in result.keys():
    if result[key] and len(key) <= 5:
        words = result[key].split()
        if len(key) == 5:
            emoji = '\U000' + key[:len(key)]
        if len(key) == 4:
            emoji = '\U0000' + key[:len(key)]
        emoji = emoji.decode('unicode-escape')
        stringResult += "\"" + emoji + "\":["
        emojiArray += "\"" + emoji + "\":1,"
        for word in words:
            if word.lower() not in ['with', 'and', 'symbol']:
                stringResult += "\"" + word.lower() + "\","
        stringResult = stringResult[:-1]
        stringResult += "],"
    else:
        print key

stringResult = stringResult[:-1]
stringResult += "]"

emojiArray = emojiArray[:-1]
emojiArray += "]"

# sorted_tags = sorted(tags.items(), key=operator.itemgetter(1))
# print(sorted_tags)
# print(stringResult)
print("Opening result file")
resultFile = open('emoji.txt', 'r+')
resultFile.seek(0)
resultFile.truncate()
print("Writing result")
# resultFile.write(stringResult)
print("All good.")
print(emojiArray)
