--добавление 5 пользователей
insert into users(name, email, gender, register_date, occupation)
    select 'Sergey Akaikin', 'akaikin@mail.ru', 'male', date('now'), 'student';

insert into users(name, email, gender, register_date, occupation)
    select 'Daria Akimova', 'akimova@gmail.com', 'female', date('now'), 'student';

insert into users(name, email, gender, register_date, occupation)
    select 'Anna Bugreeva', 'bugreeva@mail.ru', 'female', date('now'), 'student';

insert into users(name, email, gender, register_date, occupation)
    select 'Aleksey Artamonov', 'artamonov@mail.ru', 'male', date('now'), 'student';

insert into users(name, email, gender, register_date, occupation)
    select 'Yana Venediktova', 'jankavenediktova@mail.ru', 'female', date('now'), 'student';

--добавление 3 фильмов

insert into movies(title, year) values
('Major Grom', 2021),
('Revolver', 2005),
('What We Do in the Shadows', 2014);

insert into movies_genres(movie_id, genre_id) select id, (select id from genres where name == 'Crime') from movies where title == 'Major Grom';
insert into movies_genres(movie_id, genre_id) select id, (select id from genres where name == 'Crime') from movies where title == 'Revolver';
insert into movies_genres(movie_id, genre_id) select id, (select id from genres where name == 'Comedy') from movies where title == 'What We Do in the Shadows';

--добавление 3 отзывов

insert into tags_contents(tag) values('incredible');
insert into tags(user_id, movie_id, tag_id, timestamp) select
                                                           (select id from users where name == 'Yana Venediktova'),
                                                           (select id from movies where title == 'Major Grom'),
                                                           (select max(id) from tags),
                                                           strftime('%s', 'now');

insert into tags_contents(tag) values('unexpected turn');
insert into tags(user_id, movie_id, tag_id, timestamp) select
                                                           (select id from users where name == 'Yana Venediktova'),
                                                           (select id from movies where title == 'Revolver'),
                                                           (select max(id) from tags),
                                                           strftime('%s', 'now');

insert into tags_contents(tag) values('breathtaking');
insert into tags(user_id, movie_id, tag_id, timestamp) select
                                                           (select id from users where name == 'Yana Venediktova'),
                                                           (select id from movies where title == 'What We Do in the Shadows'),
                                                           (select max(id) from tags),
                                                           strftime('%s', 'now');