sqlUtility = open('db_init.sql', 'w+', encoding='utf-8')

tables = ["movies", "ratings", "tags", "users"]
for tableNames in tables:
    sqlUtility.write("DROP TABLE IF EXISTS " + tableNames + ";\n")


# create 'movies' table

sqlUtility.write(('CREATE TABLE \'movies\' (\n' +
                  '\'id\' INTEGER PRIMARY KEY,\n' +
                  '\'title\' TEXT NOT NULL,\n' +
                  '\'year\' INTEGER,\n' +
                  '\'genres\' TEXT NOT NULL);\n'))

insert = 'INSERT INTO \'movies\' VALUES\n'

movies = open('../dataset/movies.csv', 'r')
movies.readline()

for movie in movies:
    split = movie.split(',')
    movie_id = int(split[0])
    title = ''
    genre = split[len(split)-1][:-1]
    for i in range(1, len(split) - 1):
        title += (split[i] + ',')
    if title[0] != '"':
        title = title[:-1]
    else:
        title = title[1:len(title) - 2]

    if title.rfind("(") != -1:
        left = title.rfind("(") + 1
        right = title.rfind(")")
        year = title[left: right]

    if year != "":
        title = title[:-7]
        insert += ('({0},"{1}", {2}, "{3}"),\n').format(movie_id,
                                                        title, year, genre)
    else:
        year = "NULL"
        ('({0},"{1}", {2}, "{3}"),').format(movie_id,
                                            title, year, genre)


insert = insert[:-2] + ';'
sqlUtility.write(insert)
movies.close()

sqlUtility.write('\n\n')

# create ratings.csv


sqlUtility.write('CREATE TABLE \'ratings\' (\n' +
                 '\'id\' INTEGER PRIMARY KEY,\n' +
                 '\'user_id\' INTEGER NOT NULL,\n' +
                 '\'movie_id\' INTEGER NOT NULL,\n' +
                 '\'rating\' REAL NOT NULL,\n' +
                 '\'timestamp\' INTEGER NOT NULL);\n')


ratings = open('../dataset/ratings.csv')
ratings.readline()

insert = (
    'INSERT INTO \'ratings\' (\'user_id\', \'movie_id\', \'rating\', \'timestamp\') VALUES\n')

for line in ratings:
    split = line.split(',')
    user_id = split[0]
    movie_id = split[1]
    rating = split[2]
    timestamp = split[3][:len(split[3]) - 1]
    insert += ('({0},{1},{2},{3}),\n').format(
        user_id, movie_id, rating, timestamp)

insert = insert[:-2] + ';'

sqlUtility.write(insert)
ratings.close()

sqlUtility.write('\n\n')

# create 'tags' table

tags = open('../dataset/tags.csv')
tags.readline()

sqlUtility.write('CREATE TABLE \'tags\' (\n' +
                 '\'id\' INTEGER PRIMARY KEY,\n' +
                 '\'user_id\' INTEGER NOT NULL,\n' +
                 '\'movie_id\' INTEGER NOT NULL,\n' +
                 '\'tag\' TEXT NOT NULL,\n' +
                 '\'timestamp\' INTEGER NOT NULL);\n')

insert = (
    'INSERT INTO \'tags\' (\'user_id\', \'movie_id\', \'tag\', \'timestamp\') VALUES\n')

for tag in tags:
    split = tag.split(',')
    user_id = split[0]
    movie_id = split[1]
    tag1 = split[2]
    timestamp = split[3][:- 1]
    insert += ('({0},{1},"{2}",{3}),\n').format(user_id,
                                                movie_id, tag1, timestamp)

insert = insert[:-2] + ';'

sqlUtility.write(insert)
tags.close()

sqlUtility.write('\n\n')

# create 'users' table

sqlUtility.write('CREATE TABLE \'users\' (\n' +
                 '\'id\' INTEGER PRIMARY KEY,\n' +
                 '\'name\' TEXT NOT NULL,\n' +
                 '\'email\' TEXT NOT NULL,\n' +
                 '\'gender\' TEXT NOT NULL,\n' +
                 '\'register_date\' TEXT NOT NULL,\n' +
                 '\'occupation\' TEXT NOT NULL);\n')

users = open('../dataset/users.txt', 'r')

insert = (
    'INSERT INTO \'users\' (\'id\', \'name\', \'email\', \'gender\', \'register_date\', \'occupation\') VALUES\n')

for user in users:
    split = user.split('|')
    id = split[0]
    name = split[1]
    email = split[2]
    gender = split[3]
    register_date = split[4]
    occupation = split[5][:-1]
    insert += ('({0},"{1}","{2}","{3}","{4}","{5}"),\n')\
        .format(id, name, email, gender, register_date, occupation)

insert = insert[:-2] + ';'

sqlUtility.write(insert)
users.close()
sqlUtility.write('\n\n')
