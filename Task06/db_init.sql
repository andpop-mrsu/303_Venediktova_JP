drop table if exists 'Direction';
drop table if exists 'discipline';
drop table if exists 'plan';
drop table if exists 'student';
drop table if exists 'marks';


pragma foreign_keys = on;

create table 'Direction'(
    id integer primary key not null unique,
    name varchar not null
);

create table 'discipline'(
    id integer primary key autoincrement,
    name varchar unique not null
);

create table 'plan'(
    id integer primary key autoincrement,
    assessmentType varchar default 'exam' check (assessmentType == 'exam' or assessmentType == 'offset'),
    disciplineId integer not null,
    semesterNumber integer check (semesterNumber >= 1 and semesterNumber <= 8),
    planId integer not null,
    foreign key (disciplineId) references discipline(id) on delete cascade,
    foreign key (planId) references Direction(id) on delete restrict
);



create table if not exists `group`(
    id integer primary key autoincrement,
    startDate varchar not null,
    groupNumber integer not null
);

create table 'student'(
    studentsNumber integer primary key not null unique,
    name varchar not null,
    surname varchar not null,
    lastname varchar not null,
    sex varchar check (sex == 'мужской' or sex == 'женский'),
    birthDate varchar not null,
    groupId integer not null,
    DirectionId integer not null,
    foreign key (DirectionId) references Direction(id) on delete restrict,
    foreign key (groupId) references `group`(id) on delete restrict
);

create table 'marks'(
    id integer primary key autoincrement,
    mark integer check(mark >= 3 and mark <= 5),
    studentId integer not null,
    disciplineId integer not null,
    foreign key (studentId) references student(studentsNumber) on delete cascade,
    foreign key (disciplineId) references discipline(id) on delete restrict
);



insert into Direction(id, name) values
(1, 'Математика и компьютерные науки'),
(3, 'Прикладная математика и информатика');

insert into discipline(name) values
('Математический анализ'),
('Экономика'),
('Базы данных'),
('Функциональный анализ'),
('Уравнения математической физики'),
('Теоретическая механика'),
('Правоведение'),
('Физика'),
('История'),
('Аналитическая геометрия'),
('Алгоритмы и структуры данных');

insert into plan(assessmentType, disciplineId, semesterNumber, planId)
select 'exam', id, 1, 1 from discipline where name='Математический анализ'
union
select 'exam', id, 1, 1 from discipline where name='Функциональный анализ'
union
select 'offset', id, 1, 1 from discipline where name='История'
union
select 'exam', id, 1, 1 from discipline where name='Аналитическая геометрия'
union
select 'offset', id, 1, 1 from discipline where name='Алгоритмы и структуры данных'
union
select 'offset', id, 5, 3 from discipline where name='Экономика'
union
select 'exam', id, 5, 3 from discipline where name='Базы данных'
union
select 'exam', id, 5, 3 from discipline where name='Уравнения математической физики'
union
select 'exam', id, 5, 3 from discipline where name='Теоретическая механика'
union
select 'offset', id, 5, 3 from discipline where name='Право'
union
select 'offset', id, 5, 3 from discipline where name='Физика';

insert into `group`(startDate, groupNumber) values
('2020-09-01', 3),
('2021-09-01', 4);

