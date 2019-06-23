import csv
import random

csvInput = input("CSV import filename (ex. template, ex2. datasheet): ")
userInput2 = input("TXT output filename (ex. quiz, ex2. new_quiz): ")
userInput = input("Randomly generate how many questions? ")


class QuizGenerator:

    with open(csvInput + ".csv", 'r') as csv_file:
        csv_reader = csv.reader(csv_file)
        rows = list(csv_reader)
        mQuest = [
            list(rows[0]), list(rows[1]), list(rows[2]), list(rows[3]), list(rows[4]),
            list(rows[5]), list(rows[6]), list(rows[7]), list(rows[8]), list(rows[9]),
            list(rows[10]), list(rows[11]), list(rows[12]), list(rows[13]), list(rows[14]),
            list(rows[15]),list(rows[16]),list(rows[17]),list(rows[18]),list(rows[19])
        ]
        mChoice = [
            list(rows[21]), list(rows[22]), list(rows[23]), list(rows[24])
        ]

        def __init__(self, mod):
            self.length = mod
            self.rlist = list(range(0, int(len(self.mQuest[0]))))
            random.shuffle(self.rlist)
            self.id = str(self.rlist[0:int(mod)]).replace("[", "").replace("]", "").replace(", ", ":")
            self.fileName = userInput2 + ".txt"

        def questloop(self):
            count = 0
            zero = 0
            file = open(self.fileName, "a+")
            choices = ["A", "B", "C", "D"]
            file.write("QID  " + self.id + "\n\n\nNAME = []\n_________________________________________"
                                           "________________________________\n\n\n")
            while count < int(self.length):
                z_modifier = self.rlist[zero]
                for x in range(0, 20):
                    if self.mQuest[x][z_modifier] != "":
                        file.write(self.mQuest[x][z_modifier] + "\n")
                    else:
                        continue
                file.write("\n")
                count += 1
                zero += 1
                for i in range(0, 4):
                    file.write(choices[i] + ") " + self.mChoice[i][z_modifier] + "\n")
                file.write("\nAnswer = []\n\n_________________________________________"
                           "________________________________\n\n\n")
            file.write("made with stan's quiz generator")
            file.close()


tag = QuizGenerator(userInput)
tag.questloop()





