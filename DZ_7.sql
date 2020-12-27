1. Создать нового пользователя и задать ему права доступа на базу данных «Страны и города мира».
USE geodata;
CREATE USER 'test_user'@'%' IDENTIFIED WITH mysql_native_password BY 'password';
GRANT ALL PRIVILEGES ON geodata TO 'test_user'@'%';
FLUSH PRIVILEGES;

2. Сделать резервную копию базы, удалить базу и пересоздать из бекапа.
- Запустить в cmd: mysqldump -u root -p geodata > geodata_full_db.sql
- DROP DATABASE `geodata`;
  CREATE DATABASE geodata;
- Запустить в cmd: mysql -u root -p geodata < geodata_full_db.sql