import json
import re
import operator

with open('emoji.json') as data_file:
    data = json.load(data_file)

result = {}
for element in data:
    result[element['unified']] = element['name']

stringResult = "["
for key in result.keys():
    if result[key]:
        words = result[key].split()
        stringResult += "\"U+" + key[:5] + "\":["
        for word in words:
            if word.lower() not in ['with', 'and', 'symbol']:
                stringResult += "\"" + word.lower() + "\","
        stringResult = stringResult[:-1]
        stringResult += "],"

stringResult = stringResult[:-1]
stringResult += "]"

# sorted_tags = sorted(tags.items(), key=operator.itemgetter(1))
# print(sorted_tags)

print("Opening result file")
resultFile = open('emoji.txt', 'r+')
print("Writing result")
resultFile.write(stringResult)
print("All good.")