insert into student(studentsNumber, name, surname, lastname, sex, birthDate, groupId, DirectionId)
select 253456, 'Яна', 'Венедиктова', 'Петровна', 'женский', '2002-07-10', id, 3 from `group` where startDate = '2020-09-01'
union
select 253457, 'Дарья', 'Акимова', 'Анатольевна', 'женский', '2001-04-12', id, 3 from `group` where startDate = '2020-09-01'
union
select 253458, 'Алина', 'Помелова', 'Сергеевна', 'женский', '2002-06-14', id, 3 from `group` where startDate = '2020-09-01'
union
select 253459, 'Анна', 'Бугреева', 'Валерьевна', 'женский', '2002-04-28', id, 3 from `group` where startDate = '2020-09-01'
union
select 253460, 'Антон', 'Прокопенко', 'Сергеевич', 'мужской', '2002-08-03', id, 3 from `group` where startDate = '2020-09-01'
union
select 253461, 'Данил', 'Прокопенко', 'Сергеевич', 'мужской', '2002-08-03', id, 3 from `group` where startDate = '2020-09-01'
union
select 253472, 'Анна', 'Климахина', 'Ивановна', 'женский', '2003-11-01', id, 1 from `group` where startDate = '2021-09-01'
union
select 253473, 'Дарья', 'Пиняйкина', 'Валерьевна', 'женский', '2003-10-12', id, 1 from `group` where startDate = '2021-09-01'
union
select 253474, 'Данил', 'Железнов', 'Викторович', 'мужской', '2003-11-10', id, 1 from `group` where startDate = '2021-09-01'
union
select 253476, 'Михаил', 'Тырин', 'Константинович', 'мужской', '2003-12-30', id, 1 from `group` where startDate = '2021-09-01'
union
select 253477, 'Данил', 'Величкин', 'Петрович', 'мужской', '2003-10-01', id, 1 from `group` where startDate = '2021-09-01';

insert into marks(mark, studentId, disciplineId)
select 4, 253456, id from discipline where name='Экономика'
union
select 4, 253456, id from discipline where name='Физика'
union
select 4, 253456, id from discipline where name='Теоретическая механика'
union
select 5, 253456, id from discipline where name='Базы данных'
union
select 3, 253456, id from discipline where name='Право'
union
select 5, 253456, id from discipline where name='Уравнения математической физики'
union
--
select 4, 253457, id from discipline where name='Экономика'
union
select 4, 253457, id from discipline where name='Физика'
union
select 3, 253457, id from discipline where name='Теоретическая механика'
union
select 5, 253457, id from discipline where name='Базы данных'
union
select 3, 253457, id from discipline where name='Право'
union
select 4, 253457, id from discipline where name='Уравнения математической физики'
union
--
select 5, 253458, id from discipline where name='Экономика'
union
select 5, 253458, id from discipline where name='Физика'
union
select 5, 253458, id from discipline where name='Теоретическая механика'
union
select 5, 253458, id from discipline where name='Базы данных'
union
select 5, 253458, id from discipline where name='Право'
union
select 5, 253458, id from discipline where name='Уравнения математической физики'
union
--
select 4, 253459, id from discipline where name='Экономика'
union
select 4, 253459, id from discipline where name='Физика'
union
select 5, 253459, id from discipline where name='Теоретическая механика'
union
select 5, 253459, id from discipline where name='Базы данных'
union
select 4, 253459, id from discipline where name='Право'
union
select 3, 253459, id from discipline where name='Уравнения математической физики'
--
union
select 5, 253472, id from discipline where name='Математический анализ'
union
select 3, 253472, id from discipline where name='Функциональный анализ'
union
select 5, 253472, id from discipline where name='Алгоритмы и структуры данных'
union
select 5, 253472, id from discipline where name='Аналитическая геометрия'
union
select 4, 253472, id from discipline where name='История'
--
union
select 5, 253473, id from discipline where name='Математический анализ'
union
select 5, 253473, id from discipline where name='Функциональный анализ'
union
select 4, 253473, id from discipline where name='Алгоритмы и структуры данных'
union
select 5, 253473, id from discipline where name='Аналитическая геометрия'
union
select 5, 253473, id from discipline where name='История'
--
union
select 3, 253474, id from discipline where name='Математический анализ'
union
select 4, 253474, id from discipline where name='Функциональный анализ'
union
select 4, 253474, id from discipline where name='Алгоритмы и структуры данных'
union
select 4, 253474, id from discipline where name='Аналитическая геометрия'
union
select 5, 253474, id from discipline where name='История'
--
union
select 3, 253476, id from discipline where name='Математический анализ'
union
select 3, 253476, id from discipline where name='Функциональный анализ'
union
select 3, 253476, id from discipline where name='Алгоритмы и структуры данных'
union
select 4, 253476, id from discipline where name='Аналитическая геометрия'
union
select 4, 253476, id from discipline where name='История'



