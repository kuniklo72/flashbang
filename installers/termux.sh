#!/data/data/com.termux/files/usr/bin/bash

echo "                             "
echo " ┏━╸╻  ┏━┓┏━╸╻ ╻┏┓ ┏━┓┏━┓┏━┓ "
echo " ┣━╸┃  ┣━┫┗━┓┣━┫┣┻┓┣━┫┃ ┃┃╺┓ "
echo " ╹  ┗━╸╹ ╹╺━┛╹ ╹┗━┛╹ ╹╹ ╹┗━┛ "
echo " ╺┳╸┏━┓┏━╸╺┳╸┏━┓╻  ╻  ┏━╸┏━┓ "
echo "  ┃ ┃ ┃┗━┓ ┃ ┣━┫┃  ┃  ┣╸ ┣┳┛ "
echo " ╺┻╸╹ ╹╺━┛ ╹ ╹ ╹┗━╸┗━╸┗━╸╹┗╸ "
echo "  https://t.me/FlashbangApp  "
echo "                             "
set -e

echo "Оновлюю пакунки..."
pkg upgrade -y > /dev/null 2>&1 || { echo "Помилка при оновленні пакунків"; exit 1; }

echo "Встановлюю python..."
pkg install python -y > /dev/null 2>&1 || { echo "Помилка при встановленні Python"; exit 1; }

echo "Перевіряю версію Python..."
PYTHON_VERSION=$(python -c "import sys; print('.'.join(map(str, sys.version_info[:2])))")
echo "Виявлено встановлений Python $PYTHON_VERSION"

echo "Створюю папку flashbang..."
mkdir -p flashbang
cd flashbang

echo "Завантажую відповідний .pyc файл..."
case $PYTHON_VERSION in
    3.8|3.9|3.10|3.11|3.12)
        wget "https://github.com/kuniklo72/flashbang/raw/main/pyc/flashbang-userbot-python-$PYTHON_VERSION.pyc" -O flashbang.pyc > /dev/null 2>&1 || { echo "Помилка при завантаженні .pyc файлу"; exit 1; }
        ;;
    *)
        echo "Непідтримувана версія Python: $PYTHON_VERSION. Встановіть Python 3.8-3.12"
        exit 1
        ;;
esac

echo "Створюю віртуальне середовище..."
python -m venv venv > /dev/null 2>&1

echo "Активую віртуальне середовище..."
source venv/bin/activate

echo "Встановлюю залежності..."
pip install $(wget -qO- "https://github.com/kuniklo72/flashbang/raw/main/requirements.txt")
 > /dev/null 2>&1

echo "Створюю скрипт для запуску юзербота..."
cat > launch.sh << EOL
#!/bin/bash
set -e
cd $(pwd)
source venv/bin/activate
python flashbang.pyc
deactivate
cd -
EOL

chmod +x launch.sh
mkdir ~/.shortcuts
cp launch.sh ~/.shortcuts/flashbang.sh
chmod +x ~/.shortcuts/flashbang.sh

echo "Встановлення завершено успішно!"
echo ""
echo "Запустити юзербота: flashbang/launch.sh"
echo "Або встановіть ярлик через Termux:Widget"	
