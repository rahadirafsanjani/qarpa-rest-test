from faker import Faker

class generator:
    def __init__(self):
        self.fake = Faker("id_ID")

    def make_name(self, length_name):
        length_name = int(length_name)
        name = self.fake.name()
        while len(name) < length_name:
            name += ' ' + self.fake.last_name()
        return name[:length_name]

    def make_email(self, length_email):
        if int(length_email) <= 0 :
            return "@mail.com"
        elif int(length_email) <= 20 :
            return self.fake.email()
        else :
            length_email = int(length_email) - 9
            email = self.fake.first_name()
            while len(email) < length_email:
                email += self.fake.last_name()
            return email[:length_email] + "@mail.com"
    
    def make_password(self, length_password):
        length_password = int(length_password)
        return self.fake.password(length=length_password, special_chars=True, digits=True, upper_case=True, lower_case=True)
    