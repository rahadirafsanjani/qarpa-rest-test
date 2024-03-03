from faker import Faker
import datetime
import random
import pytz

class DataBuilder:
    def __init__(self):
        self.fake = Faker("id_ID")

    def base_time(self, tz='Asia/Jakarta'):
        current_time = datetime.datetime.now(pytz.timezone(tz)).strftime('%Y-%m-%dT%H:%M:%S.%f%z')
        return current_time

    def future_time(self, days=1, tz='Asia/Jakarta'):
        current_time = datetime.datetime.now(pytz.timezone(tz))
        future_time = current_time + datetime.timedelta(days=days)
        future_time = future_time.strftime('%Y-%m-%dT%H:%M:%S.%f%z')
        return future_time

    def past_time(self, days=1, tz='Asia/Jakarta'):
        current_time = datetime.datetime.now(pytz.timezone(tz))
        past_time = current_time - datetime.timedelta(days=days)
        past_time = past_time.strftime('%Y-%m-%dT%H:%M:%S.%f%z')
        return past_time

    def time_same_day(self, tz='Asia/Jakarta'):
        current_time = datetime.datetime.now(pytz.timezone(tz))

        future_hour = random.randint(current_time.hour + 1, 23)
        future_minute = random.randint(0, 59)
        future_second = random.randint(0, 59)

        future_time = datetime.datetime(
            year=current_time.year,
            month=current_time.month,
            day=current_time.day,
            hour=future_hour,
            minute=future_minute,
            second=future_second
        )

        future_time = pytz.timezone(tz).localize(future_time)

        current_time_str = current_time.strftime('%Y-%m-%dT%H:%M:%S.%f%z')
        future_time_str = future_time.strftime('%Y-%m-%dT%H:%M:%S.%f%z')

        return {"current_time": current_time_str, "future_time": future_time_str}

    def basic_sentence(self, length):
        faker = Faker("id_ID")
        sentence = faker.sentence()
        words = faker.words(length)
        sentence = ' '.join(words)
        return sentence[:length]

    def format_set_sentence(self, length, charset):
        if charset == "ASCII":
            chars = ''.join(chr(i) for i in range(32, 127))
        elif charset == "Unicode":
            chars = ''.join(chr(i) for i in range(0x20, 0x7F)) + ''.join(chr(i) for i in range(0x00A1, 0x00FF))
        elif charset == "ISO8859":
            chars = ''.join(chr(i) for i in range(0x20, 0x7F)) + ''.join(chr(i) for i in range(0xA0, 0xFF))
        elif charset == "EBCDIC":
            chars = ''.join(chr(i) for i in range(64, 128))
        else:
            raise ValueError("Invalid charset specified.")
        
        return ''.join(random.choice(chars) for _ in range(length))
    
    def count_date(self, start_at, end_at):
        date_format = "%Y-%m-%dT%H:%M:%S.%f%z"
        start_date = datetime.datetime.strptime(start_at, date_format).date()
        end_date = datetime.datetime.strptime(end_at, date_format).date()
        date_difference = end_date - start_date
        days_difference = date_difference.days

        return days_difference

    def reformat_date(self, datetime_string):
        try:
            original_datetime = datetime.datetime.strptime(datetime_string, "%Y-%m-%dT%H:%M:%S.%f%z")
        except ValueError:
            return "Invalid datetime format. Please provide a datetime string in the format 'YYYY-MM-DDTHH:MM:SS.ssssss±HH:MM'."
        
        reformatted_date = original_datetime.strftime("%Y-%m-%d")
        
        return reformatted_date
        
    def get_task_by_id(self, task_list, target_id):
        for task in task_list:
            if task.get("id") == target_id:
                return task
        return None
    
    def count_task_status(self, task_list):
        todo_count = sum(1 for task in task_list if task["status"] == "todo")
        done_count = sum(1 for task in task_list if task["status"] == "done")
        return {"todo_task_count": todo_count, "done_task_count": done_count}
