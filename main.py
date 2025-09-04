import pandas as pd
import random

# Load data
characters = pd.read_csv("anime_traits.csv")
traits_info = pd.read_csv("definitions.csv")

# Normalize all text
characters = characters.applymap(lambda x: str(x).strip().lower() if isinstance(x, str) else x)
traits_info['trait'] = traits_info['trait'].str.strip().str.lower()

# Make a list of all traits
all_traits = list(traits_info['trait'])

# Initial fixed 6 traits to ask first
fixed_traits = [
    "student", "alien", "magic user", "ninja", "robot", "detective"
]

# Fallback if fixed traits not found
fixed_traits = [t for t in fixed_traits if t in all_traits]

# Remaining traits to ask randomly after fixed
remaining_traits = [t for t in all_traits if t not in fixed_traits]
random.shuffle(remaining_traits)

# All questions = 6 fixed + random ones
questions = fixed_traits + remaining_traits

# Keep track of answers
answers = {}

print("🧠 Think of an anime character, and I’ll try to guess who it is!")
print("Answer with: yes / no / maybe")

# Ask up to 20 questions max
for trait in questions[:20]:
    # Get definition from trait_info
    definition_row = traits_info[traits_info['trait'] == trait]
    definition = definition_row['definition'].values[0] if not definition_row.empty else f"Does your character have the trait '{trait}'?"

    # Ask question
    user_input = input(f"\n🤔 {definition}\nAnswer about '{trait}': (yes/no/maybe): ").strip().lower()
    if user_input not in ['yes', 'no', 'maybe']:
        print("❌ Please answer with: yes / no / maybe.")
        continue

    answers[trait] = user_input

    # Filter characters after each question
    def character_matches(row):
        for trait, answer in answers.items():
            if row.get(trait, '') not in [answer, 'maybe', '']:
                return False
        return True

    filtered_characters = characters[characters.apply(character_matches, axis=1)]

    if len(filtered_characters) == 1:
        name = filtered_characters.iloc[0]['name']
        print(f"\n🎉 I guess your character is: {name.title()}!")
        break
    elif len(filtered_characters) == 0:
        print("\n😢 I couldn't find any matching character.")
        break

# Final fallback
if len(filtered_characters) > 1:
    print("\n🤔 I couldn't be sure, but possible characters are:")
    for name in filtered_characters['name'].head(5):
        print(f"👉 {name.title()}")
