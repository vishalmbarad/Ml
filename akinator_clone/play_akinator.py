import akinator

def main():
    aki = akinator.Akinator()
    first_question = aki.start_game()
    print("Akinator asks:", first_question)
    while not aki.finished:
        ans = input("Answer ([y]/[n]/[i]/p/pn, or b to go back): ").strip().lower()
        if ans == "b":
            try:
                print("Previous question:", aki.back())
            except akinator.CantGoBackAnyFurther:
                print("Cannot go back further.")
        else:
            try:
                aki.answer(ans)
                print("Next question:", aki.question)
            except akinator.InvalidChoiceError:
                print("Invalid answer — try again.")
    aki.win
    
    print("\n--- Akinator’s Guess ---")
    print("Name:", aki.name_proposition)
    print("Description:", aki.description_proposition)
    print("Image:", aki.photo)


if __name__ == "__main__":
    main()
