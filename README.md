# Курсовая работа по БД

![](https://i.imgur.com/ZkPF21W.jpg)

**Предметная область**: съемки кино

## Съемки кино v2.0

(Переделано под бизнес процессы)

Существуют кинокомпании, которые осуществляют съемку фильмов.

Фильмы снимаются на нескольких площадках в котором участвует множество сотрудников. К сотрудникам относятся:

* Актеры
* Дублеры
* Режиссеры
* Сценаристы
* Кинооператоры

С каждым их них необходимо заключить договор найма, который при желании можно было бы распечатать для документооборота

Также для отчетности и аналитики нужно сохранить кроме ФИО сотрудников их стаж (в годах).

Для составления синопсиса фильма и выделения дополнительных зарплат - необходимо также добавить роли. Например, человека который занимал главную роль можно вывести в синопсис и при успехе фильма добавить премию.

Возвращаясь к фильму, то для него нужно подготовить несколько сцен. Поэтому при запросе по фильму нужно иметь доступ ко всем данным сцен, которые есть в фильме и какие реквизиты для него нужны для предварительной подготовки до самого процесса съемок.

Чтобы сохранить порядок все сцены должны иметь порядковый номер, соответствующий порядковому номеру в фильме.

Дополнительно, нужно предусмотреть закупку камер, микрофонов и прочих инструментов, чтобы у каждого оператора было достаточное количество оборудования и прикрепить каждое из них к сцене, чтобы при переходе из одной сцены в другую (если сцены расположены в разных местах) не тратить много времени.

Также продюсеру всей съемки необходимо видеть общий процесс съемки, включая текущую активную сцену, сотрудников которые в нём участвуют, чтобы затем составить корректное расписание и примерный срок сдачи проекта.

Каждый фильм должен получить уникальный идентификатор из Всемирного Общества Кино (он гарантирует, что у каждого фильма будет идентификатор)

Модель:

![](https://i.imgur.com/KipK7yt.jpg)

<<<<<<< HEAD
| Прецедент №1 | Создание компании |
| ---- | ---- |
| Предусловие | - |
| Действие | Все данные о компании заносятся в табличку `company` |

| Прецедент №2 | Создание фильма |
| ---- | ---- |
| Предусловие | Идентификатор фильма должен быть получен из всемирного общества кино, чтобы его можно было однозначно идентифицировать. Также должна быть создана информация о компании (`Прецедент №1`) |
| Действие | Заносятся данные о фильме, включая его уникальный идентификатор. Все кроме синопсиса являются уникальными идентификаторами. |

| Прецедент №3 | Добавление работника |
| ---- | ---- |
| Предусловие №1 | Должна быть известна полная информация о работнике для его идентификации. В это входят: документ (паспорт, свидетельство о рождении и тд), тип документа, номер трудовой книжки (если есть) |
| Предусловие № 2 | Имя, фамилия, возраст, пол и краткая биография |
| Действие | Сначала проверяется существует ли запись `employee` уже добавляемого работника. Для этого должно выполнится предусловие 1. <br /><br />Далее, если работник с такими документами еще не создан, то вышеперечисленные данные заносятся в таблички `employee` и `employee_docs`. <br /><br />В ином случае, новая записать не создается |

| Прецедент №4 | Изменение данных работника |
| ---- | ---- |
| Предусловие | Данные о работнике уже должны быть созданы (прецедент 3) |
| Действие | По запросу работника или компании могут быть изменены данные о работниках. Это действие может быть вызвано изменением серийного номера паспорта, получение паспорта (если работник раньше не имел паспорта), изменение типа документа.<br />Данные заносятся в соответствующие таблицы. |

| Прецедент №5 | Добавление опыта работы                                      |
| ------------ | ------------------------------------------------------------ |
| Предусловие  | Данные о работнике уже должны быть созданы (прецедент 3). Должны быть известные следующие данные об опыте работы:<br />* дата начала и окончания<br />* краткое описание<br />* роль в фильме<br />* идентификатор фильма (не является внешним ключом)<br /> |
| Действие     | Данные об опыте работе заносятся в табличку `experience` с указанием `employee_id` |

| Прецедент №6 | Заключение контракта                                     |
| ------------ | -------------------------------------------------------- |
| Предусловие  | Данные о работнике уже должны быть созданы (прецедент 3) |
| Действие     | Данные о контракте добавляются в табличку `contract`     |

| Прецедент №7 | Получение данных о документах работника                      |
| ------------ | ------------------------------------------------------------ |
| Предусловие  | Данные о работнике уже должны быть созданы (прецедент 3)     |
| Действие     | Делается запрос в таблицу `contaract` с id работника. Таким образом, мы получим все документы принадлежащие данному работнику. |

| Прецедент №8 | Узнать действующие договора с работником                     |
| ------------ | ------------------------------------------------------------ |
| Предусловие  | Данные о работнике уже должны быть созданы (прецедент 3)     |
| Действие     | Делается запрос в таблицу `contaract` с id работника. Получаем start_date и end_date, которые представляют собой интервал действия договора. Дополнительно, можно проверить флаг interrupted, означающий что договор был расторгнут. Запись расторжения записывается в interrupted_date |

| Прецедент №9 | Добавление роли в кино                                       |
| ------------ | ------------------------------------------------------------ |
| Предусловие  | Данные о работнике уже должны быть созданы (прецедент 3)     |
| Действие     | Заполняется соответствующая таблица с `employee_id` и `film_id` |

| Прецедент №10 | Создание сцены                                          |
| ------------- | ------------------------------------------------------- |
| Предусловие   | Должен быть создан фильм (прецедент 2)                  |
| Действие      | Заполняется таблица `scene` с соответствующим `film_id` |

| Прецедент №11 | Добавление расписания для сцен                               |
| ------------- | ------------------------------------------------------------ |
| Предусловие   | Должна существовать сцена для которой создается расписание (прецедент 10) |
| Действие      |                                                              |

| Прецедент №9 | Добавление роли в кино                                       |
| ------------ | ------------------------------------------------------------ |
| Предусловие  | Данные о работнике уже должны быть созданы (прецедент 3)     |
| Действие     | Заполняется соответствующая таблица с `employee_id` и `film_id` |

| Прецедент №9 | Добавление роли в кино                                       |
| ------------ | ------------------------------------------------------------ |
| Предусловие  | Данные о работнике уже должны быть созданы (прецедент 3)     |
| Действие     | Заполняется соответствующая таблица с `employee_id` и `film_id` |

| Прецедент №9 | Добавление роли в кино                                       |
| ------------ | ------------------------------------------------------------ |
| Предусловие  | Данные о работнике уже должны быть созданы (прецедент 3)     |
| Действие     | Заполняется соответствующая таблица с `employee_id` и `film_id` |
=======
>>>>>>> 31757b7e72ea7939b0310d1cda8bbc27a08cc395
