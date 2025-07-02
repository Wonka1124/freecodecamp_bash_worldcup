# База данных "worldcup" (PostgreSQL)

База данных "worldcup" предназначена для хранения информации о футбольных матчах чемпионатов мира, командах и результатах игр. Используется для анализа статистики и выполнения SQL-запросов.

## Структура базы данных

### Таблицы

- **teams** — команды
  - `team_id` SERIAL PRIMARY KEY
  - `name` VARCHAR(50) NOT NULL UNIQUE

- **games** — матчи
  - `game_id` SERIAL PRIMARY KEY
  - `year` INTEGER NOT NULL
  - `round` VARCHAR(50) NOT NULL
  - `winner_id` INTEGER NOT NULL REFERENCES teams(team_id)
  - `opponent_id` INTEGER NOT NULL REFERENCES teams(team_id)
  - `winner_goals` INTEGER NOT NULL
  - `opponent_goals` INTEGER NOT NULL

## Связи между таблицами

- Каждая команда может участвовать во множестве матчей как победитель (`games.winner_id`) или как соперник (`games.opponent_id`).
- Внешние ключи обеспечивают целостность данных между таблицами `games` и `teams`.

## Пример инициализации базы данных

```sql
CREATE DATABASE worldcup;
\c worldcup

CREATE TABLE teams (
  team_id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE games (
  game_id SERIAL PRIMARY KEY,
  year INTEGER NOT NULL,
  round VARCHAR(50) NOT NULL,
  winner_id INTEGER NOT NULL REFERENCES teams(team_id),
  opponent_id INTEGER NOT NULL REFERENCES teams(team_id),
  winner_goals INTEGER NOT NULL,
  opponent_goals INTEGER NOT NULL
);
```

## Импорт данных

Для загрузки данных из CSV-файла используется bash-скрипт, который:
- Добавляет команды в таблицу `teams` (без дублирования)
- Добавляет матчи в таблицу `games` с указанием года, раунда, команд и голов
- Использует переменную PSQL для подключения к нужной базе данных

Пример запуска:
```bash
bash insert_data.sh
```

## Примеры SQL-запросов

Второй bash-скрипт позволяет выполнять различные статистические запросы, например:
- Общее количество голов
- Среднее количество голов
- Список команд, участвовавших в определённом раунде
- Победители турниров по годам

Пример запуска:
```bash
bash queries.sh
```

## Примечания

- Для тестирования используется отдельная база `worldcuptest` (см. условие в скрипте).
- Все внешние ключи и уникальные ограничения уже настроены.
- Данные можно импортировать с помощью скрипта или вручную через psql. 