from faker import Faker
from datetime import datetime
import datetime
import random
import pytz
import string

class DataBuilder:
    def __init__(self):
        self.fake = Faker("id_ID")

    def date_future(self):
        return  self.fake.date_between(start_date='today', end_date='+60d').strftime('%Y-%m-%d')
    def date_past(self):
        return  self.fake.date_between(start_date='-60d', end_date='today').strftime('%Y-%m-%d')

    def generate_random_time():
        # Waktu saat ini
        current_time = datetime.datetime.now()

        # Ambil tahun, bulan, dan tanggal dari waktu saat ini
        year = current_time.year
        month = current_time.month
        day = current_time.day

        # Waktu acak pada hari yang sama dengan waktu saat ini
        future_time = datetime.datetime(year, month, day,
                                        hour=random.randint(current_time.hour + 1, 23),
                                        minute=random.randint(0, 59),
                                        second=random.randint(0, 59))

        # Mengonversi ke zona waktu yang diinginkan (misalnya, Waktu Indonesia Barat)
        tz = pytz.timezone('Asia/Jakarta')
        current_time = tz.localize(current_time)
        future_time = tz.localize(future_time)

        # Format waktu dalam string yang diinginkan
        current_time_str = current_time.strftime('%Y-%m-%dT%H:%M:%S.%f%z')
        future_time_str = future_time.strftime('%Y-%m-%dT%H:%M:%S.%f%z')

        return current_time_str, future_time_str


    def default_sentence(self):
        return  self.fake.text(max_nb_chars=40)

    def make_sentence(self, length, digits=False, punctuation=False, whitespace=False):
        if length < 0:
            return "Length must be a non-negative integer."

        characters = string.ascii_letters
        if digits:
            characters += string.digits
        if punctuation:
            characters += string.punctuation
        if whitespace:
            characters += string.whitespace

        if not characters:
            return "No valid character set selected."

        # Generate a random sentence of the specified length
        sentence = ''.join(random.choice(characters) for _ in range(length))

        return sentence


# Sample Usage
# past_sameday, future_sameday = generate_random_time()
# print("past_sameday =", past_sameday)
# print("future_sameday =", future_sameday)
