import json
import re
import operator

with open('resources/faces.json') as data_file:
    data = json.load(data_file)
    for key in data:
        print(key)
        print(data[key])
        data[key].append('people')
print(data)
# resultFile = open('resources/faces2.json', 'r+')
# resultFile.seek(0)
# resultFile.truncate()
# test = json.dump(data, False)
# print(test)
# print("Writing result")
with open('resources/faces2.json', 'w') as outfile:
    json.dump(data, outfile)
# resultFile.write(data)
