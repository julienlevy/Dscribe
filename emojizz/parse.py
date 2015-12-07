import json
import re
import operator

with open('emoji.json') as data_file:
    data = json.load(data_file)

result = {}
for element in data:
    code = element['unified']
    if len(code) == 5:
        emoji = '\U000' + code[:len(code)]
    if len(code) == 4:
        emoji = '\U0000' + code[:len(code)]
    else:
        code = code.split('-')[0]
        if len(code) == 5:
            emoji = '\U000' + code[:len(code)]
        if len(code) == 4:
            emoji = '\U0000' + code[:len(code)]
    result[emoji] = element['name']


# TODO: find better tags
stringResult = "["
emojiArray = "["
tagDict = {}
for key in result.keys():
    if result[key]:
        words = result[key].split()
        emoji = key.decode('unicode-escape')
        stringResult += "\"" + emoji + "\":["
        emojiArray += "\"" + emoji + "\":1,"
        for word in words:
            if word.lower() not in ['with', 'and', 'symbol']:
                stringResult += "\"" + word.lower() + "\","
            if word.lower() == 'smiling':
                stringResult += "\"smile\","
            print(word)
            tag = str(word.lower())
            if tag in tagDict:
                tagDict[tag] += 1
            else:
                tagDict[tag] = 1
        stringResult = stringResult[:-1]
        stringResult += "],"

stringResult = stringResult[:-1]
stringResult += "]"

emojiArray = emojiArray[:-1]
emojiArray += "]"

mostUsedTags = sorted(tagDict.items(), key=operator.itemgetter(1))


print(stringResult)
print("Opening result file")
resultFile = open('emoji.txt', 'r+')
resultFile.seek(0)
resultFile.truncate()
print("Writing result")
# resultFile.write(stringResult)
print("All good.")
# print(emojiArray)
# print(mostUsedTags)
