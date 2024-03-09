from DataBuilder import DataBuilder

def datetime():
    # Creating an instance of DataBuilder
    builder = DataBuilder()
    
    # Example usage
    print("Base Time:", builder.base_time())
    print("Future Time (1 day):", builder.future_time(days=2))
    print("Past Time (1 day):", builder.past_time(days=1))
    print("Time Same Day:", builder.time_same_day())
    print("====================================================================================================")

def sentence_format():
    # Create an instance of MyClass
    my_object = DataBuilder()

    # Define parameters to test
    lengths = [40]  # Specify different lengths
    charsets = ["ASCII", "Unicode", "ISO8859", "EBCDIC"]  # Specify different charsets

    # Test all combinations of parameters
    for length in lengths:
        for charset in charsets:
            try:
                formatted_sentence = my_object.format_set_sentence(length, charset)
                print(f"For length={length} and charset={charset}:")
                print("Formatted Sentence:", formatted_sentence)
            except ValueError as e:
                print(f"Error: {e}")

    print("====================================================================================================")

if __name__ == "__main__":
    sentence_format()
    datetime()