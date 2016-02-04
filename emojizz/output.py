import json
import plistlib

with open('result.json') as data_file:
    data = json.load(data_file)
    # result = '['
    # for key, value in data.iteritems():
    #     result += "\"" + key + "\": ["
    #     for word in value:
    #         result += "\"" + word.lower() + "\","
    #     result = result[:-1]
    #     result += '],'
    # result = result[:-1]
    # result += ']'

print(data)
with open('EmojiList.plist', 'w') as outfile:
    try:
        plistlib.writePlist(data, outfile)
    finally:
        outfile.close()

# print(result)
