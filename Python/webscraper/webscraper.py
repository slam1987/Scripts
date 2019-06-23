from bs4 import BeautifulSoup as Bs
import requests


class WebScrape:

    specsList = []
    manufacturerList = []
    priceList = []

    def __init__(self):

        self.scrapeUrl = 'www.memoryexpress.com/Category/HardDrives'
        self.pageContent = requests.get('https://' + self.scrapeUrl)
        self.soup = Bs(self.pageContent.content, 'html5lib')
        self.soup.get_text()
        self.manufacturer()
        self.specs()
        self.price()

    def manufacturer(self):
        for mod in self.soup.find_all('div', class_="c-shca-icon-item"):
            if "ADATA" in str(mod):
                var1 = mod.find('span', class_="c-shca-icon-item__body-name-brand")\
                    .get_text().replace(' ', '').replace("\n", "")
                self.manufacturerList.append(var1)
            else:
                var2 = mod.find('div', class_="c-shca-icon-item__body-name").find("img")["title"]
                self.manufacturerList.append(var2)

    def specs(self):
        for mod in self.soup.find_all("div", class_="c-shca-icon-item__body"):
            modx = mod.find("div", class_="c-shca-icon-item__body-name").get_text().replace("\n", "").replace("  ", "")\
                .replace("ADATA", "")
            self.specsList.append(modx)

    def price(self):
        for mod in self.soup.find_all("div", class_="c-shca-icon-item__summary"):
            modx = mod.find("div", class_="c-shca-icon-item__summary-list").find("span").get_text().replace(" ", "")\
                .replace("\n", "")
            self.priceList.append(modx)

    def output(self):
        quantity = len(self.manufacturerList)
        repeat = range(0, quantity)
        for x in repeat:
            print(self.manufacturerList[x])
            print(self.specsList[x])
            print(self.priceList[x] + "\n")


result = WebScrape()
result.output()
