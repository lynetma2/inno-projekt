import scrapy
import re

class FluggerSpider(scrapy.Spider):
    name = "flugger"

    def start_requests(self):
        urls = [
            'https://www.flugger.dk/udendoers/c-794768/?page=2'
        ]
        for url in urls:
            yield scrapy.Request(url=url, callback=self.parse)

    def parse(self, response):
        for product in response.css('#content > div.layout__content > div.plp-page > div > div.plp-page-inner__product-section > div > div.product-list__content > div'):
            link = product.css('div > div > a::attr(href)').get()
            yield response.follow(url = link, callback=self.parse_maling)
    
    def parse_maling(self, response):
        navn = response.css('#content > div.layout__content > div.pdp-page > div.image-price-section > div > div > div:nth-child(2) > section > div > h1::text').get()
        varenummer = response.css('#content > div.layout__content > div.pdp-page > div.image-price-section > div > div > div:nth-child(2) > div > div > div.summary > ul > li:nth-child(5) > span:nth-child(2)::text').get()
        stovtor = response.css('#content > div.layout__content > div.pdp-page > div:nth-child(2) > section > div > div.row.information-section__row > div.col-xs-12.col-md-5.col-md-offset-1 > div > div:nth-child(1) > div.data-display__text > ul > li:nth-child(1) > span::text').get()
        gentor = response.css('#content > div.layout__content > div.pdp-page > div:nth-child(2) > section > div > div.row.information-section__row > div.col-xs-12.col-md-5.col-md-offset-1 > div > div:nth-child(1) > div.data-display__text > ul > li:nth-child(2) > span::text').get()
        haerde = response.css('#content > div.layout__content > div.pdp-page > div:nth-child(2) > section > div > div.row.information-section__row > div.col-xs-12.col-md-5.col-md-offset-1 > div > div:nth-child(1) > div.data-display__text > ul > li:nth-child(3) > span::text').get()
        img = response.css('#content > div.layout__content > div.pdp-page > div.image-price-section > div > div > div:nth-child(1) > div > picture > source:nth-child(1)::attr(data-srcset)').get()

        def clean_number(text):
            time = re.findall(r'\d+', text)
            if ("time" in text.lower()):
                return int(time[0])
            elif ("døgn" in text.lower()):
                return int(time[0]) * 24 

        #Cleaning fields
        stovtor = stovtor[stovtor.index(":") +1:]
        stovtor = clean_number(stovtor)
        gentor = gentor[gentor.index(":") +1:]
        gentor = clean_number(gentor)
        haerde = haerde[haerde.index(":") +1:]
        haerde = clean_number(haerde)

        yield {
            'navn' : navn,
            'varenummer' : varenummer,
            'img' : img,
            'støvtør' : stovtor,
            'Genbehandlingstør' : gentor,
            'Gennemhærdet' : haerde,
            'url' : response.request.url,
        }