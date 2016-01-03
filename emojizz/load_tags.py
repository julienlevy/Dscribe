import json

result = {}

def load(file_name):
    with open(file_name) as data_file:
        data = json.load(data_file)
        for key in data:
            result[key] = data[key]

for name in ['faces.json', 'nature.json', 'objects.json', 'places.json', 'symbols.json']:
    print(name)
    load('resources/' + name)

with open('resources/flags.json') as data_file:
    data = json.load(data_file)
    for element in data:
        result[element['emoji']] = [element['name'].lower()]

with open('resources/github_tags.json') as data_file:
    data = json.load(data_file)
    for key, obj in data.iteritems():
        if obj['char'] in result.keys():
            for word in obj['keywords']:
                if word not in result[obj['char']]:
                    result[obj['char']].append(word)


# Write in file
with open('result.json', 'w') as outfile:
    json.dump(result, outfile)
