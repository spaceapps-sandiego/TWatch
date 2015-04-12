from astropy.time import Time
import astropy.units as u
from astropy.coordinates import FK5, SkyCoord

fk5_2000 = FK5(equinox=Time(2000, format='jyear', scale='utc'))

def convert_to_j2000(ra, dec, mjd):
	equinox = Time(mjd, format='mjd')
	sc = SkyCoord(ra=ra, dec=dec, unit='deg', frame=FK5, equinox=equinox)
	j2000_c = sc.transform_to(fk5_2000)
	return j2000_c.ra.value, j2000_c.dec.value

def convert_from_j2000(ra, dec):
	sc = SkyCoord(ra=ra, dec=dec, unit='deg', frame=FK5)
	fk5_now = FK5(equinox=Time.now())
	now_c = sc.transform_to(fk5_now)
	return now_c.ra.value, now_c.dec.value