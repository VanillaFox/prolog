import re
names = []
ID = []
parents = []
sexs = []

with open ('family.ged', 'r', encoding ='utf-8' ) as file:
    for line in file:
        content = line.replace('\n','')
        match = re.search(r'(\w+)\s/(\w+)/', content)
        if match is not None:
            match = match.group(1)+' '+match.group(2)
            names.append(match)
        match1 = re.search(r':I(\d+)', content)
        if match1 is not None:
            match1 = int(match1.group(1))
            ID.append(match1)
        sex = re.search(r'SEX\s([FM]){1}', content)
        if sex is not None:
            sex = sex.group(1)
            sexs.append(sex)
        match2 = re.search(r'HUSB\s@I(\d+)@', content)
        if match2 is not None:
            match2 = int(match2.group(1))
            parents.append(match2)
        match3 = re.search(r'WIFE\s@I(\d+)@', content)
        if match3 is not None:
            match3 = int(match3.group(1))
            parents.append(match3)
        match4 = re.search(r'CHIL\s@I(\d+)@', content)
        if match4 is not None:
            match4 = int(match4.group(1))
            parents.append(match4)
        end = re.search(r':F(\d+)', content)
        if end is not None:
            parents.append(0)
keys = dict(zip(ID, names))
res_sex=[]

for i in range(len(sexs)):
    if sexs[i]=='F':
        al='female(\'', names[i], '\')'
        res_sex.append(al)
for i in range(len(sexs)):
    if sexs[i]=='M':
        al='male(\'', names[i], '\')'
        res_sex.append(al)

res_chil=[]
b1=0
for i in range(len(parents)):
    if (parents[i]!=0) and (i!=b1) and (i!=b1+1):
        alic='child(\'', keys[parents[i]], '\', \'', keys[parents[b1]], '\')'
        res_chil.append(alic)
        alic='child(\'', keys[parents[i]], '\', \'', keys[parents[b1+1]], '\')'
        res_chil.append(alic)
    elif parents[i]==0:
        b1=i+1

outfile = open('cw.pl', 'w', encoding ='utf-8')

for i in res_sex:
    outfile.write(i[0]+i[1]+i[2]+'.\n')
outfile.write('\n')

for i in res_chil:
    outfile.write(i[0]+i[1]+i[2]+i[3]+i[4]+'.\n')

outfile.close()
