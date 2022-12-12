#!/bin/bash
python test_empty.py && rm maling.json &&
    scrapy crawl flugger -L CRITICAL -o maling.json:json &&
    sed 's/\\n[ \t]*//g' maling.json | python insert.py &&
    echo "inserted paints into database"
