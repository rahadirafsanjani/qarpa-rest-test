from DataBuilder import DataBuilder

# Creating an instance of DataBuilder
builder = DataBuilder()

# Example usage
print("Base Time:", builder.base_time())
print("Future Time (1 day):", builder.future_time(days=2))
print("Past Time (1 day):", builder.past_time(days=1))
print("Time Same Day:", builder.time_same_day())
