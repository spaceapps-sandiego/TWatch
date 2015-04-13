# TWatch
Transient Watch NASA Space Challenge

## JSON API
Make sure you have the follow installed before continuing:

### Requirements

#### Mac OS X
1. brew (which you can install [here](http://brew.sh))
2. pip (you can install through `sudo easy_install pip`)
3. mysql (`brew install mysql`)
4. Python requirements (`sudo pip install -r requirements.txt`)

#### Start up
1. You'll need to set up the tables in mysql: `mysql -u root -p < scripts/transients.sql`
2. From the root directory run: `python provider/api.py`

### Reference

#### `GET /api/v1/transients`
Get all of the transients

##### Parameters
```
lean {bool} : if true, events will be queried
```

#### `GET /api/v1/transients/:id`
Get transient by id

##### Parameters
```
lean {bool} : if true, events will be queried
```

#### `GET|POST /api/v1/convert`
Convert from J2000 to current epoch

##### Parameters
```
ra {float} : right ascension
dec {float} : declination
```

## iOS App
TODO