import scrapy
from scrapy.shell import inspect_response

class BauhausSpider(scrapy.Spider):
    name = "bauhaus"

    def start_requests(self):
        urls = [
            'https://www.bauhaus.dk/farve-bolig/maling-lak-olie/udendoers-brug?produkttype=177197%2C177453%2C336409'
        ]
        for url in urls:
            yield scrapy.Request(url=url, callback=self.parse)

    def parse(self, response):
        inspect_response(response, self)