import csv

f = open("images.txt", "a")

with open('all_images.csv') as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=',')
    line_count = 0
    for row in csv_reader:
        if line_count == 0:
            print(f'Column names are {", ".join(row)}')
            line_count += 1
        else:
            #print(f'\t{row[0]} works in the {row[1]} department, and was born in .')
            url = "https://snapshotserengeti.s3.msi.umn.edu" + row[1] + "\n"
            f.write(url)
            line_count += 1
    print(f'Processed {line_count} lines.')

f.close()