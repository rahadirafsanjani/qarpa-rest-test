from faker import Faker
from datetime import datetime
import random
import string

class generator:
    def __init__(self):
        self.fake = Faker("id_ID")

    def date_future(self):
        return  self.fake.date_between(start_date='today', end_date='+60d').strftime('%Y-%m-%d')
    def date_past(self):
        return  self.fake.date_between(start_date='-60d', end_date='today').strftime('%Y-%m-%d')
    
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
    
        
    def make_sentence_only_white_space(self, length, whitespace=True):
        if length < 0:
            return "Length must be a non-negative integer."

        characters = ""
        if whitespace:
            characters += string.whitespace

        if not characters:
            return "No valid character set selected."

        # Generate a random sentence of the specified length
        sentence = ''.join(random.choice(characters) for _ in range(length))

        return sentence
    
    def count_date(self, date_str1, date_str2):
        date_format = "%Y-%m-%d"
        date1 = datetime.strptime(date_str1, date_format)
        date2 = datetime.strptime(date_str2, date_format)
        date_difference = date1 - date2
        days_difference = date_difference.days
        return days_difference
    
    def get_task_by_id(self, task_list, target_id):
        for task in task_list:
            if task.get("id") == target_id:
                return task
        return None  # ID not found
    
    def count_task_status(self, task_list):
        todo_count = sum(1 for task in task_list if task["status"] == "todo")
        done_count = sum(1 for task in task_list if task["status"] == "done")
        return {"todo_task_count": todo_count, "done_task_count": done_count}