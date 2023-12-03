import random
from geopy.geocoders import Nominatim
from datetime import datetime

class generator:
    ADDRESS_LIST =  [
            "Jl. Thamrin, Jakarta",
            "Jl. Gubernur Suryo, Surabaya",
            "Jl. Dago, Bandung",
            "Jl. Balai Kota, Medan",
            "Jl. Pahlawan, Semarang",
            "Jl. Pettarani, Makassar",
            "Jl. Sudirman, Palembang",
            "Jl. Margonda Raya, Depok",
            "Jl. Jendral Sudirman, Tangerang",
            "Jl. Ahmad Yani, Bekasi",
            "Jl. Padang Barat, Padang",
            "Jl. ZA Pagar Alam, Bandar Lampung",
            "Jl. Gatot Subroto, Denpasar",
            "Jl. Jenderal Sudirman, Pekanbaru",
            "Jl. A. Yani, Banjarmasin",
            "Jl. P. Antasari, Samarinda",
            "Jl. Ijen, Malang",
            "Jl. Dr. Sukarjo, Tasikmalaya",
            "Jl. Jend. Sudirman, Manado",
            "Jl. Malioboro, Yogyakarta"
        ]

    def __init__(self):
        self.geolocator = Nominatim(user_agent="city_coordinates_generator")
        self.result_latlong = {}

    def generate_lat_long(self, index=None):
        if index is None:
            index = self._get_valid_random_index()
            if index is None:
                return None  # Handle the case where a valid index cannot be obtained

        try:
            location = self.geolocator.geocode(self.ADDRESS_LIST[index])
        except Exception as e:
            print(f"Error geocoding address '{self.ADDRESS_LIST[index]}': {e}")
            return None

        if location:
            self.result_latlong["address"] = self.ADDRESS_LIST[index]
            self.result_latlong["latitude"] = location.latitude
            self.result_latlong["longitude"] = location.longitude
            return self.result_latlong
        else:
            return None

    def _get_valid_random_index(self, start=0, end=19):
        while True:
            index = self._get_random_index(start, end)
            if index is not None:
                return index

    def _get_random_index(self, start=0, end=19):
        if start > end:
            return None  # Handle the case where start is greater than end
        return random.randint(start, end)

    def current_time(self):
        now = datetime.now()
        formatted_time = now.strftime("%H:%M:%S.%f")[:-3]
        return formatted_time

    def timestamp(self):
        now = datetime.now()
        formatted_time = now.strftime("%m-%d-%Y %H:%M:%S.%f")
        return formatted_time
