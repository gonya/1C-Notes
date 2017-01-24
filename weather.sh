#!/bin/bash


# Просмотр текущей погоды от Яндекс в zenity

# Ссылка на Яндекс погоду для города
LINK="https://yandex.ru/pogoda/usole-sibirskoe"

#=======================================================================

DATA="$(wget -qO - "$LINK" | tr -d '\n|\r|\t' | grep -o '<div class="content">.*</div></div><div class="forecasts' | sed 's/></>\n</g')"
[ -z "$DATA" ] && { echo "Не удалось получить данные."; exit; }

CRNT_CITY="$(echo "$DATA" | grep '<h1 class="title title_level_1">' | sed -s 's/<[^>]*>//g;s/&nbsp;//')"
CRNT_TEMP="$(echo "$DATA" | grep '<div class="current-weather__thermometer current-weather__thermometer_type_now">' | sed -s 's/<[^>]*>//g')"
WEATHER="$(echo "$DATA" | grep '<span class="current-weather__comment">' | sed -s 's/<[^>]*>//g')"
DATA_UPD_INFO="$(echo "$DATA" | grep '<div class="current-weather__info-row current-weather__info-row_type_time">' | sed -s 's/<[^>]*>//g')"
OTHER_DATA="$(echo "$DATA" | grep '<span class="current-weather__info-label">' | sed -s 's/<[^>]*>//g;s/Закат/  Закат/')"
DAY_PARTS="$(echo "$DATA" | tr -d '\n' | grep -o '<span class="current-weather__thermometer-name">.*<span class="current-weather__col current-weather' \
| sed 's/<[^>]*>//g; s/днём/днём /; s/ночью/\n ночью /; s/<span class="current-weather__col current-weather//')"

echo  "$CRNT_CITY (${DATA_UPD_INFO}) $CRNT_TEMP $WEATHER $DAY_PARTS $OTHER_DATA " | sed ':a;N;$!ba;s/\n/ /g'
echo  " (${DATA_UPD_INFO}) $CRNT_TEMP $WEATHER $DAY_PARTS " | sed ':a;N;$!ba;s/\n/ /g' | sed 's/−/ минус /g' 
echo  " (${DATA_UPD_INFO}). $CRNT_TEMP. $WEATHER. $DAY_PARTS " | sed ':a;N;$!ba;s/\n/ /g' |  sed 's/−/ минус /g' | sed 's/°C/ градусов /g' |  RHVoice-client  -s Anna+CLB | aplay
