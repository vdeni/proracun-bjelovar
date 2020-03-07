import subprocess

import requests as req

from api_info import api_key

api_url = 'https://transparentnost.bjelovar.hr/api'

# init empty list for results
results = []

# call API to get data for each month
for year in [2018, 2019]:
    for month in range(1, 13):
        rez = req.post(url = api_url,
                       headers = {'api_key': api_key},
                       json = {
                           'method': 'filter',
                           'output': 'csv',
                           'filter': [
                               {'filter': 'date',
                                'selector': '>=',
                                'query': f'01.{month:02}.{year}.'},
                               {'filter': 'date',
                                'selector': '<=',
                                'query': f'31.{month:02}.{year}.'}
                           ]
                       })

        results.append(rez.text)

# write data to file
with open('proracun.csv', 'w+') as ofile:
    ofile.write(''.join(results))

# remove repeating headers
subprocess.run(['sed', '-i', '-e',
                "2,${/id,oib,name/d}",
                'proracun.csv'])
