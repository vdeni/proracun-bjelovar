import subprocess

from datetime import datetime

import requests as req

from api_info import api_key

api_url = 'https://transparentnost.bjelovar.hr/api'

# init empty list for results
results = []

# call API to get data for each month. year range has to be entered manually!
for year in [2020]:
    print(f'====>>>> Godina: {year}')

    for month in range(1, 13):
        print(f'=====>>>>> Mjesec: {month}')

        rez = req.post(url=api_url,
                       headers={'api_key': api_key},
                       json={
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
filename = f'proracun_{datetime.utcnow().strftime("%Y-%m-%d_%H-%M")}.csv'

with open(filename, 'w+') as ofile:
    ofile.write(''.join(results))

# remove repeating headers
subprocess.run(['sed', '-i', '-e',
                "2,${/id,oib,name/d}",
                filename])
