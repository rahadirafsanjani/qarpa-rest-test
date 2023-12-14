from faker import Faker
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

    def get_leave_submission_by_id(self, leave_list, target_id):
        for task in leave_list:
            if task.get("id") == target_id:
                return task
        return None  # ID not found

    