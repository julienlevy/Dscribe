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
        result[element['emoji']] = [element['name'].lower(), 'flag', 'country']

with open('resources/github_tags.json') as data_file:
    data = json.load(data_file)
    for key, obj in data.iteritems():
        if obj['char'] in result.keys():
            for word in obj['keywords']:
                if word not in result[obj['char']]:
                    result[obj['char']].append(word)

with open('resources/github_tags_ios9.json') as data_file:
    data = json.load(data_file)
    for key, obj in data.iteritems():
        obj['keywords'].append(key)
        if obj['char'] in result.keys():
            for word in obj['keywords']:
                if word not in result[obj['char']]:
                    result[obj['char']].append(word)
        else:
            result[obj['char']] = obj['keywords']

# Write in file
with open('result.json', 'w') as outfile:
    json.dump(result, outfile)
