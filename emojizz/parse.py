import json
import re

with open('emoji.json') as data_file:
    data = json.load(data_file)

result = {}
for element in data:
    result[element['unified']] = element['name']

stringResult = "["
j = 0
for key in result.keys():
    if result[key]:
        words = result[key].split()
        stringResult += "\"U+" + key[:5] + "\":["
        for i in range(len(words)-1):
            stringResult += "\"" + words[i] + "\","
        stringResult += "\"" + words[len(words)-1] + "\""
        stringResult += "],"

stringResult = stringResult[:-1]
stringResult += "]"

# print(result)
print("Opening result file")
resultFile = open('emoji.txt', 'r+')
print("Writing result")
resultFile.write(stringResult)
print("All good.")
