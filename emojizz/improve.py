import json
import re
import operator

result = "["
with open('resources/faces.json') as data_file1:
    data = json.load(data_file1)
    for key in data:
        result += "\"" + key + "\":["
        for word in data[key]:
            result += "\"" + word.lower() + "\","
        result = result[:-1]
        result += "],"
with open('resources/nature.json') as data_file2:
    data = json.load(data_file2)
    for key in data:
        result += "\"" + key + "\":["
        for word in data[key]:
            result += "\"" + word.lower() + "\","
        result = result[:-1]
        result += "],"
with open('resources/objects.json') as data_file3:
    data = json.load(data_file3)
    for key in data:
        result += "\"" + key + "\":["
        for word in data[key]:
            result += "\"" + word.lower() + "\","
        result = result[:-1]
        result += "],"
with open('resources/places.json') as data_file4:
    data = json.load(data_file4)
    for key in data:
        result += "\"" + key + "\":["
        for word in data[key]:
            result += "\"" + word.lower() + "\","
        result = result[:-1]
        result += "],"
with open('resources/symbols.json') as data_file5:
    data = json.load(data_file5)
    for key in data:
        result += "\"" + key + "\":["
        for word in data[key]:
            result += "\"" + word.lower() + "\","
        result = result[:-1]
        result += "],"
result = result[:-1]
result += "]"
print(result)
# resultFile = open('resources/faces2.json', 'r+')
# resultFile.seek(0)
# resultFile.truncate()
# test = json.dump(data, False)
# print(test)
# print("Writing result")
with open('resources/faces2.json', 'w') as outfile:
    json.dump(data, outfile)
# resultFile.write(data)
