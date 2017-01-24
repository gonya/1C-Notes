#!/bin/bash

# Просмотр текущей погоды от Яндекс в zenity

# Ссылка на Яндекс погоду для города
LINK="https://pogoda.yandex.ru/moscow"

#=======================================================================

DATA="$(wget -qO - "$LINK" | tr -d '\n|\r|\t' | grep -o '<div class="content">.*</div></div><div class="forecasts' | sed 's/></>\n</g')"
[ -z "$DATA" ] && { echo "Не удалось получить данные."; exit; }

echo "$DATA"

CRNT_CITY="$(echo "$DATA" | grep '<h1 class="title title_level_1">' | sed -s 's/<[^>]*>//g;s/&nbsp;//')"
echo "================="
echo "$CRNT_CITY"

CRNT_TEMP="$(echo "$DATA" | grep '<div class="current-weather__thermometer current-weather__thermometer_type_now">' | sed -s 's/<[^>]*>//g')"
WEATHER="$(echo "$DATA" | grep '<span class="current-weather__comment">' | sed -s 's/<[^>]*>//g')"
DATA_UPD_INFO="$(echo "$DATA" | grep '<div class="current-weather__info-row current-weather__info-row_type_time">' | sed -s 's/<[^>]*>//g')"
OTHER_DATA="$(echo "$DATA" | grep '<span class="current-weather__info-label">' | sed -s 's/<[^>]*>//g;s/Закат/  Закат/')"
DAY_PARTS="$(echo "$DATA" | tr -d '\n' | grep -o '<span class="current-weather__thermometer-name">.*<span class="current-weather__col current-weather' \
| sed 's/<[^>]*>//g; s/днём/днём /; s/ночью/\nночью /; s/<span class="current-weather__col current-weather//')"

echo -e "\n$CRNT_CITY:\n(${DATA_UPD_INFO})\n\n$CRNT_TEMP\n$WEATHER\n\n$DAY_PARTS\n\n$OTHER_DATA\n" | sed 's/^/\t/g'
