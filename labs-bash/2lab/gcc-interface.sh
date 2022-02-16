#!/usr/bin/env bash

# 11. Написать скрипт, выполняющий следующие действия:
# выводит меню, содержащее все файлы с расширением .c текущего каталога.
# После выбора пользователем файла, компилирует его.

select SOURCE_FILE in $(find $PWD -maxdepth 1 -type f -name '*.c'); do
    OUTPUT_FILE=${SOURCE_FILE%.c}
    gcc -o $OUTPUT_FILE $SOURCE_FILE
    echo "Source \"$(basename $SOURCE_FILE)\" compiled to \"$(basename $OUTPUT_FILE)\""
done
