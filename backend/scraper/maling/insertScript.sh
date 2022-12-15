#!/bin/bash
#python test_empty.py && rm maling.json &&
#    scrapy crawl flugger -L CRITICAL -o maling.json:json &&
#    sed 's/\\n[ \t]*//g' maling.json | python insert.py &&
#    echo "inserted paints into database"
#exit 0
#echo "new file"
if python test_empty.py ;
    then
        rm maling.json &&
        scrapy crawl flugger -L CRITICAL -o maling.json:json &&
        sed 's/\\n[ \t]*//g' maling.json | python insert.py &&
        echo "inserted paints into database"
        exit 0
    else
        exit 0
fi
